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

  String? errorMessage = "";

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password == confirmPassword) {
      try {
        await AuthService().signUp(email, password, firstName, lastName);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign Up Successful!")));
      } catch (e) {
        setState(() {
          errorMessage = "Error: $e";
        });
      }
    } else {
      setState(() {
        errorMessage = "Passwords do not match!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _firstNameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: _lastNameController, decoration: InputDecoration(labelText: "Last Name")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            TextField(controller: _confirmPasswordController, obscureText: true, decoration: InputDecoration(labelText: "Confirm Password")),
            if (errorMessage != "") Text(errorMessage!, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: _signUp, child: Text("Sign Up")),
            TextButton(
              onPressed: () {
                // Navigate back to Sign-In screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text("Already have an account? Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}
