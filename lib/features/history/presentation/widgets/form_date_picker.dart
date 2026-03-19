import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../providers/transaction_form_providers.dart';

class FormDatePicker extends ConsumerWidget {
  const FormDatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(selectedDateProvider);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1e293b).withAlpha(160),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Text(
              DateFormatter.formatDate(currentDate),
            )),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          ref.read(selectedDateProvider.notifier).update(pickedDate);
        }
      },
    );
  }
}
