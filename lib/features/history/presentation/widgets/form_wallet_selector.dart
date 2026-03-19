import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_form_providers.dart';

class FormWalletSelector extends ConsumerWidget {
  const FormWalletSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);
    final currentWallet = ref.watch(selectedWalletProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b).withAlpha(160),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentWallet,
          hint: const Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  color: Colors.grey, size: 20),
              SizedBox(width: 12),
              Text("Select Wallet", style: TextStyle(color: Colors.grey)),
            ],
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF1e293b),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: wallets.map((String wallet) {
            return DropdownMenuItem<String>(
              value: wallet,
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.grey, size: 20),
                  const SizedBox(width: 12),
                  Text(wallet,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey)),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              ref.read(selectedWalletProvider.notifier).update(newValue);
            }
          },
        ),
      ),
    );
  }
}
