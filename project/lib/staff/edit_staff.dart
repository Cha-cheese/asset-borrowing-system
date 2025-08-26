import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/models/product.dart';
import 'package:image_picker/image_picker.dart';

class EditBookPage extends StatefulWidget {
  final Product book; // Receive the Product object to edit

  EditBookPage({required this.book});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late String bookName;
  late String status;
  late String description;
  late String author;
  late int bookId; // ID of the book
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    bookName = widget.book.title;
    status = widget.book.status;
    description = widget.book.description;
    author = widget.book.author;
    bookId = widget.book.id; // Get the book ID

    // Check if the image path is valid and exists
    String imagePath = widget.book.image;
    if (imagePath.isNotEmpty && imagePath != "assets/images/No_image.jpg") {
      final imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        _image = imageFile; // Load existing image if it exists
      } else {
        _image = null; // Set to null if the image file doesn't exist
      }
    } else {
      _image = null; // Set to null if the path indicates no image
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      String? Function(String?) validator,
      {bool isReadOnly = false}) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            textAlign: label == 'Book ID'
                ? TextAlign.center
                : TextAlign.start, // Center text for Book ID
            decoration: InputDecoration(
              hintText: isReadOnly ? 'ID: $bookId' : 'Enter $label',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            maxLines: null,
            validator: isReadOnly ? null : validator,
            onChanged: isReadOnly ? null : onChanged,
            initialValue: isReadOnly
                ? bookId.toString()
                : (label == 'Book name'
                    ? bookName
                    : label == 'Description'
                        ? description
                        : label == 'Author'
                            ? author
                            : null),
            readOnly: isReadOnly, // Make this field read-only if isReadOnly is true
          ),
        ),
      ],
    );
  }

  String? _bookNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter book name';
    }
    return null;
  }

  String? _descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter description';
    }
    return null;
  }

  String? _authorValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter author name';
    }
    return null;
  }

  void _editBook() {
    if (_formKey.currentState!.validate()) {
      // Update the book details
      print('Book ID: $bookId'); // Print the book ID
      print('Book Name: $bookName');
      print('Status: $status');
      print('Description: $description');
      print('Author: $author');

      // Find and update the book in the products list
      int index = products.indexWhere((product) => product.id == bookId);
      if (index != -1) {
        products[index] = Product(
          id: bookId, // Keep the existing ID
          title: bookName,
          description: description,
          image: _image?.path ?? "assets/images/No_image.jpg",
          status: status,
          author: author,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book edited successfully!'),
        backgroundColor: Colors.green, 
        ),
      );

      // Navigate back to ProductPage and return true
      Navigator.pop(context, true);
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to edit this book?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editBook();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _checkBeforeConfirmation() {
    if (_formKey.currentState!.validate()) {
      _showConfirmationDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF273948),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Book ID with a reduced width
              Container(
                width: 150, // Set the desired width here
                child: _buildTextField('Book ID', (value) {}, (value) => null,
                    isReadOnly: true),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  // Check if the image is available, if not display 'No image'
                  if (_image != null)
                    Stack(
                      children: [
                        Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _image = null; // Reset the image
                              });
                            },
                            child: Icon(
                              Icons.delete, // Trash can icon
                              color: Colors.red, // Icon color
                              size: 30, // Icon size
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Image.asset('assets/images/No_image.jpg', width: 100, height: 100),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickImage, //_pickImage
                      child: Text('Choose Image'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              _buildTextField('Book name', (value) {
                bookName = value;
              }, _bookNameValidator),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Status :', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: status,
                      items: [
                        DropdownMenuItem(
                            value: 'Available', child: Text('Available')),
                        DropdownMenuItem(
                            value: 'Disable', child: Text('Disable')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildTextField('Description', (value) {
                description = value;
              }, _descriptionValidator),
              SizedBox(height: 16),
              _buildTextField('Author', (value) {
                author = value;
              }, _authorValidator),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('CANCEL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE4B90A),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _checkBeforeConfirmation();
                    },
                    child: Text('EDIT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF22aa39),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
