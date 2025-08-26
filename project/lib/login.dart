import 'dart:convert'; // Import for json encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import for making HTTP requests
import 'package:project/lender/asset_lender.dart';
import 'package:project/register.dart';
import 'package:project/staff/history_staff.dart';
import 'package:project/user/asset_user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  String? _usernameError;
  String? _passwordError;

  void _handleLogin() async {
  setState(() {
    _usernameError = null;
    _passwordError = null; // Reset both errors initially
  });

  if (_formKey.currentState!.validate()) {
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    // Send HTTP request to the server
    final response = await http.post(
      Uri.parse('http://192.168.1.7:3000/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': enteredUsername,
        'password': enteredPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful
      final data = json.decode(response.body);
      String role = data['role'];

      // Navigate based on user role
      if (role == 'student') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AssetUser()));
        _showRoleMessage('Student logged in successfully.');
      } else if (role == 'staff') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HistoryStaff()));
        _showRoleMessage('Staff logged in successfully.');
      } else if (role == 'lender') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AssetLender()));
        _showRoleMessage('Lender logged in successfully.');
      }
    } else {
      // Handle errors based on the specific message
      final errorData = json.decode(response.body);
      if (errorData['error'] == 'Invalid username') {
        setState(() {
          _usernameError = 'Invalid username';
        });
      } else if (errorData['error'] == 'Wrong password') {
        setState(() {
          _passwordError = 'Wrong password'; // Set password error
        });
      } else {
        setState(() {
          _usernameError = 'Login failed';
        });
      }
    }
  }
}

void _showRoleMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
    ),
  );
}


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool isDayTime = now.hour >= 6 && now.hour < 18;
    List<Color> backgroundGradientColors = isDayTime
        ? [
            const Color.fromARGB(255, 103, 157, 245),
            const Color.fromARGB(255, 155, 223, 254)
          ]
        : [Colors.indigo.shade900, const Color.fromARGB(255, 89, 119, 133)];

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
                SizedBox(height: 29),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                              errorText: _usernameError,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              errorText: _passwordError,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 16),
                            ),
                            child: Text('Log in',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: isDayTime
                            ? const Color.fromARGB(255, 4, 76, 135)
                            : const Color.fromARGB(255, 255, 255, 255),
                        decoration: TextDecoration.underline,
                      ),
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