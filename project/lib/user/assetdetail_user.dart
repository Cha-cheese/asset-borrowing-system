import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/models/product.dart';

class DetailUser extends StatelessWidget {
  final Product product;

  DetailUser({required this.product});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFF00BF63); // Color for Available
      case 'Pending':
        return const Color.fromARGB(255, 10, 130, 228); 
      case 'Borrowed':
        return const Color(0xFFE4B90A); // Color for Borrowed
      case 'Disable':
        return const Color(0xFF68737B); // Color for Disable
      default:
        return Colors.black; // Default color
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    DateTime borrowDate = DateTime.now(); // Set default to today
    DateTime? dueDate; // Make dueDate nullable

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Borrow'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Borrow Date Selection
                  Row(
                    children: [
                      const Icon(Icons.calendar_today), // Calendar icon
                      const SizedBox(width: 8), // Space between icon and text
                      const Text('Select Borrow Date:'),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: borrowDate, // Default to today
                        firstDate: DateTime.now(), // Starting today
                        lastDate: DateTime(2100), // No upper limit
                      );
                      if (selectedDate != null) {
                        setState(() {
                          borrowDate = selectedDate; // Update selected date
                          dueDate =
                              null; // Reset due date when borrow date changes
                        });
                      }
                    },
                    child: Text('${borrowDate.toLocal()}'
                        .split(' ')[0]), // Display selected date
                  ),
                  const SizedBox(height: 16.0),
                  // Due Date Selection
                  Row(
                    children: [
                      const Icon(Icons.calendar_today), // Calendar icon
                      const SizedBox(width: 8), // Space between icon and text
                      const Text('Select Due Date:'),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: dueDate ??
                            borrowDate.add(const Duration(
                                days:
                                    1)), // Default to tomorrow if dueDate is null
                        firstDate: borrowDate.add(const Duration(
                            days:
                                1)), // Start from the day after the borrow date
                        lastDate: borrowDate.add(const Duration(
                            days: 7)), // Limit to 7 days after borrow date
                      );
                      if (selectedDate != null) {
                        setState(() {
                          dueDate = selectedDate; // Update selected date
                        });
                      }
                    },
                    child: Text(dueDate != null
                        ? '${dueDate!.toLocal()}'
                            .split(' ')[0] // Safely access dueDate
                        : 'Select Due Date'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (dueDate != null) {
                  // Only check for dueDate
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('The book has been borrowed!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select both dates.')),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8EDFF), // Background color
      appBar: AppBar(
        title: Text(
          product.title,
          style: const TextStyle(color: Colors.white), // AppBar text color
        ),
        backgroundColor: const Color(0xFF273948), // AppBar color
        iconTheme:
            const IconThemeData(color: Colors.white), // AppBar icon color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWidget(product.image),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('ID Book: ${product.id}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  product.status,
                  style: TextStyle(
                      color: _getStatusColor(product.status), fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Description: ${product.description}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Author: ${product.author}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            // Add Borrow button if status is Available
            if (product.status == 'Available')
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context); // Show confirmation dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF00BF63), // Button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Button corners
                  ),
                ),
                child: const Text('Borrow'),
              ),
          ],
        ),
      ),
    );
  }

    Widget _buildImageWidget(String imagePath) {
    return imagePath.startsWith('assets/')
        ? Image.asset(
            imagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath),
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
          );
  }
}
