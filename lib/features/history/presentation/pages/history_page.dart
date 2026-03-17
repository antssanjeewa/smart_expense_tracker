import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import 'transaction_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> filters = ["All", "Expenses", "Income", "Refunds"];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: AppColors.background,
              expandedHeight: 180,
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
                            icon: const Icon(Icons.more_vert),
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
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.s,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final bool isSelected = index == 0;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    filters[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.onPrimary
                                          : AppColors.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (!isSelected) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                      color: AppColors.onSurface,
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: Text("TODAY"),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const TransactionTile(
                  title: "Apple Store",
                  category: "Electronics",
                  time: "2:45 PM",
                  amount: -1299.00,
                  icon: Icons.shopping_bag_outlined,
                  iconBgColor: Colors.red,
                ),
                const TransactionTile(
                  title: "Salary Deposit",
                  category: "TechCorp Inc",
                  time: "10:45 AM",
                  amount: 199.00,
                  icon: Icons.money,
                  iconBgColor: Colors.blue,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
