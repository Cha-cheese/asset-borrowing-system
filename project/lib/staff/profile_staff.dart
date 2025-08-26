import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/staff/edit_picture_staff.dart'; // Ensure this import is correct for your EditPicturePage

class ProfileStaff extends StatefulWidget {
  static String? profileImagePath; // Store the image path persistently for staff

  const ProfileStaff({super.key});

  @override
  State<ProfileStaff> createState() => _ProfileStaffState();
}

class _ProfileStaffState extends State<ProfileStaff> {
  String? currentImagePath = ProfileStaff.profileImagePath; // Use static path for staff
  String username = 'manie951'; // Default username prompt

  // Navigate to the Edit Picture page
  void _navigateToEditPicture() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPicturePage(
          currentImagePath: currentImagePath, // Pass the current image path
          username: username,
        ),
      ),
    );

    // If a new image path is returned, update the current image path
    if (result != null) {
      setState(() {
        currentImagePath = result; // Update current image path
        ProfileStaff.profileImagePath = result; // Update static path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 216, 237, 255),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 220, 9, 9),
                              ),
                              child: const Text('LOG OUT'),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _navigateToEditPicture,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Card(
                                elevation: 4, // Shadow effect
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12), // Match card border radius
                                  child: currentImagePath != null &&
                                          currentImagePath!.isNotEmpty
                                      ? (currentImagePath!.startsWith('assets/')
                                          ? Image.asset(
                                              currentImagePath!,
                                              width: 200,
                                              height: 350,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(currentImagePath!),
                                              width: 200,
                                              height: 350,
                                              fit: BoxFit.cover,
                                            ))
                                      : Image.asset(
                                          'assets/images/No_image.jpg', // Default image if no custom image is set
                                          width: 200,
                                          height: 350,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Tap to change',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('ID: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const Text('6', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Username: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(username,
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Firstname: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const Text('Maninie',
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Lastname: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const Text('Sarnghea',
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Status: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const Text('Staff', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
