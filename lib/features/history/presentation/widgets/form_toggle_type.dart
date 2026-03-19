import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/transaction_form_providers.dart';

class FormToggleType extends ConsumerWidget {
  const FormToggleType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedTypeProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b).withAlpha(150),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildToggleItem(
            ref,
            type: TransactionType.expense,
            isSelected: selectedType == TransactionType.expense,
          ),
          _buildToggleItem(
            ref,
            type: TransactionType.income,
            isSelected: selectedType == TransactionType.income,
          ),
          _buildToggleItem(
            ref,
            type: TransactionType.transfer,
            isSelected: selectedType == TransactionType.transfer,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    WidgetRef ref, {
    required TransactionType type,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(selectedTypeProvider.notifier).update(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? type.color.withAlpha(40) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? type.color.withAlpha(100) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              type.name,
              style: TextStyle(
                color: isSelected ? type.color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
