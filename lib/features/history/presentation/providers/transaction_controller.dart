import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart';
import 'transaction_di.dart';

class TransactionController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() => null;

  Future<void> addTransaction({
    required String title,
    required double amount,
    required DateTime date,
    required type,
    required String categoryId,
    required String walletId,
    String? note,
  }) async {
    state = const AsyncValue.loading();

    final transaction = TransactionEntity(
      title: title,
      amount: amount,
      date: date,
      type: type,
      categoryId: categoryId,
      walletId: walletId,
      note: note,
    );

    final repository = ref.read(transactionRepositoryProvider);

    state =
        await AsyncValue.guard(() => repository.addTransaction(transaction));
  }
}
