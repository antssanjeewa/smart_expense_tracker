import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart';
import 'transaction_di.dart';

class TransactionController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() => null;

  Future<void> addTransaction(TransactionEntity transaction) async {
    state = const AsyncValue.loading();
    final repository = ref.read(transactionRepositoryProvider);

    state =
        await AsyncValue.guard(() => repository.addTransaction(transaction));
  }
}
