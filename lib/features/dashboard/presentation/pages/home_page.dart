import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/core/constants/app_assets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dashboard"),
            Text(
              "Welcome back, Ants",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: Image.asset(AppAssets.appIcon, fit: BoxFit.contain),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: const Center(child: Text("Welcome to the Home Page!")),
    );
  }
}
