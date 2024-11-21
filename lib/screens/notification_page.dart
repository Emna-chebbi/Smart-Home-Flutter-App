import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceCard extends StatelessWidget {
  final String image;
  final String name;
  final String status;

  const DeviceCard({
    Key? key,
    required this.image,
    required this.name,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Square size
      height: 100, // Square size
      margin: EdgeInsets.all(8), // Add space between cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 50, width: 50), // Resized image
          SizedBox(height: 8),
          Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text(status, style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
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
  int _selectedIndex = 0;

  Future<String> _getUserName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData['firstName'] ?? "User";
    } else {
      return "Guest";
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    DeviceDetectionScreen(),
    HomePage(),
    NotificationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFf7c6a0),
                  Color(0xFFf3a68e),
                  Color(0xFFf9d58d),
                  Color(0xfff1cf7e),
                  Color(0xffecd277),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
              ),
            ),
            height: MediaQuery.of(context).size.height,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    FutureBuilder<String>(
                      future: _getUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            "Error fetching name",
                            style: TextStyle(color: Colors.white),
                          );
                        } else {
                          return Text(
                            snapshot.data ?? "User",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              TabBar(
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Living Room'),
                  Tab(text: 'Kitchen'),
                  Tab(text: 'Bathroom'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Wrap(
                        children: [
                          DeviceCard(
                            image: 'assets/images/lamp.png',
                            name: 'Smart Lamp',
                            status: 'On',
                          ),
                          DeviceCard(
                            image: 'assets/images/vacuum.png',
                            name: 'Vacuum Cleaner',
                            status: 'Off',
                          ),
                          DeviceCard(
                            image: 'assets/images/camera.png',
                            name: 'CCTV Camera',
                            status: 'On',
                          ),
                          DeviceCard(
                            image: 'assets/images/speaker.png',
                            name: 'Smart Speaker',
                            status: 'On',
                          ),
                        ],
                      ),
                    ),
                    Center(child: Text("Kitchen Devices")),
                    Center(child: Text("Bathroom Devices")),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.loop, color: Colors.black), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.black), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications, color: Colors.black),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.black), label: ''),
            ],
            backgroundColor: Colors.grey[300],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class DeviceDetectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Device Detection Screen"));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home Page"));
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Notification Page"));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile Page"));
  }
}
