import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/core/constants/app_assets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dashboard"),
            Text(
              "Welcome back, Ants",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: Image.asset(AppAssets.appIcon, fit: BoxFit.contain),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 16),
              _buildBarChart(),
              const SizedBox(height: 16),
              _buildSpendingBreakdown(),
              const SizedBox(height: 16),

              // Recent Transactions List
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Transactions",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              color: Color(0xFF1754cf),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // මෙතන තමයි ලිස්ට් එක පටන් ගන්නේ
                  _transactionItem(
                    title: "Apple Store",
                    subtitle: "Today • 2:15 PM",
                    amount: "-\$199.00",
                    icon: Icons.shopping_bag,
                    iconBgColor: Colors.orange.withOpacity(0.1),
                    iconColor: Colors.orange,
                  ),
                  _transactionItem(
                    title: "Company Salary",
                    subtitle: "24 Apr • 09:00 AM",
                    amount: "+\$4,200.00",
                    icon: Icons.work,
                    iconBgColor: const Color(0xFF1754cf).withOpacity(0.1),
                    iconColor: const Color(0xFF1754cf),
                  ),
                  _transactionItem(
                    title: "Starbucks",
                    subtitle: "23 Apr • 4:30 PM",
                    amount: "-\$12.50",
                    icon: Icons.restaurant,
                    iconBgColor: Colors.green.withOpacity(0.1),
                    iconColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1754cf), Color(0xFF1d4ed8)], // primary gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1754cf).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Blur Circle
          Positioned(
            right: -50,
            bottom: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Icon(Icons.account_balance_wallet, color: Colors.white70),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "\$12,450.00",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _balanceInfo("Income", "\$4,200.00", Icons.arrow_upward),
                  const SizedBox(width: 24),
                  _balanceInfo("Expenses", "\$2,840.50", Icons.arrow_downward),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceInfo(String title, String amount, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b), // slate-900
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Monthly Overview",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.expand_more, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _chartBar("Jan", 0.4),
              _chartBar("Feb", 0.6),
              _chartBar("Mar", 0.3),
              _chartBar("Apr", 0.9, isSelected: true),
              _chartBar("May", 0.5),
              _chartBar("Jun", 0.4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartBar(
    String label,
    double heightPercent, {
    bool isSelected = false,
  }) {
    return Column(
      children: [
        Container(
          height: 100 * heightPercent,
          width: 30,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1754cf)
                : const Color(0xFF1754cf).withOpacity(0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _transactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    bool isIncome = amount.contains('+');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b), // slate-900 (HTML card background)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Category Icon with subtle background
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          // Title and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Amount (Green for Income, Red for Expense)
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isIncome ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b), // slate-900
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Spending Breakdown",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Pie Chart එක
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4, // කෑලි අතර පොඩි ඉඩක්
                    centerSpaceRadius: 40, // මැද හිස් ඉඩ
                    sections: [
                      _pieSection(
                        40,
                        const Color(0xFF1754cf),
                        showTitle: false,
                      ), // Shopping
                      _pieSection(
                        25,
                        const Color(0xFFfbbf24),
                        showTitle: false,
                      ), // Food
                      _pieSection(
                        20,
                        const Color(0xFF10b981),
                        showTitle: false,
                      ), // Transport
                      _pieSection(
                        15,
                        const Color(0xFFef4444),
                        showTitle: false,
                      ), // Bills
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // අයිනේ තියෙන විස්තර ටික (Legend)
              Expanded(
                child: Column(
                  children: [
                    _chartLegend(
                      "Shopping",
                      "\$1,200",
                      const Color(0xFF1754cf),
                    ),
                    _chartLegend("Food", "\$840", const Color(0xFFfbbf24)),
                    _chartLegend("Transport", "\$420", const Color(0xFF10b981)),
                    _chartLegend("Bills", "\$380", const Color(0xFFef4444)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Pie Chart එකේ එක කෑල්ලක් (Section) හදන හැටි
  PieChartSectionData _pieSection(
    double value,
    Color color, {
    bool showTitle = false,
  }) {
    return PieChartSectionData(
      color: color,
      value: value,
      radius: 12, // HTML එකේ වගේ සිහින් පෙනුමක් ගන්න
      showTitle: showTitle,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // අයිනේ තියෙන විස්තර පේළිය හදන හැටි
  Widget _chartLegend(String title, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
