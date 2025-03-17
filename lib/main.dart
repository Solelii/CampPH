import 'package:flutter/material.dart';
import 'screens/landing_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
      home: Scaffold(
        appBar: AppBar(title: const Text('My Home Page')),
        body: Center(
          child: Center(
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LandingPage(),
                          ),
                        );
                      },
                      child: const Text('Login/Sign Up'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
