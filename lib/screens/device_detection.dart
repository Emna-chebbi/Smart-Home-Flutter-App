import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'notification_page.dart';
import 'profile.dart';

class DeviceDetectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfff6c92e),
                  Color(0xfff4b09a),
                  Color(0xffdda7da),
                  Color(0xdb0a87b5),
                  Color(0xffafabab),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Page Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Device Detection',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Decorative Image
                  Center(
                    child: Image.asset(
                      'assets/device_detection.png',
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Subtext
                  Center(
                    child: Text(
                      'Easily detect and connect your home devices to manage and control them directly in the app.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Automatic Detection Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Future functionality for automatic detection
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Searching for devices...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Updated color
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Detect Devices Automatically',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Manual Detection Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Manual Detection Image
                      Image.asset(
                        'assets/manual_detection.png',
                        height: 90,
                        width: 90,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Or add devices manually:',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(height: 30),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: 'Enter device details',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Placeholder for manual entry functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Manual entry not implemented yet.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Updated color
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Add Device Manually',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          margin: EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.8),
            borderRadius: BorderRadius.circular(35),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeviceDetectionPage()),
                    );
                  },
                  child: Image.asset(
                    'assets/devices.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Image.asset(
                    'assets/home_page.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationPage()),
                    );
                  },
                  child: Image.asset(
                    'assets/bell.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(onProfileUpdated: () {}),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/profile.png',
                    width: 40,
                    height: 40,
                  ),
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
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
