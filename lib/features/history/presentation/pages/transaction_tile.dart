import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/core/utils/currency_formatter.dart';

import '../../../../core/constants/constants.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final double amount;
  final IconData icon;
  final Color iconBgColor;

  const TransactionTile({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = amount < 0;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconBgColor),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '$category • $time',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Text(
            CurrencyFormatter.formatCurrency(amount),
            style: TextStyle(
              color: isExpense ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Divider(color: AppColors.onSurface.withAlpha(50), height: 1),
        ),
      ],
    );
  }
}
