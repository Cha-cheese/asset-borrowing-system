import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/lender/edit_picture_lender.dart';

class ProfileLender extends StatefulWidget {
  static String?
      profileImagePath; // Store the image path persistently for lenders

  const ProfileLender({super.key});

  @override
  State<ProfileLender> createState() => _ProfileLenderState();
}

class _ProfileLenderState extends State<ProfileLender> {
  String? currentImagePath =
      ProfileLender.profileImagePath; // Use static path for lenders
  String username = 'Pax456'; // Default username prompt

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
        ProfileLender.profileImagePath = result; // Update static path
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
                                // Navigate to LoginScreen on LOG OUT
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 220, 9, 9),
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
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      12), // Match card border radius
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
                                      color: Color.fromARGB(255, 2, 0, 0),
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
                                children: const [
                                  Text(
                                    'ID: ',
                                    style: TextStyle(
                                      fontSize: 18, // Font size
                                      fontWeight: FontWeight.bold, // Bold text
                                    ),
                                  ),
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children:[
                                  Text(
                                    'Username: ',
                                    style: TextStyle(
                                      fontSize: 18, // Font size
                                      fontWeight: FontWeight.bold, // Bold text
                                    ),
                                  ),
                                  Text(
                                    username,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Firstname: ',
                                    style: TextStyle(
                                      fontSize: 18, // Font size
                                      fontWeight: FontWeight.bold, // Bold text
                                    ),
                                  ),
                                  Text(
                                    'Paxaya',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Lastname: ',
                                    style: TextStyle(
                                      fontSize: 18, // Font size
                                      fontWeight: FontWeight.bold, // Bold text
                                    ),
                                  ),
                                  Text(
                                    'Aroyasato',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Status: ',
                                    style: TextStyle(
                                      fontSize: 18, // Font size
                                      fontWeight: FontWeight.bold, // Bold text
                                    ),
                                  ),
                                  Text(
                                    'Lender',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
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
