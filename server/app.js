const express = require('express'); // Import Express
const mysql = require('mysql'); // Import MySQL
const cors = require('cors'); // Import CORS
const bcrypt = require('bcrypt'); // Import bcrypt for password hashing
const session = require('express-session'); // Import session management

const app = express(); // Create an instance of Express

// Middleware setup
app.use(cors()); // Enable CORS
app.use(express.json()); // Parses incoming requests with JSON payloads
app.use(session({
    secret: 'your_secret_key', // Replace with your secret key
    resave: false,
    saveUninitialized: true
}));

const con = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'mbproject'
});
module.exports = con;

// Your route definitions
app.post('/login', function (req, res) {
    const { username, password } = req.body;

    // Query the database to check if the user exists
    const sql = 'SELECT * FROM users WHERE username = ?';
    con.query(sql, [username], function (err, result) {
        if (err) {
            console.error('Error querying database:', err);
            return res.status(500).json({ error: 'Error querying database' });
        }

        // Check if the user exists
        if (result.length === 0) {
            // If no user found, return invalid username error
            return res.status(401).json({ error: 'Invalid username' });
        } 
        
        const user = result[0];

        // Compare the hashed password
        bcrypt.compare(password, user.password, function (err, isMatch) {
            if (err) {
                console.error('Error comparing passwords:', err);
                return res.status(500).json({ error: 'Error comparing passwords' });
            }

            if (!isMatch) {
                // If password doesn't match, return invalid password error
                return res.status(401).json({ error: 'Wrong password' });
            }

            // Successful login
            req.session.user = user;
            req.session.userId = user.id;
            req.session.firstname = user.firstname;

            res.status(200).json({ message: 'Login successful', role: user.role });
        });
    });
});

// Registration route
app.post('/register', function (req, res) {
    const { username, studentId, firstName, lastName, password } = req.body;

    // Validate required fields
    if (!username || !studentId || !firstName || !lastName || !password) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    // Check if the user already exists
    const checkUserSql = 'SELECT * FROM users WHERE username = ?';
    con.query(checkUserSql, [username], function (err, result) {
        if (err) {
            console.error('Error querying database:', err);
            return res.status(500).json({ error: 'Error querying database' });
        }
        if (result.length > 0) {
            return res.status(409).json({ error: 'Username already exists' });
        }

        // Hash the password
        bcrypt.hash(password, 10, function (err, hashedPassword) {
            if (err) {
                console.error('Error hashing password:', err);
                return res.status(500).json({ error: 'Error hashing password' });
            }

            // Insert the new user into the database
            const sql = 'INSERT INTO users (username, studentId, firstName, lastName, password, role) VALUES (?, ?, ?, ?, ?, ?)';
            con.query(sql, [username, studentId, firstName, lastName, hashedPassword, 'student'], function (err, result) {
                if (err) {
                    console.error('Error inserting user into database:', err);
                    return res.status(500).json({ error: 'Error inserting user into database' });
                }

                res.status(201).json({ message: 'Registration successful' });
            });
        });
    });
});

// ------------- Get all borrow history for staff --------------
app.get('/history', function (req, res) {
    const query = `
        SELECT books.bookId, books.bookName, books.imageFilePath, borrow_book.borrow_date, 
               borrow_book.return_date, borrow_book.approve_by, borrow_book.return_by, 
               borrow_book.borrow_id, borrow_book.status, users.username 
        FROM borrow_book 
        INNER JOIN books ON borrow_book.book_id = books.bookId 
        INNER JOIN users ON borrow_book.user_id = users.id`;
    
    db.query(query, function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.json(results);
    });
});

// ------------- Get all borrow history for each user --------------
app.get('/history/user', function (req, res) {
    const query = `
        SELECT books.bookId, books.bookName, books.imageFilePath, borrow_book.borrow_date, 
               borrow_book.return_date, borrow_book.approve_by, borrow_book.return_by, 
               borrow_book.borrow_id, borrow_book.status, users.username 
        FROM borrow_book 
        INNER JOIN books ON borrow_book.book_id = books.bookId 
        INNER JOIN users ON borrow_book.user_id = users.id 
        WHERE borrow_book.user_id = ?`;

    db.query(query, [req.session.userID], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.json(results);
    });
});

// ------------- Add a borrow request --------------
app.post('/request-borrow', function (req, res) {
    const { book_id } = req.body;

    const insertRequestQuery = `
        INSERT INTO borrow_book (book_id, user_id, borrow_date, return_date, status) 
        VALUES (?, ?, CURRENT_DATE, CURRENT_DATE + INTERVAL 7 DAY, 'Pending')`;
    
    db.query(insertRequestQuery, [book_id, req.session.userID], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }

        // Optionally update book status if needed
        const updateBookStatusQuery = "UPDATE books SET status = 'disable' WHERE bookId = ?";
        db.query(updateBookStatusQuery, [book_id], function (err, results) {
            if (err) {
                console.error(err);
                return res.status(500).send("Database server error");
            }
            res.status(200).send('Request added successfully');
        });
    });
});

