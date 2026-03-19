import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_type.dart';
import '../providers/transaction_form_providers.dart';

class FormAmountSection extends ConsumerWidget {
  const FormAmountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAmount = ref.watch(amountProvider);
    final type = ref.watch(selectedTypeProvider);

    return InkWell(
      onTap: () => _showAmountBottomSheet(context, ref, currentAmount),
      child: Column(
        children: [
          const Text("AMOUNT",
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Rs",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: type.color)),
              const SizedBox(width: 4),
              Text(
                currentAmount.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: type.color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAmountBottomSheet(
      BuildContext context, WidgetRef ref, double currentAmount) {
    final controller = TextEditingController(
        text: currentAmount == 0 ? "" : currentAmount.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1e293b),
        title: const Text("Enter Amount"),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 24, color: Colors.white),
          decoration: const InputDecoration(
            hintText: "0.00",
          ),
        ),
        actions: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text) ?? 0.0;
                ref.read(amountProvider.notifier).update(val);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
