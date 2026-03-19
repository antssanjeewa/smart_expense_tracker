import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transaction_di.dart';
import '../providers/transaction_form_providers.dart';

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
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedType = ref.watch(selectedTypeProvider);
    final controllerState = ref.watch(transactionControllerProvider);
    final currentWallet = ref.watch(selectedWalletProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final currentAmount = ref.watch(amountProvider);

    ref.listen<AsyncValue<void>>(
      transactionControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${error.toString()}"),
                backgroundColor: Colors.redAccent,
              ),
            );
          },
          data: (_) {
            if (previous?.isLoading == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Transaction added successfully!"),
                  backgroundColor: Colors.green,
                ),
              );

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
              _buildTypeToggle(selectedType),
              const SizedBox(height: AppSpacing.l),
              _buildAmountSection(currentAmount),
              const SizedBox(height: AppSpacing.l),
              _buildCategoryList(selectedCategory),
              const SizedBox(height: AppSpacing.l),
              _buildTitleField(),
              const SizedBox(height: AppSpacing.l),
              _buildDatePicker(selectedDate),
              const SizedBox(height: AppSpacing.l),
              _buildWalletSelector(currentWallet),
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

  Widget _buildTypeToggle(TransactionType currentType) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b), // bg-slate-800
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildToggleItem("Expense", TransactionType.expense, currentType),
          _buildToggleItem("Income", TransactionType.income, currentType),
          _buildToggleItem("Transfer", TransactionType.transfer, currentType),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
      String title, TransactionType type, TransactionType currentType) {
    final isSelected = type == currentType;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(selectedTypeProvider.notifier).update(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF334155) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3684f2) : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(double currentAmount) {
    return InkWell(
      onTap: () => _showAmountDialog(currentAmount),
      child: Column(
        children: [
          const Text(
            "AMOUNT",
            style: TextStyle(
              color: Colors.grey,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                "Rs",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                currentAmount.toStringAsFixed(2),
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAmountDialog(double currentAmount) {
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

  Widget _buildCategoryList(dynamic selectedCategory) {
    final categories = ref.watch(categoriesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text("CATEGORY",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selectedCategory?.id == cat.id;

              return GestureDetector(
                onTap: () =>
                    ref.read(selectedCategoryProvider.notifier).update(cat),
                child: Container(
                  width: 85,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF3684f2).withOpacity(0.1)
                        : const Color(0xFF1e293b).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3684f2)
                            : Colors.transparent,
                        width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon,
                          color: isSelected
                              ? const Color(0xFF3684f2)
                              : Colors.grey),
                      const SizedBox(height: 8),
                      Text(cat.name,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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

  Widget _buildDatePicker(DateTime currentDate) {
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

  Widget _buildWalletSelector(String currentWallet) {
    final wallets = ref.watch(walletsProvider);

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
    final selectedType = ref.read(selectedTypeProvider);
    final selectedCategory = ref.read(selectedCategoryProvider);
    final selectedWallet = ref.read(selectedWalletProvider);
    final selectedDate = ref.read(selectedDateProvider);

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

    await ref.read(transactionControllerProvider.notifier).addTransaction(
          title: _titleController.text.isEmpty
              ? "Untitled"
              : _titleController.text,
          amount: amount,
          date: selectedDate,
          type: selectedType,
          categoryId: selectedCategory.id,
          walletId: selectedWallet,
          note: _noteController.text,
        );
  }
}
