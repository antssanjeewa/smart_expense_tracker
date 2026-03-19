import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class CurrencyPickerSheet extends ConsumerWidget {
  const CurrencyPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(appSettingsProvider).currency;

    final currencies = [
      {'code': 'LKR', 'name': 'Sri Lankan Rupee', 'symbol': 'රු'},
      {'code': 'USD', 'name': 'United States Dollar', 'symbol': '\$'},
      {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
      {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1e293b), // ඔයාගේ ඇප් එකේ තීම් එකට ගැලපෙන පාටක්
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            "Select Currency",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: currencies.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.white10),
              itemBuilder: (context, index) {
                final c = currencies[index];
                final isSelected = currentCurrency == c['code'];

                return ListTile(
                  onTap: () {
                    ref
                        .read(appSettingsProvider.notifier)
                        .updateCurrency(c['code']!);
                    Navigator.pop(context);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text(c['symbol']!,
                        style: const TextStyle(color: Colors.blue)),
                  ),
                  title: Text(c['name']!,
                      style: const TextStyle(color: Colors.white)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
