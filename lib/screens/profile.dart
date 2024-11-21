import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // Ensure HomeScreen is imported.

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 3; // Default to Profile Page in the bottom navigation.
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(child: Text("No user data found")),
          );
        }

        var userData = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Profile Image
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your edit profile functionality here
                },
                child: Text("Edit Profile"),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("My Information", style: TextStyle(fontSize: 18)),
                ),
              ),
              // Information Box
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("First Name: ${userData['firstName']}"),
                      Text("Last Name: ${userData['lastName']}"),
                      Text("Email: ${userData['email']}"),
                      ElevatedButton(
                        onPressed: () {
                          // Add your reset password functionality here
                        },
                        child: Text("Reset Password"),
                        style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    // Handle any post-logout actions, like navigating to the login screen
                  },
                  child: Text("Logout"),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              margin: EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(35),
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/devices.png', // Path to your devices image
                      width: 40,
                      height: 40,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/home_page.png', // Path to your home page image
                      width: 40,
                      height: 40,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/bell.png', // Path to your bell image
                      width: 40,
                      height: 40,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/profile.png', // Path to your profile image
                      width: 40,
                      height: 40,
                    ),
                    label: '',
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white54,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: _onItemTapped, // Add onTap event for navigation
                type: BottomNavigationBarType.fixed,
              ),
            ),
          ),
        );
      },
    );
  }
}
