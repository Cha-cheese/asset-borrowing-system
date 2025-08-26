import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // For jsonEncode
import 'package:project/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  void _showSnackBar(String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 3), // Show for 3 seconds
    );

    // Show Snackbar immediately
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to handle registration
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      // Create user data map
      final Map<String, dynamic> userData = {
        'username': _usernameController.text,
        'studentId': _studentIdController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'password': _passwordController.text,
      };

      // Send a POST request to the server
      final response = await http.post(
        Uri.parse('http://rnssj-202-28-45-130.a.free.pinggy.link/register'), // Update with your server URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        // Registration successful
        _showSnackBar('Registration successful!', Colors.green);
        // Navigate to the LoginScreen
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Handle errors based on server response
        final responseData = jsonDecode(response.body);
        _showSnackBar(responseData['error'], Colors.red);
      }
    } else {
      // Display error Snackbar immediately
      _showSnackBar('Please fill the required fields', Colors.red);
    }
  }

  // Function to build minimized text fields
  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false,
      String? hintText,
      String? Function(String?)? validator,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: TextStyle(fontSize: 14),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          suffixIcon: suffixIcon,
        ),
        style: TextStyle(fontSize: 14),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isDayTime = now.hour >= 6 && now.hour < 18;
    List<Color> backgroundGradientColors = isDayTime
        ? [
            const Color.fromARGB(255, 112, 163, 245),
            const Color.fromARGB(255, 119, 202, 240)
          ]
        : [Colors.indigo.shade900, const Color.fromARGB(255, 111, 154, 174)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundGradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 5),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            _usernameController,
                            'Username',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            _studentIdController,
                            'Student ID',
                            hintText: 'EX.6531500000',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Student ID';
                              }
                              if (!RegExp(r'^\d+$').hasMatch(value)) {
                                return 'Student ID must be a number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            _firstNameController,
                            'First name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return 'First name must contain only characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            _lastNameController,
                            'Last name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return 'Last name must contain only characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            _passwordController,
                            'Password',
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 10),
                            ),
                            child: Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Already have an account? Log in",
                      style: TextStyle(
                          color: isDayTime
                              ? const Color.fromARGB(255, 12, 111, 193)
                              : const Color.fromARGB(255, 255, 255, 255),
                          decoration: TextDecoration.underline,
                          fontSize: 14),
                     ),
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