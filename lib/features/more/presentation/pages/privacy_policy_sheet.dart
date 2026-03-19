import 'package:flutter/material.dart';

class PrivacyPolicySheet extends StatelessWidget {
  const PrivacyPolicySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1e293b), // Dark theme color
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      // මෙතන DraggableScrollableSheet පාවිච්චි කළොත් යූසර්ට ඕන විදිහට අදින්න පුළුවන්
      child: Column(
        children: [
          // උඩ තියෙන පොඩි ඉර (Handle)
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          const Text("Privacy Policy",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 15),

          // දිග Text එකක් නිසා Expanded සහ SingleChildScrollView ඕනේ
          Expanded(
            child: SingleChildScrollView(
              child: const Text(
                """
1. Data Collection
We collect your email and transaction data to provide expense tracking services.

2. Local Storage
Your financial data is stored locally using Isar Database on your device.

3. Security
We use industry-standard encryption. Biometric data is handled by your device OS and is never stored on our servers.

4. Third Party
We use Supabase for cloud synchronization if enabled.
                """,
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("I Understand"),
          ),
        ],
      ),
    );
  }
}
