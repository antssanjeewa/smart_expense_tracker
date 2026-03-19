import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/transaction_filter_provider.dart';
import '../providers/transaction_form_providers.dart';
import '../widgets/transaction_tile.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

/// Minimum year for date picker range.
const int _minPickerYear = 2020;

/// Spacing between filter chips.
const double _filterChipSpacing = 8.0;

/// Font size for date headers in transaction list.
const double _dateHeaderFontSize = 12.0;

// ============================================================================
// HISTORY PAGE
// ============================================================================

/// Main transaction history/list page.
///
/// Displays all transactions with advanced filtering, searching, and sorting.
/// Features:
/// - Filter by transaction type (Income/Expense/All)
/// - Filter by date range with date picker
/// - Search by transaction title or notes
/// - Sort by date (newest/oldest) or amount (high/low)
/// - Grouped display by transaction date
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final filter = ref.watch(transactionFilterProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ================================================================
            // SLIVER APP BAR - Header with filters and search
            // ================================================================
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: AppColors.background,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m,
                    vertical: AppSpacing.s,
                  ),
                  child: Column(
                    children: [
                      // Title and sort button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transactions",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          _buildSortMenu(ref),
                        ],
                      ),
                      // Search field
                      _buildSearchField(ref, filter),
                      const SizedBox(height: AppSpacing.s),
                      // Filter chips and date picker
                      _buildFilterBar(ref, filter),
                    ],
                  ),
                ),
              ),
            ),
            // ================================================================
            // TRANSACTION LIST
            // ================================================================
            transactionsAsync.when(
              data: (transactions) {
                // Group transactions by date
                final Map<String, List<TransactionEntity>> grouped = {};
                for (var tx in transactions) {
                  final dateKey = tx.date.relativeDate;
                  grouped.putIfAbsent(dateKey, () => []).add(tx);
                }

                final keys = grouped.keys.toList();

                // Show empty state if no transactions
                if (transactions.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("No transactions yet.")),
                  );
                }

                // Build transaction list grouped by date
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= keys.length) return null;
                      final dateKey = keys[index];
                      final txs = grouped[dateKey]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              dateKey,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: _dateHeaderFontSize,
                              ),
                            ),
                          ),
                          // Transaction tiles for this date
                          ...txs.map((tx) => TransactionTile(
                                title: tx.title,
                                category: _getCategoryName(ref, tx.categoryId),
                                time: DateFormatter.formatTime(tx.date),
                                amount: tx.type == TransactionType.expense
                                    ? -tx.amount
                                    : tx.amount,
                                icon: _getCategoryIcon(ref, tx.categoryId),
                                iconBgColor:
                                    _getCategoryColor(ref, tx.categoryId),
                              )),
                        ],
                      );
                    },
                    childCount: transactions.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text("Error: $err")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // HELPER METHODS - UI BUILDERS
  // ==========================================================================

  /// Builds the sort menu popup button.
  Widget _buildSortMenu(WidgetRef ref) {
    return PopupMenuButton<TransactionSort>(
      icon: const Icon(Icons.sort_rounded, color: Colors.grey),
      onSelected: (TransactionSort sort) {
        ref.read(transactionFilterProvider.notifier).setSort(sort);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: TransactionSort.newest,
          child: Text("Newest First"),
        ),
        const PopupMenuItem(
          value: TransactionSort.oldest,
          child: Text("Oldest First"),
        ),
        const PopupMenuItem(
          value: TransactionSort.amountHigh,
          child: Text("Amount: High to Low"),
        ),
        const PopupMenuItem(
          value: TransactionSort.amountLow,
          child: Text("Amount: Low to High"),
        ),
      ],
    );
  }

  /// Builds the search input field.
  Widget _buildSearchField(WidgetRef ref, TransactionFilterState filter) {
    return TextField(
      onChanged: (value) {
        ref.read(transactionFilterProvider.notifier).updateSearchQuery(value);
      },
      decoration: InputDecoration(
        hintText: "Search transactions",
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: filter.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  ref
                      .read(transactionFilterProvider.notifier)
                      .updateSearchQuery("");
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }

  /// Builds the filter bar with type chips and date picker.
  Widget _buildFilterBar(WidgetRef ref, TransactionFilterState filter) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Type filter chips
          _buildFilterChip(
            ref,
            "All",
            null,
            filter.type == null,
          ),
          _buildFilterChip(
            ref,
            "Income",
            TransactionType.income,
            filter.type == TransactionType.income,
          ),
          _buildFilterChip(
            ref,
            "Expenses",
            TransactionType.expense,
            filter.type == TransactionType.expense,
          ),
          // Date range picker button
          _buildDatePickerButton(ref, filter),
        ],
      ),
    );
  }

  /// Builds a single type filter chip.
  Widget _buildFilterChip(
    WidgetRef ref,
    String label,
    TransactionType? type,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: _filterChipSpacing),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) =>
            ref.read(transactionFilterProvider.notifier).setType(type),
      ),
    );
  }

  /// Builds the date range picker button.
  Widget _buildDatePickerButton(WidgetRef ref, TransactionFilterState filter) {
    return Builder(
      builder: (context) => IconButton(
        icon: Icon(
          Icons.calendar_month,
          color: filter.dateRange != null ? Colors.blue : Colors.grey,
        ),
        onPressed: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime(_minPickerYear),
            lastDate: DateTime.now(),
          );
          if (range != null) {
            ref.read(transactionFilterProvider.notifier).setDateRange(range);
          }
        },
      ),
    );
  }

  // ==========================================================================
  // HELPER METHODS - DATA RETRIEVAL
  // ==========================================================================

  /// Gets the category name for a given category ID.
  String _getCategoryName(WidgetRef ref, String id) {
    final categories = ref.read(categoriesProvider);
    return categories
        .firstWhere(
          (c) => c.id == id,
          orElse: () => categories.first,
        )
        .name;
  }

  /// Gets the category icon for a given category ID.
  IconData _getCategoryIcon(WidgetRef ref, String id) {
    final categories = ref.read(categoriesProvider);
    return categories
        .firstWhere(
          (c) => c.id == id,
          orElse: () => categories.first,
        )
        .icon;
  }

  /// Gets the category color for a given category ID.
  Color _getCategoryColor(WidgetRef ref, String id) {
    final categories = ref.read(categoriesProvider);
    return categories
        .firstWhere(
          (c) => c.id == id,
          orElse: () => categories.first,
        )
        .color;
  }
}
