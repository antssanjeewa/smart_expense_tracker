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

// ============================================================================
// CONSTANTS
// ============================================================================

/// Default amount value for form initialization.
const String _defaultAmountText = '0.00';

/// Default title for transactions without a description.
const String _defaultTransactionTitle = 'Untitled';

/// Number of lines for the note/description text field.
const int _noteFieldLines = 3;

// ============================================================================
// ADD TRANSACTION PAGE
// ============================================================================

/// Page for adding a new financial transaction.
///
/// Provides comprehensive form for creating transactions with:
/// - Transaction type selection (Income/Expense)
/// - Amount input with validation
/// - Category selection from predefined list
/// - Title/description for the transaction
/// - Date/time picker
/// - Wallet/account selection
/// - Optional notes
class AddTransaction extends ConsumerStatefulWidget {
  const AddTransaction({super.key});

  @override
  ConsumerState<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransaction> {
  /// Text controller for transaction amount.
  late final TextEditingController _amountController;

  /// Text controller for transaction notes.
  late final TextEditingController _noteController;

  /// Text controller for transaction title/description.
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: _defaultAmountText);
    _noteController = TextEditingController();
    _titleController = TextEditingController();
  }

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

    // Listen for transaction addition result
    ref.listen<AsyncValue<void>>(
      transactionControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            context.showError(error.toString());
          },
          data: (_) {
            if (previous?.isLoading == true) {
              context.showSuccess('Transaction added successfully!');
              Navigator.pop(context);
            }
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.l),
              // ================================================================
              // FORM FIELDS
              // ================================================================
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
              _buildNoteField(),
              const SizedBox(height: AppSpacing.l),
              // ================================================================
              // SUBMIT BUTTON
              // ================================================================
              _buildSaveButton(controllerState),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // HELPER METHODS - UI BUILDERS
  // ==========================================================================

  /// Builds the transaction title input field.
  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Transaction Title',
        isDense: true,
        prefixIcon: const Icon(Icons.title, color: Colors.grey),
        filled: true,
        fillColor: AppColors.surface.withAlpha(120),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Builds the transaction notes input field.
  Widget _buildNoteField() {
    return TextField(
      maxLines: _noteFieldLines,
      controller: _noteController,
      decoration: InputDecoration(
        hintText: 'Add notes...',
        prefixIcon: const Icon(Icons.notes, color: Colors.grey),
        filled: true,
        fillColor: AppColors.surface.withAlpha(120),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Builds the save/submit button with loading state.
  Widget _buildSaveButton(AsyncValue state) {
    return ElevatedButton(
      onPressed: state.isLoading ? null : _handleSaveTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: AppColors.primary.withAlpha(100),
      ),
      child: state.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text(
              'Save Transaction',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }

  // ==========================================================================
  // HELPER METHODS - DATA HANDLING
  // ==========================================================================

  /// Validates and saves the transaction.
  Future<void> _handleSaveTransaction() async {
    final amount = ref.read(amountProvider);
    final selectedCategory = ref.read(selectedCategoryProvider);

    // Validate amount
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Validate category selection
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    // Create transaction entity
    final newTransaction = TransactionEntity(
      title: _titleController.text.trim().isEmpty
          ? _defaultTransactionTitle
          : _titleController.text.trim(),
      amount: amount,
      date: ref.read(selectedDateProvider),
      type: ref.read(selectedTypeProvider),
      categoryId: selectedCategory.id,
      walletId: ref.read(selectedWalletProvider),
      note: _noteController.text.trim(),
    );

    // Submit transaction
    await ref
        .read(transactionControllerProvider.notifier)
        .addTransaction(newTransaction);
  }
}
