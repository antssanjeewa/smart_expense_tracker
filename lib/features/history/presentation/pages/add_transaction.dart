import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class AddTransaction extends StatelessWidget {
  const AddTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.l),
              _buildTypeToggle(),

              const SizedBox(height: AppSpacing.l),
              _buildAmountSection(),

              const SizedBox(height: AppSpacing.l),
              _buildCategoryList(),

              const SizedBox(height: AppSpacing.l),
              _buildActionFields(),

              // const Spacer(),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b), // bg-slate-800
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildToggleItem("Expense", isSelected: true),
          _buildToggleItem("Income"),
          _buildToggleItem("Transfer"),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, {bool isSelected = false}) {
    return Expanded(
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
              color: isSelected ? AppColors.primary : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return const Column(
      children: [
        Text(
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
            Text(
              "\$",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 4),
            Text(
              "0.00",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    final categories = [
      {'name': 'Food', 'icon': Icons.restaurant, 'isSelected': true},
      {'name': 'Transport', 'icon': Icons.directions_car, 'isSelected': false},
      {'name': 'Shopping', 'icon': Icons.shopping_bag, 'isSelected': false},
      {'name': 'Health', 'icon': Icons.medical_services, 'isSelected': false},
      {'name': 'Bills', 'icon': Icons.receipt_long, 'isSelected': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "CATEGORY",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final bool isSelected = cat['isSelected'] as bool;

              return Container(
                width: 85,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF3684f2).withOpacity(0.1)
                      : const Color(0xFF1e293b).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF3684f2)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      color: isSelected ? const Color(0xFF3684f2) : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionFields() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Date Picker Field
          _buildSelectionTile(
            icon: Icons.calendar_today_outlined,
            label: "October 24, 2023",
            onTap: () {},
          ),
          const SizedBox(height: 12),

          // Account/Wallet Selector
          _buildSelectionTile(
            icon: Icons.account_balance_wallet_outlined,
            label: "Main Wallet",
            onTap: () {},
          ),
          const SizedBox(height: 12),

          // Notes Input Field
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Add notes...",
              prefixIcon: const Icon(Icons.notes, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1e293b).withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1e293b).withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3684f2),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF3684f2).withOpacity(0.4),
        ),
        child: const Text(
          "Save Transaction",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
