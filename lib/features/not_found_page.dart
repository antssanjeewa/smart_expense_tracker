import 'package:flutter/material.dart';
import '../app/pages.dart';

class NotFoundScreen extends StatelessWidget {
  final Exception? error;
  const NotFoundScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101722),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Color(0xFF3684F2)),
            const SizedBox(height: 24),
            const Text(
              "404 - Page Not Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "The page you're looking for doesn't exist.",
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Pages.home.go(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3684F2),
              ),
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
