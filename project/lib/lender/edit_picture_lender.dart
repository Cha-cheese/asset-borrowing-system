import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPicturePage extends StatefulWidget {
  final String? currentImagePath; // Change to nullable String
  final String username;

  const EditPicturePage(
      {Key? key, required this.currentImagePath, required this.username})
      : super(key: key);

  @override
  _EditPicturePageState createState() => _EditPicturePageState();
}

class _EditPicturePageState extends State<EditPicturePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load the current image path when the page initializes
    if (widget.currentImagePath != null &&
        widget.currentImagePath!.isNotEmpty) {
      _selectedImage = File(widget.currentImagePath!);
    }
  }

  Future<void> _chooseImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _saveImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Save'),
          content: const Text('Are you sure you want to save this picture?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Return the new image path or the current image path
                Navigator.of(context)
                    .pop(_selectedImage?.path ?? widget.currentImagePath);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username.isNotEmpty
              ? "Edit ${widget.username}'s profile picture"
              : 'Edit your profile picture',
        ),
        backgroundColor:
            const Color.fromARGB(255, 39, 57, 72), // Set AppBar color
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color.fromARGB(255, 216, 237, 255), // Set background color
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Center the card within the container
          child: Card(
            elevation: 4, // Shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding inside the card
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Make the column size to fit its content
                children: [
                  const Text(
                    'Edit your picture',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _selectedImage != null
                      ? Card(
                          elevation: 4, // Shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // Match card border radius
                            child: Image.file(
                              _selectedImage!,
                              width: 200,
                              height: 350,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Card(
                          elevation: 4, // Shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // Match card border radius
                            child: Image.asset(
                              widget.currentImagePath ??
                                  'assets/images/No_image.jpg', // Use default image if null
                              width: 200,
                              height: 350,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _chooseImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 39, 57, 72), // Background color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: const Text('Choose Image'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF22aa39), // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
