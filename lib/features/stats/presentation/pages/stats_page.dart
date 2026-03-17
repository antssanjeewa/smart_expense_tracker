import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _selectedTab = 0; // 0: Weekly, 1: Monthly, 2: Yearly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f172a), // background-dark
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: AppSpacing.l),
            _buildBestSavingsCard(),
            const SizedBox(height: AppSpacing.l),
            _buildSpendingLineChart(),
            const SizedBox(height: AppSpacing.xl),
            _buildTopCategoriesSection(),
            _buildCategoryListView(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "Statistics",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.file_download_outlined,
            color: AppColors.primary,
          ),
          onPressed: () {}, // PDF Export වගේ වැඩකට
        ),
      ],
    );
  }

  Widget _buildBestSavingsCard() {
    return InkWell(
      onTap: () =>
          _showSavingsHistory(context), // මේ Function එක පහතින් තියෙනවා
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1754cf).withOpacity(0.2),
              const Color(0xFF1754cf).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFF1754cf).withOpacity(0.2)),
        ),
        child: ClipRRect(
          // පිරිසිදු නිමාවට
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background එකේ තියෙන ලස්සන අලංකාර රවුම (UX - Visual Depth)
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.stars,
                  size: 100,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // වම් පැත්ත: දත්ත (UI - Data Focus)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF3684f2,
                                  ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_graph,
                                  size: 16,
                                  color: Color(0xFF3684f2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "TOTAL SAVINGS",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "\$2,450.80",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Insight Text (UX - Encouragement)
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_upward,
                                color: Colors.greenAccent,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "15% more",
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: " than last month"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // දකුණු පැත්ත: Progress (UX - Goal Tracking)
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: CircularProgressIndicator(
                                value: 0.72, // උදා: බජට් එකෙන් 72% ක් සේව් කරලා
                                strokeWidth: 6,
                                backgroundColor: Colors.white.withOpacity(0.05),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF3684f2),
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            const Text(
                              "72%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "GOAL",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSavingsHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // අපිට Custom පෙනුමක් ගන්න ඕන නිසා
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 0.7, // Screen එකෙන් 70% ක්
          decoration: const BoxDecoration(
            color: Color(0xFF1e293b),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // යටට අදින Handle එක (Visual cue for UX)
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Savings History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Track your progress over the last 6 months",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    // Mini Performance Chart (Simple Column bars)
                    _buildMiniGrowthChart(),

                    const SizedBox(height: 32),
                    const Text(
                      "Breakdown",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // History Items
                    _historyItem(
                      "March 2026",
                      "+\$450.00",
                      "High Efficiency",
                      Colors.greenAccent,
                    ),
                    _historyItem(
                      "February 2026",
                      "+\$210.50",
                      "Average",
                      Colors.blueAccent,
                    ),
                    _historyItem(
                      "January 2026",
                      "+\$580.00",
                      "Excellent",
                      Colors.amberAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniGrowthChart() {
    // සේවිංග්ස් දත්ත (0.0 සිට 1.0 දක්වා අගයන්)
    final List<double> growthData = [0.4, 0.7, 0.5, 0.9, 0.6, 0.85];
    final List<String> months = ["Oct", "Nov", "Dec", "Jan", "Feb", "Mar"];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(growthData.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Bar එක
              AnimatedContainer(
                duration: Duration(
                  milliseconds: 500 + (index * 100),
                ), // එකින් එක පිපී එන පෙනුමට
                height: 70 * growthData[index],
                width: 35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3684f2),
                      const Color(0xFF3684f2).withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: index == growthData.length - 1
                    ? const Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 14,
                      ) // අන්තිම එකට special icon එකක්
                    : null,
              ),
              const SizedBox(height: 8),
              // මාසය
              Text(
                months[index],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _historyItem(String month, String amount, String tag, Color tagColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                tag,
                style: TextStyle(
                  color: tagColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ["Weekly", "Monthly", "Yearly"];
    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    periods[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSpendingLineChart() {
    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, right: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b).withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ["M", "T", "W", "T", "F", "S", "S"];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    );
                  }
                  return const Text("");
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 1.5),
                FlSpot(2, 3),
                FlSpot(3, 2.5),
                FlSpot(4, 4),
                FlSpot(5, 3),
                FlSpot(6, 5),
              ],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top Spending",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        _buildProgressTile("Food & Drinks", "\$840.00", 0.75, Colors.orange),
        _buildProgressTile("Transport", "\$420.00", 0.45, Colors.greenAccent),
        _buildProgressTile("Shopping", "\$380.00", 0.35, Colors.blueAccent),
        _buildProgressTile(
          "Subscriptions",
          "\$150.00",
          0.15,
          Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildCategoryListView() {
    // මේක සාමාන්‍යයෙන් Supabase/Database එකෙන් එන ඩේටා ලිස්ට් එකක් විදිහට හිතන්න
    final List<Map<String, dynamic>> budgetData = [
      {
        "title": "Groceries",
        "count": 22,
        "spent": 640.0,
        "budget": 800.0,
        "icon": Icons.shopping_basket,
        "color": Colors.orange,
      },
      {
        "title": "Housing",
        "count": 3,
        "spent": 1200.0,
        "budget": 1200.0,
        "icon": Icons.home,
        "color": Colors.blue,
      },
      {
        "title": "Entertainment",
        "count": 8,
        "spent": 125.0,
        "budget": 300.0,
        "icon": Icons.movie,
        "color": Colors.purple,
      },
      {
        "title": "Dining Out",
        "count": 14,
        "spent": 550.0,
        "budget": 450.0,
        "icon": Icons.restaurant,
        "color": Colors.purpleAccent,
      },
    ];

    return Column(
      children: [
        // Header කොටස
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Text(
                  "See All",
                  style: TextStyle(
                    color: Color(0xFF3684f2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                label: const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFF3684f2),
                ),
              ),
            ],
          ),
        ),

        // ලිස්ට් එක
        ListView.separated(
          shrinkWrap: true, // Column එකක් ඇතුළේ තියෙන නිසා මේක වැදගත්
          physics:
              const NeverScrollableScrollPhysics(), // මුළු පේජ් එකම scroll වෙනවා නම් මේක දාන්න
          itemCount: budgetData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = budgetData[index];
            return _buildBudgetCategoryCard(
              title: data['title'],
              transactionCount: data['count'],
              spentAmount: data['spent'],
              budgetAmount: data['budget'],
              icon: data['icon'],
              color: data['color'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBudgetCategoryCard({
    required String title,
    required int transactionCount,
    required double spentAmount,
    required double budgetAmount,
    required IconData icon,
    required Color color,
  }) {
    double progress = (spentAmount / budgetAmount).clamp(0.0, 1.0);
    bool isOverBudget = spentAmount > budgetAmount;
    double remaining = budgetAmount - spentAmount;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b), // dark:bg-slate-900
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // වම් පැත්ත: Icon සහ විස්තර
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "$transactionCount transactions",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // දකුණු පැත්ත: මුදල් ප්‍රමාණයන්
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\$${spentAmount.toInt()} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isOverBudget
                                ? Colors.redAccent
                                : Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "/ \$${budgetAmount.toInt()}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isOverBudget
                        ? "Over by \$${(spentAmount - budgetAmount).toInt()}"
                        : remaining == 0
                        ? "Budget Reached"
                        : "\$${remaining.toInt()} left",
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverBudget
                          ? Colors.redAccent
                          : (remaining == 0
                                ? Colors.blueAccent
                                : Colors.greenAccent),
                      fontWeight: isOverBudget
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar එක
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? Colors.redAccent : color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTile(
    String title,
    String amount,
    double progress,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
