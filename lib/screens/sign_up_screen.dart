import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // Import home screen
import 'sign_in_screen.dart'; // Import sign-in screen

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? errorMessageName;
  String? errorMessageEmail;
  String? errorMessagePassword;
  String? errorMessageConfirmPassword;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String confirmPassword = _confirmPasswordController.text;

    setState(() {
      errorMessageName = (firstName.isEmpty && lastName.isEmpty)
          ? "Please enter your name"
          : null;
      errorMessageEmail = email.isEmpty
          ? "Please enter your email"
          : !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)
          ? "Please enter a valid email address"
          : null;
      errorMessagePassword = password.isEmpty ? "Please enter your password" : null;
      errorMessageConfirmPassword = confirmPassword.isEmpty
          ? "Please confirm your password"
          : password.length < 6
          ? "Password should be at least 6 characters"
          : null;
    });

    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        try {
          // Create user using FirebaseAuth
          UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Save user info to Firestore with auto-generated document ID
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
          });

          // Show a success dialog after sign-up
          _showSuccessDialog();

          // Automatically navigate to the Home screen after a successful sign-up
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
        } catch (e) {
          if (e is FirebaseAuthException) {
            if (e.code == 'email-already-in-use') {
              setState(() {
                errorMessageEmail = "This email is already in use. Please try another.";
              });
            } else {
              setState(() {
                errorMessageEmail = "Error: ${e.message}";
              });
            }
          }
        }
      } else {
        setState(() {
          errorMessageConfirmPassword = "Passwords do not match!";
        });
      }
    }
  }


  // Function to show the success dialog after sign-up
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing dialog by tapping outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Registration complete!',
            style: TextStyle(fontSize: 18, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light shade of grey as background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0), // Added top padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image at the top
              Container(
                margin: const EdgeInsets.only(bottom: 20), // Added margin to lower the image
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35, // Slightly bigger image
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/sign_up.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D92F4), // Blue title color
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please sign up to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 24),
                    Column(
                      children: [
                        // Name fields side by side
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  prefixIcon: Icon(Icons.person), // Icon inside input box
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Smaller height
                                ),
                              ),
                            ),
                            SizedBox(width: 16), // Space between the two input fields
                            Expanded(
                              child: TextField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  prefixIcon: Icon(Icons.person), // Icon inside input box
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Smaller height
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (errorMessageName != null)
                          Text(errorMessageName!, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16.0),
                        // Email input
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email), // Icon inside input box
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Smaller height
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        if (errorMessageEmail != null)
                          Text(errorMessageEmail!, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16.0),
                        // Password input
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock), // Icon inside input box
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Smaller height
                          ),
                        ),
                        if (errorMessagePassword != null)
                          Text(errorMessagePassword!, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16.0),
                        // Confirm Password input
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock), // Icon inside input box
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Smaller height
                          ),
                        ),
                        if (errorMessageConfirmPassword != null)
                          Text(errorMessageConfirmPassword!,
                              style: TextStyle(color: Colors.red)),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _signUp,
                          child: Text('Sign Up'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFF0D92F4), // Blue color for the button
                            minimumSize: Size(150, 50), // Smaller width for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignInScreen()),
                                );
                              },
                              child: Text('Sign In', style: TextStyle(color: Color(
                                  0xFF13A805))),
                            ),
                          ],
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
    );
  }
}
