import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  Color(0xb5f6c92e),
                  Color(0xfff4b09a),
                  Color(0xffdda7da),
                  Color(0x890a87b5),
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
                              fontSize: 35,
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
                            height: 150, // Adjust size
                            width: 150, // Adjust size
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
                            labelStyle:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25.0),
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
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                        fontSize: 18,
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
                icon: Image.asset(
                  'assets/devices.png', // Path to your devices image
                  width: 40, // Adjust the width to your preference
                  height: 40, // Adjust the height to your preference
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/home_page.png', // Path to your home page image
                  width: 40, // Adjust the width to your preference
                  height: 40, // Adjust the height to your preference
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/bell.png', // Path to your bell image
                  width: 40, // Adjust the width to your preference
                  height: 40, // Adjust the height to your preference
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/profile.png', // Path to your profile image
                  width: 40, // Adjust the width to your preference
                  height: 40, // Adjust the height to your preference
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
            decoration: InputDecoration(hintText: "Enter PIN (default: 0000)"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (pinController.text == "0000") {
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
