import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'package:project/login.dart';
import 'package:project/user/edit_picture_user.dart';

class ProfileUser extends StatefulWidget {
  static String? profileImagePath; // Store the image path persistently

  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  String? currentImagePath = ProfileUser.profileImagePath; // Use static path
  String id = '';
  String username = ''; // Default username prompt
  String studentId = '';
  String firstName = '';
  String lastName = '';
  String status = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the widget is initialized
  }

  // Function to fetch user data from API
Future<void> _fetchUserData() async {
  try {
    final response = await http.get(Uri.parse('http://rnzsh-202-28-45-132.a.free.pinggy.link/users/5')); // เปลี่ยน ID ให้ตรงกับผู้ใช้
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        id = data['id']?.toString() ?? '';
        username = data['username'] ?? '';
        studentId = data['studentID']?.toString() ?? '';
        firstName = data['firstname'] ?? '';
        lastName = data['lastname'] ?? '';
        status = data['role'] ?? '';
      });
    } else {
      print('Failed to load user data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}


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
        ProfileUser.profileImagePath = result; // Update static path
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
                                Navigator.of(context).pushReplacement(
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
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Tap to change',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 25, 0, 0),
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
                                  const Text('5',
                                      style: TextStyle(fontSize: 18)), // You can change this to use a dynamic ID
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Student ID: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(studentId,
                                      style: const TextStyle(fontSize: 18)),
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
                                  Text(firstName,
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Lastname: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(lastName,
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Status: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(status,
                                      style: const TextStyle(fontSize: 18)),
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