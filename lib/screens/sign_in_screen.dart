import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await AuthService().signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
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
                    image: AssetImage('assets/sign_in.png'),
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
                      'Sign In',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF399918), // Changed title color to green
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please sign in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email input
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          // Password input
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.0),
                          // Sign-in button
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5, // Reduced button width
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signIn,
                              child: _isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text('Sign In'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          // Error message
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                              ),
                            ),
                          SizedBox(height: 16.0),
                          // Sign-up section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/sign_up'); // Fixed navigation
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.blue, // Blue text color for the button
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
