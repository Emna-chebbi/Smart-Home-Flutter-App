import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in_screen.dart';
import 'home_screen.dart'; // Import your HomeScreen

class ProfilePage extends StatefulWidget {
  final Function onProfileUpdated;

  ProfilePage({required this.onProfileUpdated});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _firstName, _lastName, _email;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;

  Future<void> _loadUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      var data = docSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _firstName = data['firstName'];
        _lastName = data['lastName'];
        _email = data['email'];
        _firstNameController.text = _firstName ?? '';
        _lastNameController.text = _lastName ?? '';
        _emailController.text = _email ?? '';
      });
    }
  }

  Future<void> _updateUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile updated successfully')));

        _loadUserInfo();

        setState(() {
          _isEditing = false;
          _firstName = _firstNameController.text;
          _lastName = _lastNameController.text;
          _email = _emailController.text;
        });

        widget.onProfileUpdated(_firstNameController.text, _lastNameController.text,
            _emailController.text);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update profile')));
      }
    }
  }

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff6c92e),
              Color(0xfff4b09a),
              Color(0xffdda7da),
              Color(0xff0a87b5),
              Color(0xffafabab),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppBar(
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xfffff6f6), // Profile page title color
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/edit_profile.png',
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _firstName ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                              color: Color(0xfffff6f6), // Profile text color
                            ),
                          ),
                          Text(
                            _lastName ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                              color: Color(0xfffff6f6), // Profile text color
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: _isEditing
                          ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: Text(
                          "Cancel Edit",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "My Informations",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfffff6f6), // Color for "My Informations"
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: _isEditing ? null : 120, // Decreased height to avoid overflow
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _isEditing
                                ? TextField(
                              controller: _firstNameController,
                              decoration: InputDecoration(labelText: "First Name"),
                            )
                                : Text(
                              "First Name: $_firstName",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman'),
                            ),
                            _isEditing
                                ? TextField(
                              controller: _lastNameController,
                              decoration: InputDecoration(labelText: "Last Name"),
                            )
                                : Text(
                              "Last Name: $_lastName",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman'),
                            ),
                            _isEditing
                                ? TextField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: "Email"),
                            )
                                : Text(
                              "Email: $_email",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: _updateUserInfo,
                          child: Text(
                            "Submit Changes",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _logOut,
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
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
                        'assets/devices.png',
                        width: 40,
                        height: 40,
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
                      icon: Image.asset(
                        'assets/bell.png',
                        width: 40,
                        height: 40,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/profile.png',
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
                  type: BottomNavigationBarType.fixed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
