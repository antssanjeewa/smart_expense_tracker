import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import 'transaction_di.dart';

enum TransactionSort { newest, oldest, amountHigh, amountLow }

class TransactionFilterState {
  final TransactionType? type; // null නම් "All"
  final TransactionSort sortBy;
  final DateTimeRange? dateRange;

  TransactionFilterState({
    this.type,
    this.sortBy = TransactionSort.newest,
    this.dateRange,
  });

  // CopyWith එකක් ඕනේ State එකේ එක කොටසක් විතරක් වෙනස් කරන්න
  TransactionFilterState copyWith({
    TransactionType? type,
    bool clearType = false,
    TransactionSort? sortBy,
    DateTimeRange? dateRange,
  }) {
    return TransactionFilterState(
      type: clearType ? null : (type ?? this.type),
      sortBy: sortBy ?? this.sortBy,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

// Notifier එක
class TransactionFilterNotifier extends Notifier<TransactionFilterState> {
  @override
  TransactionFilterState build() => TransactionFilterState();

  void setType(TransactionType? type) =>
      state = state.copyWith(type: type, clearType: type == null);
  void setSort(TransactionSort sort) => state = state.copyWith(sortBy: sort);
  void setDateRange(DateTimeRange? range) =>
      state = state.copyWith(dateRange: range);
}

final transactionFilterProvider =
    NotifierProvider<TransactionFilterNotifier, TransactionFilterState>(
        TransactionFilterNotifier.new);

final filteredTransactionsProvider =
    Provider<AsyncValue<List<TransactionEntity>>>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);
  final filter = ref.watch(transactionFilterProvider);

  return transactionsAsync.whenData((list) {
    Iterable<TransactionEntity> filteredList = list;

    // 1. Filter by Type
    if (filter.type != null) {
      filteredList = filteredList.where((tx) => tx.type == filter.type);
    }

    // 2. Filter by Date Range
    if (filter.dateRange != null) {
      filteredList = filteredList.where((tx) =>
          tx.date.isAfter(filter.dateRange!.start) &&
          tx.date.isBefore(filter.dateRange!.end.add(const Duration(days: 1))));
    }

    // 3. Sorting logic
    List<TransactionEntity> sortedList = filteredList.toList();

    switch (filter.sortBy) {
      case TransactionSort.newest:
        sortedList.sort((a, b) => b.date.compareTo(a.date));
        break;
      case TransactionSort.oldest:
        sortedList.sort((a, b) => a.date.compareTo(b.date));
        break;
      case TransactionSort.amountHigh:
        sortedList.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case TransactionSort.amountLow:
        sortedList.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
    return sortedList;
  });
});
