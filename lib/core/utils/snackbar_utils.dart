import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';

extension SnackBarExtension on BuildContext {
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // void showError(String message) {
  //   ScaffoldMessenger.of(this).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         style: const TextStyle(color: Colors.white),
  //       ),
  //       backgroundColor: Colors.redAccent,
  //       duration: const Duration(seconds: 3),
  //     ),
  //   );
  // }
  void showError(String message) {
    showCupertinoDialog(
      context: this,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          "Error",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void showInfo(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
