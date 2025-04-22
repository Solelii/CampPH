import 'package:campph/screens/explore_screen.dart';
import 'package:campph/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

//Ensures that all widgets are initialized before proceeding

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

// Splash screen starts here

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());

}

class MyApp extends StatefulWidget{

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

// Default = false
  bool isLoggedIn = false;

  @override
  void initState(){

    super.initState();

    asynchCall();

  }

  Future<void> asynchCall() async {

// Wait for both functions

    await Future.wait([
      Future.delayed(const Duration(seconds: 1)),
      initialization()
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

  // Future<LatLng> getInitialMapPosition() async {

  //   final prefs = await SharedPreferences.getInstance();

  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   LocationPermission permission = await Geolocator.checkPermission();

  //   // Request permission if not already granted
  //   if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
  //     permission = await Geolocator.requestPermission();
  //   }

  //   if (serviceEnabled && (permission == LocationPermission.always || permission == LocationPermission.whileInUse)) {
  //     try {
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );

  //       // Save for later use
  //       await prefs.setDouble('lastLat', position.latitude);
  //       await prefs.setDouble('lastLng', position.longitude);

  //       return LatLng(position.latitude, position.longitude);
  //     } catch (e) {
  //       print("Error getting location: $e");
  //     }

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
      title: "CampPH",
      home: isLoggedIn == true ? 
      ExploreScreen() : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignupPage(),
        '/home': (context) => ExploreScreen(),
        '/profile': (context) => ProfilePage()
      },
    );
  }
}
