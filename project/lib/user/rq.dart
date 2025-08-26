import 'package:flutter/material.dart';

class Rq extends StatefulWidget {
  const Rq({super.key});

  @override
  State<Rq> createState() => _RqState();
}

class _RqState extends State<Rq> {
  String appBarTitle = 'Book List'; // Initial AppBar title

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 216, 237, 255), // Background color
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              Card(
                elevation: 4, // Optional elevation for better visuals
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Padding inside Card
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align children to start
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/book1.png', // Check this path
                            width: 100, // Set width
                            height: 150, // Set height
                            fit: BoxFit
                                .cover, // Ensure the image covers the area
                          ),
                          const SizedBox(
                              width: 8.0), // Space between image and text
                          Expanded(
                            // Ensure text uses available space
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Book Name 1',
                                  style: TextStyle(
                                    fontSize: 18, // Font size
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                ),
                                Text('Borrowed Date: dd/mm/yyyy'),
                                Text('Date Due: dd/mm/yyyy'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Status: '), // Keeping this part unchanged
                          Text(
                            'Pending', // Changing the color of this part
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 130, 228),
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
