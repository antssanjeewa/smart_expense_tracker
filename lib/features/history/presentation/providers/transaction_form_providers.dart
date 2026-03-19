// Categories List එක
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/category_model.dart';
import '../../domain/entities/transaction_entity.dart';

class AmountNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void update(double value) => state = value;
}

final amountProvider =
    NotifierProvider<AmountNotifier, double>(AmountNotifier.new);

final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  return [
    CategoryModel(id: 'food', name: 'Food', icon: Icons.restaurant),
    CategoryModel(
        id: 'transport', name: 'Transport', icon: Icons.directions_car),
    CategoryModel(id: 'shopping', name: 'Shopping', icon: Icons.shopping_bag),
    CategoryModel(id: 'health', name: 'Health', icon: Icons.medical_services),
    CategoryModel(id: 'bills', name: 'Bills', icon: Icons.receipt_long),
    CategoryModel(id: 'salary', name: 'Salary', icon: Icons.payments),
  ];
});

class SelectedCategoryNotifier extends Notifier<CategoryModel?> {
  @override
  CategoryModel? build() => null;
  void update(CategoryModel cat) => state = cat;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, CategoryModel?>(
        SelectedCategoryNotifier.new);

// 3. Selected Transaction Type Notifier (Income/Expense)
class SelectedTypeNotifier extends Notifier<TransactionType> {
  @override
  TransactionType build() => TransactionType.expense;
  void update(TransactionType type) => state = type;
}

final selectedTypeProvider =
    NotifierProvider<SelectedTypeNotifier, TransactionType>(
        SelectedTypeNotifier.new);

// 4. Selected Wallet Notifier
// Wallet types (Accounts)
final walletsProvider =
    Provider<List<String>>((ref) => ['Main Wallet', 'Cash', 'Bank Account']);

class SelectedWalletNotifier extends Notifier<String> {
  @override
  String build() => "Main Wallet";
  void update(String wallet) => state = wallet;
}

final selectedWalletProvider = NotifierProvider<SelectedWalletNotifier, String>(
    SelectedWalletNotifier.new);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();
  void update(DateTime date) => state = date;
}

final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);
