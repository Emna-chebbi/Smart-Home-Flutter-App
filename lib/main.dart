import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/splash', // Set splash screen as initial route
      routes: {
        '/splash': (context) => SplashScreen(), // Splash screen route
        '/': (context) => AppHome(), // Home screen route
        '/sign_in': (context) => SignInScreen(), // Sign-in screen route
        '/sign_up': (context) => SignUpScreen(), // Sign-up screen route
        '/home': (context) => HomeScreen(), // Home screen route after sign-in
      },
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().checkUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomeScreen(); // Navigate to home if logged in
        } else {
          return SignInScreen(); // Otherwise, show sign-in screen
        }
      },
    );
  }
}
