import 'package:flutter/material.dart';

enum TransactionType { income, expense, transfer }

extension TransactionTypeExtension on TransactionType {
  Color get color {
    switch (this) {
      case TransactionType.income:
        return Colors.greenAccent;
      case TransactionType.expense:
        return Colors.redAccent;
      case TransactionType.transfer:
        return Colors.blueAccent;
    }
  }

  String get name {
    switch (this) {
      case TransactionType.income:
        return "Income";
      case TransactionType.expense:
        return "Expense";
      case TransactionType.transfer:
        return "Transfer";
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionType.income:
        return Icons.arrow_downward_rounded;
      case TransactionType.expense:
        return Icons.arrow_upward_rounded;
      case TransactionType.transfer:
        return Icons.sync_alt_rounded;
    }
  }
}
