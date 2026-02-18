import 'package:finance_tracker_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
//import '../models/transaction_model.dart';
import '../widgets/toggle_tab.dart';
import '../widgets/category_chip.dart';
import '../widgets/budget_card.dart';
import '../widgets/bottom_nav_bar.dart';
import 'transaction_screen.dart';
import 'graph_screen.dart';
//import 'expense_managing_screen.dart'; // Make sure to import this

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpend = true;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get the transaction provider
    final provider = Provider.of<TransactionProvider>(context);

    // Calculate real-time data from transactions
    final totalIncome = provider.getTotalIncome();
    final totalExpense = provider.getTotalExpense();
    final februarySaving = provider.getFebruarySaving();

    // Calculate TODAY's total expense only (not net)
    final todayExpense = provider.getTodayTotalExpense();

    // Get category-specific totals for budget cards
    final healthCareTotal = provider.getCategoryTotal('Health care');
    final educationTotal = provider.getCategoryTotal('Education');
    final investmentsTotal = provider.getCategoryTotal('Investments');
    final savingTotal = provider.getCategoryTotal('Saving');

    return Scaffold(
      // Match the very light grey background seen in the UI
      backgroundColor: const Color(0xFFF8F9FE),
      body: Column(
        children: [
          _buildHeader(todayExpense), // Pass only today's expense
          const SizedBox(height: 10),
          // Toggle tab sits on the main background, not inside the purple container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ToggleTab(
              isExpend: isExpend,
              onChanged: (val) => setState(() => isExpend = val),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: isExpend
                  ? _buildExpendPage(
                      provider,
                      totalIncome,
                      totalExpense,
                      februarySaving,
                      healthCareTotal,
                      educationTotal,
                      todayExpense,
                    )
                  : _buildIncomePage(
                      provider,
                      totalIncome,
                      investmentsTotal,
                      savingTotal,
                    ),
            ),
          ),
        ],
      ),
      // ADD THIS LINE BELOW:
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to different screens
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BillingReportScreen(),
              ),
            ).then((_) {
              // Reset to home (index 0) when coming back
              setState(() {
                _currentIndex = 0;
              });
            });
          }
          // Navigate to different screens
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransactionPage()),
            ).then((_) {
              // Reset to home (index 0) when coming back
              setState(() {
                _currentIndex = 0;
              });
            });
          }
          // Navigate to different screens
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ).then((_) {
              // Reset to home (index 0) when coming back
              setState(() {
                _currentIndex = 0;
              });
            });
          }
        },
      ),
    );
  }

  // UPDATED header to show only today's expense and keep Upgrade button
  Widget _buildHeader(double todayExpense) {
    // Format the date as "14/2/2026" or similar
    final String formattedDate =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

    return Container(
      // Only padding for the status bar and the row content
      padding: const EdgeInsets.only(top: 50, bottom: 25),
      decoration: const BoxDecoration(
        color: Color(0xFFB388FF), // Purple Header
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.menu, color: Colors.black, size: 28),
            Column(
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  isExpend ? "Today: \$${todayExpense.toStringAsFixed(2)}" : "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            isExpend
                ? const Text(
                    "Upgrade",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                    size: 28,
                  ),
          ],
        ),
      ),
    );
  }

  // --- EXPEND PAGE with real data ---
  Widget _buildExpendPage(
    TransactionProvider provider,
    double totalIncome,
    double totalExpense,
    double februarySaving,
    double healthCareTotal,
    double educationTotal,
    double todayExpense,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroSavingsCard(februarySaving, totalIncome, totalExpense),

        // Optional: You can keep or remove this "Today's Spending" card
        // If you want to remove it, just delete this section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Spending",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "\$${todayExpense.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: todayExpense > 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Text(
            "Top Spending",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        // Horizontally scrollable row as requested
        _buildTopSpendingRow(),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
          child: Text(
            "Monthly Budget",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        _buildHorizontalBudgets(healthCareTotal, educationTotal),
      ],
    );
  }

  // --- INCOME PAGE with real data ---
  Widget _buildIncomePage(
    TransactionProvider provider,
    double totalIncome,
    double investmentsTotal,
    double savingTotal,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroIncomeCard(totalIncome),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
          child: Text(
            "Income Sources",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        _buildIncomeSourcesRow(),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
          child: Text(
            "Income Goals",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        _buildHorizontalGoals(investmentsTotal, savingTotal),
      ],
    );
  }

  // --- SCROLLABLE ROW FOR TOP SPENDING ---
  Widget _buildTopSpendingRow() {
    final items = [
      {"l": "Home", "i": Icons.home, "c": const Color(0xFF3D5AFE)},
      {"l": "Health", "i": Icons.add_box, "c": const Color(0xFFFFD54F)},
      {"l": "Food", "i": Icons.restaurant, "c": const Color(0xFFE91E63)},
      {"l": "Cloth", "i": Icons.checkroom, "c": const Color(0xFF66BB6A)},
      {"l": "Education", "i": Icons.school, "c": const Color(0xFF4DD0E1)},
      {
        "l": "Gasoline",
        "i": Icons.local_gas_station,
        "c": const Color(0xFF9575CD),
      },
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CategoryChip(
                  label: e['l'] as String,
                  icon: e['i'] as IconData,
                  color: e['c'] as Color,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // --- REMAINING UI COMPONENTS (Hero cards, etc.) with real data ---
  Widget _buildHeroSavingsCard(
    double februarySaving,
    double totalIncome,
    double totalExpense,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "February Saving",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            "\$${februarySaving.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildHeroBar("Earned", totalIncome, const Color(0xFF4DD0E1)),
          const SizedBox(height: 12),
          _buildHeroBar("Spend", totalExpense, const Color(0xFFE91E63)),
        ],
      ),
    );
  }

  Widget _buildHeroBar(String label, double val, Color color) {
    // Calculate width factor based on real values (max expected: 2000)
    double maxValue = 2000.0;
    double widthFactor = (val / maxValue).clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        FractionallySizedBox(
          widthFactor: widthFactor,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .8),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 6,
          child: Text(
            "\$${val.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroIncomeCard(double totalIncome) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 45),
      decoration: BoxDecoration(
        color: const Color(0xFFB388FF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            "\$${totalIncome.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "TOTAL INCOME",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeSourcesRow() {
    final sources = [
      {"l": "Salary", "i": Icons.monetization_on, "c": const Color(0xFF42A5F5)},
      {
        "l": "Bonus",
        "i": Icons.card_giftcard_outlined,
        "c": const Color(0xFF81D4FA),
      },
      {"l": "Freelance", "i": Icons.computer, "c": const Color(0xFFEF9A9A)},
      {"l": "Other", "i": Icons.more_horiz, "c": const Color(0xFFC4C5C6)},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: sources
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CategoryChip(
                  label: e['l'] as String,
                  icon: e['i'] as IconData,
                  color: e['c'] as Color,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildHorizontalBudgets(
    double healthCareTotal,
    double educationTotal,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          BudgetCard(
            title: "Health care",
            subtitle: "\$10 Per day",
            current: healthCareTotal,
            total: 500,
            color: const Color(0xFFFFD54F),
            icon: Icons.add_box,
          ),
          const SizedBox(width: 15),
          BudgetCard(
            title: "Education",
            subtitle: "\$10 Per day",
            current: educationTotal,
            total: 800,
            color: const Color(0xFF4DD0E1),
            icon: Icons.school,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalGoals(double investmentsTotal, double savingTotal) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          BudgetCard(
            title: "Investments",
            subtitle: "\$10 Per day",
            current: investmentsTotal,
            total: 1000,
            color: const Color(0xFF4DB6AC),
            icon: Icons.account_balance,
          ),
          const SizedBox(width: 15),
          BudgetCard(
            title: "Saving",
            subtitle: "\$10 Per day",
            current: savingTotal,
            total: 1000,
            color: const Color(0xFFF06292),
            icon: Icons.savings,
          ),
        ],
      ),
    );
  }
}
