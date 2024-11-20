import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define the screens (you can modify them as needed)
class DeviceDetectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Device Detection Screen",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Home Page",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Notification Page",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Profile Page",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0; // To track the selected tab

  // Fetch the user's first name from Firestore
  Future<String> _getUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Fetch the user's first name from Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userData['firstName'] ?? "User"; // Default to "User" if the first name is missing
    } else {
      return "Guest"; // Default value for unauthenticated users
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of screens to navigate to
  final List<Widget> _screens = [
    DeviceDetectionScreen(),
    HomePage(),
    NotificationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures body content fills the entire screen, including bottom area
      body: Stack(
        children: [
          // Enhanced Blended Gradient (Smooth transition between warm and cool colors)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFf7c6a0), // Soft Peach
                  Color(0xFFf3a68e), // Coral
                  Color(0xFFf9d58d), // Soft Yellow
                  Color(0xfff1cf7e), // Golden Yellow
                  Color(0xffecd277), // Light Grey
                  Color(0xffefd89a), // Pastel Teal
                  Color(0xfff3d9d9), // Blue-Grey
                  Color(0xffdcc4ce), // Muted Blue-Grey
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.2, 0.4, 0.6, 0.7, 0.8, 0.9, 1.0], // Smooth gradient stops
              ),
            ),
            height: MediaQuery.of(context).size.height, // Full screen height
          ),
          // Content on top of the background
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting with user's first name and waving hand
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 40, // Increased size for "Hello"
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8), // Space between "Hello" and name
                    FutureBuilder<String>(
                      future: _getUserName(), // Fetch the first name asynchronously
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show loading indicator
                        } else if (snapshot.hasError) {
                          return Text("Error fetching name", style: TextStyle(color: Colors.white));
                        } else {
                          return Text(
                            snapshot.data ?? "User", // Display the first name
                            style: TextStyle(
                              fontSize: 35, // Size for user's name (slightly smaller than "Hello")
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 1), // Space between name and waving hand
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.waving_hand,
                          size: 100, // Increased size of the waving hand icon
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Line Divider (70% width of the page)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Colors.white,
                  thickness: 2,
                  indent: (MediaQuery.of(context).size.width * 0.15), // 15% padding from the left
                  endIndent: (MediaQuery.of(context).size.width * 0.15), // 15% padding from the right
                ),
              ),
              // Placeholder for the home screen content
              Expanded(
                child: Center(
                  child: Text(
                    "Welcome to the Home Page!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Rounded top corners
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Space around the navbar
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.loop, color: Colors.white),
                  label: ''
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white),
                  label: ''
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  label: ''
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.white),
                  label: ''
              ),
            ],
            backgroundColor: Colors.grey.withOpacity(0.1), // Light grey with transparency
            selectedItemColor: Colors.white, // White for selected icon
            unselectedItemColor: Colors.white, // White for unselected icon
            showSelectedLabels: false, // Hide selected label
            showUnselectedLabels: false, // Hide unselected label
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped, // Call the navigation function
          ),
        ),
      ),
    );
  }
}
