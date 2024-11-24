import 'package:flutter/material.dart';
import 'package:project/screens/device_detection.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/profile.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, String>> allNotifications = [
    {
      'imageAsset': 'assets/gas.webp',
      'title': 'Gas Alert',
      'timestamp': '5 min ago',
      'message': 'High gas levels detected in the kitchen.',
    },
    {
      'imageAsset': 'assets/flame.png',
      'title': 'Flame Alert',
      'timestamp': '30 min ago',
      'message': 'Flame detected in the bedroom.',
    },
  ];

  void markAllAsRead() {
    setState(() {
      allNotifications.clear();
    });
  }

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
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.mark_as_unread,
                          color: Colors.white,
                        ),
                        onPressed: markAllAsRead, // Clear notifications
                      ),
                    ],
                  ),
                ),
                // Tabs
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Increased font size
                          tabs: [
                            Tab(text: 'All'),
                            Tab(text: 'Gas Alerts'),
                            Tab(text: 'Flame Alerts'),
                          ],
                        ),
                        SizedBox(height: 10), // Added spacing between tabs and notifications
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildNotificationList(allNotifications),
                              _buildNotificationList(
                                allNotifications.where((n) => n['title'] == 'Gas Alert').toList(),
                              ),
                              _buildNotificationList(
                                allNotifications.where((n) => n['title'] == 'Flame Alert').toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                      MaterialPageRoute(builder: (context) => ProfilePage(onProfileUpdated: () {})),
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

  Widget _buildNotificationList(List<Map<String, String>> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          'No Notifications',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      );
    }
    return ListView(
      children: notifications.map((notification) {
        return NotificationCard(
          imageAsset: notification['imageAsset']!,
          title: notification['title']!,
          timestamp: notification['timestamp']!,
          message: notification['message']!,
        );
      }).toList(),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String timestamp;
  final String message;

  const NotificationCard({
    Key? key,
    required this.imageAsset,
    required this.title,
    required this.timestamp,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: ListTile(
        leading: Image.asset(imageAsset, width: 40, height: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(timestamp, style: TextStyle(color: Colors.grey)),
            Text(message),
          ],
        ),
      ),
    );
  }
}
