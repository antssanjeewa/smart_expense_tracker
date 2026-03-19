import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/transaction_filter_provider.dart';
import '../providers/transaction_form_providers.dart';
import '../widgets/transaction_tile.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    // final transactionsAsync = ref.watch(transactionsStreamProvider);
    final filter = ref.watch(transactionFilterProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transactions",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: PopupMenuButton<TransactionSort>(
                              icon: const Icon(Icons.sort_rounded,
                                  color: Colors.grey),
                              onSelected: (TransactionSort sort) {
                                ref
                                    .read(transactionFilterProvider.notifier)
                                    .setSort(sort);
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
                            ),
                          ),
                        ],
                      ),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: "Search transactions",
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: AppColors.surface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _filterChip(ref, "All", null, filter.type == null),
                            _filterChip(ref, "Income", TransactionType.income,
                                filter.type == TransactionType.income),
                            _filterChip(
                                ref,
                                "Expenses",
                                TransactionType.expense,
                                filter.type == TransactionType.expense),

                            // Date Picker Button
                            IconButton(
                              icon: Icon(Icons.calendar_month,
                                  color: filter.dateRange != null
                                      ? Colors.blue
                                      : Colors.grey),
                              onPressed: () async {
                                final range = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now());
                                ref
                                    .read(transactionFilterProvider.notifier)
                                    .setDateRange(range);
                              },
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 50,
                      //   child: ListView.separated(
                      //     padding: const EdgeInsets.symmetric(
                      //       vertical: AppSpacing.s,
                      //     ),
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: filters.length,
                      //     separatorBuilder: (_, __) => const SizedBox(width: 8),
                      //     itemBuilder: (context, index) {
                      //       final bool isSelected = index == 0;
                      //       return Container(
                      //         padding: const EdgeInsets.symmetric(
                      //           horizontal: 20,
                      //           vertical: 8,
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: isSelected
                      //               ? AppColors.primary
                      //               : AppColors.surface,
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Row(
                      //           children: [
                      //             Text(
                      //               filters[index],
                      //               style: TextStyle(
                      //                 color: isSelected
                      //                     ? AppColors.onPrimary
                      //                     : AppColors.onSurface,
                      //                 fontWeight: isSelected
                      //                     ? FontWeight.bold
                      //                     : FontWeight.w500,
                      //                 fontSize: 13,
                      //               ),
                      //             ),
                      //             if (!isSelected) ...[
                      //               const SizedBox(width: 4),
                      //               const Icon(
                      //                 Icons.keyboard_arrow_down,
                      //                 size: 16,
                      //                 color: AppColors.onSurface,
                      //               ),
                      //             ],
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            transactionsAsync.when(
              data: (transactions) {
                final Map<String, List<TransactionEntity>> grouped = {};
                for (var tx in transactions) {
                  final dateKey = tx.date.relativeDate;
                  grouped.putIfAbsent(dateKey, () => []).add(tx);
                }

                final keys = grouped.keys.toList();

                if (transactions.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("No transactions yet.")),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= keys.length) return null;
                      final dateKey = keys[index];
                      final txs = grouped[dateKey]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              dateKey,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
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

  Widget _filterChip(
      WidgetRef ref, String label, TransactionType? type, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) =>
            ref.read(transactionFilterProvider.notifier).setType(type),
      ),
    );
  }

  String _getCategoryName(WidgetRef ref, String id) {
    final categories = ref.read(categoriesProvider);
    return categories
        .firstWhere((c) => c.id == id, orElse: () => categories.first)
        .name;
  }

  IconData _getCategoryIcon(WidgetRef ref, String id) {
    final categories = ref.read(categoriesProvider);
    return categories
        .firstWhere((c) => c.id == id, orElse: () => categories.first)
        .icon;
  }

  Color _getCategoryColor(WidgetRef ref, String id) {
    final categories = ref.read(categoriesProvider);
    return categories
        .firstWhere((c) => c.id == id, orElse: () => categories.first)
        .color;
  }
}
