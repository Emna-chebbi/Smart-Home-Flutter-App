import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screens/device_detection.dart';
import 'package:project/screens/notification_page.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = "User"; // Store username locally

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

  void _updateUserName() {
    setState(() {
      // Trigger the rebuild and refresh the username
      _getUserName(); // This is called to update the username.
    });
  }

  final List<List<DeviceCard>> roomDevices = [
    [
      DeviceCard(image: 'assets/lamp.png', name: 'Lights'),
      DeviceCard(image: 'assets/lock.png', name: 'Door Lock'),
    ],
    [
      DeviceCard(image: 'assets/flame.png', name: 'Flame Detector'),
      DeviceCard(image: 'assets/gas.webp', name: 'Gas Detector'),
    ],
    [
      DeviceCard(image: 'assets/lamp.png', name: 'Lights'),
    ],
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
            height: MediaQuery.of(context).size.height,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                child: FutureBuilder<String>(
                  future: _getUserName(),
                  builder: (context, snapshot) {
                    String userName = snapshot.hasData ? snapshot.data! : "User";
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Welcome to Your Home, $userName!",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Color(0xfffff6f6),
                            ),
                          ),
                        ),
                        SizedBox(width: 2), // Space between the text and image
                        Align(
                          alignment: Alignment.bottomCenter, // Align the image to lower it
                          child: Image.asset(
                            'assets/home.png', // Path to your image
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 55,
                          child: TabBar(
                            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text('Living Room'),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text('Kitchen'),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.2),
                                  child: Text('Bathroom'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: roomDevices.map((devices) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 40),
                                    Text(
                                      "${devices.length} devices detected",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Wrap(
                                      spacing: 20,
                                      runSpacing: 20,
                                      alignment: WrapAlignment.spaceAround,
                                      children: devices.map((device) {
                                        return Container(
                                          width: 150,
                                          child: device,
                                        );
                                      }).toList(),
                                    ),
                                    // Add temperature and humidity
                                    SizedBox(height: 40),
                                    Text(
                                      "   Living Room Temperature: 19°C",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "   Living Room Humidity: 70%",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            items: [
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeviceDetectionPage()), // Navigate to HomeScreen
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
                      MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
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
                      MaterialPageRoute(builder: (context) => NotificationPage()), // Navigate to HomeScreen
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
                      MaterialPageRoute(builder: (context) => ProfilePage(onProfileUpdated: _updateUserName)), // Navigate to HomeScreen
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

class DeviceCard extends StatefulWidget {
  final String image;
  final String name;

  DeviceCard({required this.image, required this.name});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool isOn = false;
  bool isLocked = true;

  void showPinDialog() {
    TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter PIN"),
          content: TextField(
            controller: pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter PIN"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (pinController.text == "123") {
                  setState(() {
                    isLocked = !isLocked;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect PIN!")),
                  );
                }
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.image, width: 60, height: 60),
          SizedBox(height: 8),
          Text(
            widget.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          if (widget.name == "Lights")
            Switch(
              value: isOn,
              onChanged: (value) {
                setState(() {
                  isOn = value;
                });
              },
            )
          else if (widget.name == "Door Lock")
            ElevatedButton(
              onPressed: showPinDialog,
              child: Text(isLocked ? "Locked" : "Unlocked"),
            )
          else
            Text(
              "Status: ${widget.name}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
