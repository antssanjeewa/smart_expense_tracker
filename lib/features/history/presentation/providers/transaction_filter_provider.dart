import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import 'transaction_di.dart';

// ============================================================================
// ENUMS
// ============================================================================

/// Defines sorting options for transactions.
enum TransactionSort { newest, oldest, amountHigh, amountLow }

// ============================================================================
// STATE CLASS
// ============================================================================

/// Immutable state holder for transaction filtering, sorting, and searching.
///
/// This class combines all filter criteria into a single state object
/// that can be updated atomically using [copyWith].
class TransactionFilterState {
  /// Transaction type filter (income/expense/null for all).
  final TransactionType? type;

  /// Current sort order for transactions.
  final TransactionSort sortBy;

  /// Date range filter for transactions.
  final DateTimeRange? dateRange;

  /// Search query string for transaction title and notes.
  final String searchQuery;

  TransactionFilterState({
    this.type,
    this.sortBy = TransactionSort.newest,
    this.dateRange,
    this.searchQuery = '',
  });

  /// Creates a copy of this state with modified fields.
  ///
  /// Pass [clearType] = true to clear the type filter (show all).
  /// Pass [clearDateRange] = true to clear the date range filter.
  TransactionFilterState copyWith({
    TransactionType? type,
    bool clearType = false,
    TransactionSort? sortBy,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
    String? searchQuery,
  }) {
    return TransactionFilterState(
      type: clearType ? null : (type ?? this.type),
      sortBy: sortBy ?? this.sortBy,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ============================================================================
// NOTIFIER
// ============================================================================

/// Manages the transaction filter state.
///
/// Handles updates to filter criteria including type, sort order,
/// date range, and search query.

class TransactionFilterNotifier extends Notifier<TransactionFilterState> {
  @override
  TransactionFilterState build() => TransactionFilterState();

  /// Updates the transaction type filter.
  void setType(TransactionType? type) =>
      state = state.copyWith(type: type, clearType: type == null);

  /// Updates the sort order.
  void setSort(TransactionSort sort) => state = state.copyWith(sortBy: sort);

  /// Updates the date range filter.
  void setDateRange(DateTimeRange? range) =>
      state = state.copyWith(dateRange: range);

  /// Clears the date range filter.
  void clearDateRange() => state = state.copyWith(clearDateRange: true);

  /// Updates the search query.
  void updateSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);

  /// Clears all filters and resets to default state.
  void clearFilters() => state = TransactionFilterState();
}

// ============================================================================
// PROVIDERS
// ============================================================================

/// Provider for managing transaction filter state.
/// Auto-disposes when no longer watched.

final transactionFilterProvider = NotifierProvider.autoDispose<
    TransactionFilterNotifier,
    TransactionFilterState>(TransactionFilterNotifier.new);

/// Provides filtered and sorted transactions based on current filter state.
///
/// This computed provider combines:
/// - Raw transactions from [transactionsStreamProvider]
/// - Filter state (type, date range, search query)
/// - Auto-applies filtering and sorting
///
/// Re-computes automatically when any filter criteria changes.
final filteredTransactionsProvider =
    Provider.autoDispose<AsyncValue<List<TransactionEntity>>>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);
  final filter = ref.watch(transactionFilterProvider);

  return transactionsAsync.whenData((list) {
    // Apply all filters in a single pass
    final filteredList = list.where((tx) {
      // Search: Match in title or notes (case-insensitive)
      final matchesSearch = filter.searchQuery.isEmpty ||
          tx.title.toLowerCase().contains(filter.searchQuery.toLowerCase()) ||
          (tx.note?.toLowerCase().contains(filter.searchQuery.toLowerCase()) ??
              false);

      // Type: Filter by income/expense or show all if null
      final matchesType = filter.type == null || tx.type == filter.type;

      // Date: Filter by date range (inclusive)
      final matchesDate = filter.dateRange == null ||
          (tx.date.isAfter(filter.dateRange!.start) &&
              tx.date.isBefore(
                  filter.dateRange!.end.add(const Duration(days: 1))));

      return matchesSearch && matchesType && matchesDate;
    }).toList();

    // Apply sorting based on selected sort order
    switch (filter.sortBy) {
      case TransactionSort.newest:
        filteredList.sort((a, b) => b.date.compareTo(a.date));
      case TransactionSort.oldest:
        filteredList.sort((a, b) => a.date.compareTo(b.date));
      case TransactionSort.amountHigh:
        filteredList.sort((a, b) => b.amount.compareTo(a.amount));
      case TransactionSort.amountLow:
        filteredList.sort((a, b) => a.amount.compareTo(b.amount));
    }

    return filteredList;
  });
});
