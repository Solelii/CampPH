import 'package:campph/screens/explore_screen.dart';
import 'package:campph/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  //Ensures that all widgets are initialized before proceeding

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Splash screen starts here

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Default = false
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    asynchCall();
  }

  Future<void> asynchCall() async {
    // Wait for both functions

    await Future.wait([
      Future.delayed(const Duration(seconds: 1)),
      initialization(),
    ]);
  }

  Future<void> initialization() async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(
            allowList: <String>{'username'},
          ),
        );

    final String? username = prefsWithCache.getString('username');

    setState(() {
      isLoggedIn = username != null && username.isNotEmpty;
    });

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
      title: "CampPH",
      home: isLoggedIn == true ? ExploreScreen() : LandingPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignupPage(),
        '/home': (context) => ExploreScreen(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
