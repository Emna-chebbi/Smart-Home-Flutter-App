import 'package:flutter/material.dart';
import 'package:project/services/auth_service.dart';
import 'sign_in_screen.dart';  // Add the import for the sign-in screen

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
      errorMessagePassword =
      password.isEmpty ? "Please enter your password" : null;
      errorMessageConfirmPassword = confirmPassword.isEmpty
          ? "Please confirm your password"
          : null;
    });

    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        try {
          await AuthService().signUp(email, password, firstName, lastName);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign Up Successful!")));
        } catch (e) {
          setState(() {
            errorMessageEmail = "Error: $e";
          });
        }
      } else {
        setState(() {
          errorMessageConfirmPassword = "Passwords do not match!";
        });
      }
    }
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
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        if (errorMessageEmail != null)
                          Text(errorMessageEmail!, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16.0),
                        // Password input
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock), // Icon inside input box
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        if (errorMessagePassword != null)
                          Text(errorMessagePassword!, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 16.0),
                        // Confirm Password input
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock), // Icon inside input box
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        if (errorMessageConfirmPassword != null)
                          Text(errorMessageConfirmPassword!, style: TextStyle(color: Colors.red)),
                        SizedBox(height: 24.0),
                        // Sign-up button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5, // Same width as the sign-in button
                          child: ElevatedButton(
                            onPressed: _signUp,
                            child: Text('Sign Up'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        // Sign-in section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to Sign-In screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignInScreen()),
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Color(0xFF399918), // Green text color for the button
                                ),
                              ),
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
