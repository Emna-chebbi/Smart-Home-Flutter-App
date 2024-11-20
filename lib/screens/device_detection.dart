import 'package:flutter/material.dart';
import 'profile.dart';
import 'notification_page.dart';
import 'home_screen.dart';

class LoopPage extends StatefulWidget {
  @override
  _LoopPageState createState() => _LoopPageState();
}

class _LoopPageState extends State<LoopPage> {
  int _selectedIndex = 3;
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  bool isLoading = false;

  void searchForDevices() {
    setState(() {
      isLoading = true;
    });

    // Simulate a loading delay of 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Detection"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("First we need to detect the available home appliances",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Image.asset('assets/device_detection.png'), // Your imported image
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: searchForDevices,
            child: Text("Search for devices"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 20),
          if (isLoading)
            CircularProgressIndicator(), // Show loading indicator
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.loop),
            label: 'Devices',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
