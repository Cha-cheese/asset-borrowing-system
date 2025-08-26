import 'package:flutter/material.dart';

class ReturnStaff extends StatefulWidget {
  const ReturnStaff({super.key});

  @override
  State<ReturnStaff> createState() => _ReturnStaffState();
}

class _ReturnStaffState extends State<ReturnStaff> {
  String appBarTitle = 'Book List';

  // Sample dynamic book data
  List<Map<String, String>> books = [
    {'image': 'assets/images/book1.png', 'name': 'Book Name 1', 'username': 'User1', 'status': 'borrowing'},
    {'image': 'assets/images/book2.png', 'name': 'Book Name 2', 'username': 'User2', 'status': 'borrowing'},
    // Add more books as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 216, 237, 255),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Check if the books list is empty
              if (books.isEmpty)
                Center(
                  child: Text(
                    'No books returned',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...books.asMap().entries.map((entry) {
                          int index = entry.key;
                          var book = entry.value;
                          return _buildBookTile(
                            index,
                            book['image']!,
                            book['name']!,
                            book['username']!,
                            book['status']!,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookTile(int index, String imagePath, String bookName, String username, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 5),
            blurRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 100,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Username: $username'),
                  Row(
                    children: [
                      Text('Status: '),
                      Text(
                        status,
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Return asset:'),
                      SizedBox(width: 10),
                      FilledButton(
                        onPressed: () => _showAlert(context, index),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Return'),
          content: Text('Are you sure you want to return this book?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  books.removeAt(index); // Remove the book from the list
                });
                // Show Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Book returned successfully!'),
                    duration: Duration(seconds: 2), // Duration the Snackbar will be visible
                    backgroundColor: Colors.green, // Snackbar color
                  ),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
