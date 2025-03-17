import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Home Page')),
      backgroundColor: Color(0xFFFFF2CA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            const Text('Logo'),
            Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF643E37),
                  foregroundColor: Colors.white, // Set text color to white
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF643E37),
                  foregroundColor: Colors.white, // Set text color to white
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(),
                    ),
                  );
                },
                child: const Text('Signup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
