import 'package:flutter/material.dart';
import 'package:project/models/info_user.dart'; // Import your info.dart file

class HistoryUser extends StatefulWidget {
  const HistoryUser({super.key});

  @override
  State<HistoryUser> createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUser> {
  String appBarTitle = 'Book List';
  String searchQuery = ''; // Variable to hold the search query

  // Function to filter books based on the search query
  List<Map<String, String>> get filteredBooks {
    if (searchQuery.isEmpty) {
      return Info.books; // Use data from Info
    }
    return Info.books
        .where((book) =>
            book['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // Function to determine the status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'borrowing':
        return const Color(0xFFE4B90A); // Yellow color for Borrowing
      case 'rejected':
        return Colors.red; // Red color for Reject
      case 'approved':
        return const Color(0xFF00BF63); // Green color for Approve
      default:
        return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 216, 237, 255),
        body: Container(
          color: const Color.fromARGB(255, 216, 237, 255),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              children: [
                // Search Box
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Update the search query
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search book',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Book List
                Expanded(
                  child: filteredBooks.isEmpty // Check if there are no filtered books
                      ? Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54, // Optional: Set a color for the message
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return Card(
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
                                          book['image']!,
                                          width: 100,
                                          height: 120,
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                book['title']!,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  'Borrowed Date: ${book['borrowedDate']}'),
                                              Text('Date Due: ${book['dueDate']}'),
                                              Text('Approver: ${book['approved']}'),
                                              Text(
                                                  'Return asset: ${book['return asset']}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Status: '),
                                        Text(
                                          book['status']!, // Display the status
                                          style: TextStyle(
                                            color: _getStatusColor(book['status']!), // Use the status color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
