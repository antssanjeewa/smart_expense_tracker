import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/category_model.dart';
import '../../domain/entities/transaction_type.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

const List<String> _defaultWallets = [
  'Main Wallet',
  'Cash',
  'Bank Account',
];

const List<CategoryModelData> _categoryDefinitions = [
  CategoryModelData(
    id: 'food',
    name: 'Food',
    icon: Icons.restaurant,
    color: Colors.orangeAccent,
  ),
  CategoryModelData(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car,
    color: Colors.purpleAccent,
  ),
  CategoryModelData(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.pinkAccent,
  ),
  CategoryModelData(
    id: 'health',
    name: 'Health',
    icon: Icons.medical_services,
    color: Colors.blueAccent,
  ),
  CategoryModelData(
    id: 'bills',
    name: 'Bills',
    icon: Icons.receipt_long,
    color: Colors.redAccent,
  ),
  CategoryModelData(
    id: 'salary',
    name: 'Salary',
    icon: Icons.payments,
    color: Colors.greenAccent,
  ),
];

// ============================================================================
// DATA CLASSES
// ============================================================================

/// Temporary data class for category definition.
/// TODO: Move categories to database instead of hardcoding.
class CategoryModelData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModelData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  CategoryModel toModel() => CategoryModel(
        id: id,
        name: name,
        icon: icon,
        color: color,
      );
}

// ============================================================================
// AMOUNT NOTIFIER & PROVIDER
// ============================================================================

/// Manages the transaction amount input state.
class AmountNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  /// Updates the transaction amount.
  void update(double value) => state = value;

  /// Resets the amount to zero.
  void reset() => state = 0.0;
}

/// Provider for managing transaction amount.
/// Auto-disposes when no longer watched.
final amountProvider = NotifierProvider.autoDispose<AmountNotifier, double>(
  AmountNotifier.new,
);

// ============================================================================
// CATEGORY NOTIFIERS & PROVIDERS
// ============================================================================

/// Provides the list of available transaction categories.
final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  return _categoryDefinitions.map((data) => data.toModel()).toList();
});

/// Manages the selected category for a new transaction.
class SelectedCategoryNotifier extends Notifier<CategoryModel?> {
  @override
  CategoryModel? build() => null;

  /// Selects a category.
  void update(CategoryModel category) => state = category;

  /// Clears the selected category.
  void clear() => state = null;
}

/// Provider for managing the selected category.
/// Auto-disposes when the form is closed.
final selectedCategoryProvider =
    NotifierProvider.autoDispose<SelectedCategoryNotifier, CategoryModel?>(
  SelectedCategoryNotifier.new,
);

// ============================================================================
// TRANSACTION TYPE NOTIFIER & PROVIDER
// ============================================================================

/// Manages the transaction type (Income/Expense).
class SelectedTypeNotifier extends Notifier<TransactionType> {
  @override
  TransactionType build() => TransactionType.expense;

  /// Changes the transaction type.
  void update(TransactionType type) => state = type;

  /// Toggles between income and expense.
  void toggle() {
    state = state == TransactionType.income
        ? TransactionType.expense
        : TransactionType.income;
  }
}

/// Provider for managing the selected transaction type.
/// Defaults to expense.
final selectedTypeProvider =
    NotifierProvider.autoDispose<SelectedTypeNotifier, TransactionType>(
  SelectedTypeNotifier.new,
);

// ============================================================================
// WALLET NOTIFIERS & PROVIDERS
// ============================================================================

/// Provides the list of available wallets/accounts.
/// TODO: Move wallets to database for multi-user support.
final walletsProvider = Provider<List<String>>((ref) {
  return _defaultWallets;
});

/// Manages the selected wallet for the transaction.
class SelectedWalletNotifier extends Notifier<String> {
  @override
  String build() => _defaultWallets.first;

  /// Selects a wallet.
  void update(String wallet) => state = wallet;

  /// Resets to the default wallet.
  void reset() => state = _defaultWallets.first;
}

/// Provider for managing the selected wallet.
/// Defaults to the first wallet in the list.
final selectedWalletProvider =
    NotifierProvider.autoDispose<SelectedWalletNotifier, String>(
  SelectedWalletNotifier.new,
);

// ============================================================================
// DATE NOTIFIER & PROVIDER
// ============================================================================

/// Manages the transaction date.
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  /// Updates the transaction date.
  void update(DateTime date) => state = date;

  /// Resets to today.
  void reset() => state = DateTime.now();
}

/// Provider for managing the selected transaction date.
/// Defaults to today.
final selectedDateProvider =
    NotifierProvider.autoDispose<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);
