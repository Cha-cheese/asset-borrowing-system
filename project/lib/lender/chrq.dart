import 'package:flutter/material.dart';
import 'package:project/models/Chrq_info.dart'; // Import the Info class

class Chrq extends StatefulWidget {
  const Chrq({super.key});

  @override
  State<Chrq> createState() => _ChrqState();
}

class _ChrqState extends State<Chrq> {
  String appBarTitle = 'Book List';

  // Use Info.books from your Info class
  List<Map<String, String>> books = Info.books;

  void showAlertDialog(String action, int index) {
    String dialogTitle =
        action == 'approved' ? 'Confirm approval' : 'Confirm rejection';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text('Are you sure you want to $action?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Remove the book from the list and update the UI
                setState(() {
                  String bookTitle = books[index]['title'] ?? 'Unknown Book';
                  books.removeAt(index);

                  // Show SnackBar after updating the book list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$bookTitle has been $action.'),
                      backgroundColor: action == 'approved' ? Colors.green : Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 237, 255),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: books.isEmpty
            ? Center(
                child: Text(
                  'No borrowing',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    for (int index = 0; index < books.length; index++)
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    books[index]['image'] ?? 'assets/images/default.png',
                                    width: 100,
                                    height: 120,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        books[index]['title'] ?? 'Unknown Book',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Borrowed Date: ${books[index]['borrowedDate'] ?? 'N/A'}'),
                                      Text('Date Due: ${books[index]['dueDate'] ?? 'N/A'}'),
                                      Text('Username: ${books[index]['username'] ?? 'N/A'}'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10), // เพิ่มพื้นที่ระหว่างเนื้อหาและปุ่ม
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton(
                                    onPressed: () {
                                      showAlertDialog('rejected', index);
                                    },
                                    style: FilledButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 2.0),
                                      backgroundColor:
                                          const Color.fromARGB(255, 220, 9, 9),
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  FilledButton(
                                    onPressed: () {
                                      showAlertDialog('approved', index);
                                    },
                                    style: FilledButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 2.0),
                                      backgroundColor:
                                          const Color.fromARGB(255, 0, 191, 99),
                                    ),
                                    child: Text(
                                      'Approve',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
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
}
