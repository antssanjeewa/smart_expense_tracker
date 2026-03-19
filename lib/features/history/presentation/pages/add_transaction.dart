import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transaction_di.dart';
import '../providers/transaction_form_providers.dart';
import '../widgets/form_amount_section.dart';
import '../widgets/form_category_list.dart';
import '../widgets/form_date_picker.dart';
import '../widgets/form_toggle_type.dart';
import '../widgets/form_wallet_selector.dart';

class AddTransaction extends ConsumerStatefulWidget {
  const AddTransaction({super.key});

  @override
  ConsumerState<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransaction> {
  final _amountController = TextEditingController(text: "0.00");
  final _noteController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(transactionControllerProvider);

    ref.listen<AsyncValue<void>>(
      transactionControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            context.showError(error.toString());
          },
          data: (_) {
            if (previous?.isLoading == true) {
              context.showSuccess("Transaction added successfully!");
              Navigator.pop(context);
            }
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.l),
              const FormToggleType(),
              const SizedBox(height: AppSpacing.l),
              const FormAmountSection(),
              const SizedBox(height: AppSpacing.l),
              const FormCategoryList(),
              const SizedBox(height: AppSpacing.l),
              _buildTitleField(),
              const SizedBox(height: AppSpacing.l),
              const FormDatePicker(),
              const SizedBox(height: AppSpacing.l),
              const FormWalletSelector(),
              const SizedBox(height: AppSpacing.l),
              _buildNoteFields(),
              const SizedBox(height: AppSpacing.l),
              _buildSaveButton(controllerState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: "Transaction Title",
        isDense: true,
        prefixIcon: const Icon(Icons.title, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1e293b).withAlpha(120),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildNoteFields() {
    return TextField(
      maxLines: 3,
      controller: _noteController,
      decoration: InputDecoration(
        hintText: "Add notes...",
        prefixIcon: const Icon(Icons.notes, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1e293b).withAlpha(120),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton(AsyncValue state) {
    return ElevatedButton(
      onPressed: state.isLoading ? null : _saveData,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3684f2),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: const Color(0xFF3684f2).withAlpha(100),
      ),
      child: state.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Text(
              "Save Transaction",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }

  Future<void> _saveData() async {
    final amount = ref.read(amountProvider);
    final selectedCategory = ref.read(selectedCategoryProvider);

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid amount")));
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please Select Category")));
      return;
    }

    final newTransaction = TransactionEntity(
      title: _titleController.text.trim().isEmpty
          ? "Untitled"
          : _titleController.text.trim(),
      amount: amount,
      date: ref.read(selectedDateProvider),
      type: ref.read(selectedTypeProvider),
      categoryId: selectedCategory.id,
      walletId: ref.read(selectedWalletProvider),
      note: _noteController.text,
    );

    await ref
        .read(transactionControllerProvider.notifier)
        .addTransaction(newTransaction);
  }
}