// ------------- Get all requests from the database --------------
app.get('/request', function (req, res) {
    const query = `
        SELECT books.bookId, books.bookName, books.bookInfo, books.imageFilePath, 
               borrow_book.borrow_id, borrow_book.borrow_date, borrow_book.return_date, 
               users.username, borrow_book.status 
        FROM borrow_book 
        INNER JOIN users ON borrow_book.user_id = users.id 
        INNER JOIN books ON borrow_book.book_id = books.bookId`;

    db.query(query, function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.status(200).json(results);
    });
});

// ------------- Approve a borrow request --------------
app.post('/approve/:request', function (req, res) {
    const query = "UPDATE borrow_book SET status = 'Approve', approve_by = ? WHERE borrow_id = ?";
    db.query(query, [req.session.username, req.params.request], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.send('Request approved!');
    });
});

// ------------- Disapprove a borrow request --------------
app.put('/disapprove/:request', function (req, res) {
    const query = "UPDATE borrow_book SET status = 'Rejected' WHERE borrow_id = ?";
    db.query(query, [req.params.request], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.send('Request disapproved!');
    });
});

// ------------- Return a book --------------
app.put('/return/:request', function (req, res) {
    const query = "UPDATE borrow_book SET status = 'Returned', return_by = ? WHERE borrow_id = ?";
    db.query(query, [req.session.username, req.params.request], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.send('Book returned successfully!');
    });
});

// ------------- Add a new book --------------
app.post('/add', function (req, res) {
    const { bookName, imageFilePath, bookInfo, status, author, totalBook } = req.body;

    const insertBookQuery = "INSERT INTO books (bookName, imageFilePath, bookInfo, status, author, totalBook) VALUES (?, ?, ?, ?, ?, ?)";
    db.query(insertBookQuery, [bookName, imageFilePath, bookInfo, status, author, totalBook], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Add book failed. Please try again.');
        }
        res.status(200).send('Add book successful');
    });
});

// ------------- Get book by ID --------------
app.get('/bookid/:Bid', function (req, res) {
    const query = "SELECT * FROM books WHERE bookId = ?";
    db.query(query, [req.params.Bid], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.json(results);
    });
});

// ------------- Edit a book --------------
app.post('/edit', function (req, res) {
    const { bookName, imageFilePath, bookInfo, status, author, totalBook, bookId } = req.body;

    const updateBookQuery = "UPDATE books SET bookName = ?, imageFilePath = ?, bookInfo = ?, status = ?, author = ?, totalBook = ? WHERE bookId = ?";
    db.query(updateBookQuery, [bookName, imageFilePath, bookInfo, status, author, totalBook, bookId], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Edit book failed. Please try again.');
        }
        res.status(200).send('Edit book successful');
    });
});

// ------------- Disable a book --------------
app.put('/disable/:Bid', function (req, res) {
    const query = "UPDATE books SET status = 'disable' WHERE bookId = ?";
    db.query(query, [req.params.Bid], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.send('Book disabled!');
    });
});

// ------------- Enable a book --------------
app.put('/enable/:Bid', function (req, res) {
    const query = "UPDATE books SET status = 'available' WHERE bookId = ?";
    db.query(query, [req.params.Bid], function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.send('Book enabled!');
    });
});

// ------------- Get user info --------------
app.get('/userInfo', function (req, res) {
    res.json({
        "userID": req.session.userID,
        "username": req.session.username,
        "email": req.session.email,
        "studentID": req.session.studentID,
        "role": req.session.role,
    });
});

// ------------- Get all books for user --------------
app.get('/user/asset', function (req, res) {
    const query = "SELECT * FROM books WHERE status = 'available'";
    db.query(query, function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.json(results);
    });
});

// ------------- Dashboard statistics --------------
app.get('/dashboard', function (req, res) {
    const num = `
        SELECT COUNT(*) AS available_books FROM books WHERE status = 'available' 
        UNION SELECT COUNT(*) FROM books WHERE status = 'disable' 
        UNION SELECT COUNT(*) FROM borrow_book WHERE status = 'Pending'`;
    
    db.query(num, function (err, results) {
        if (err) {
            console.error(err);
            return res.status(500).send("Database server error");
        }
        res.json(results);
    });
});

app.get('/users/:id', (req, res) => {
    const userId = req.params.id;
    const sql = 'SELECT * FROM users WHERE id = ?';
    con.query(sql, [userId], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Database query error' });
        }
        if (result.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        res.status(200).json(result[0]);
        console.log(result)
    });
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});