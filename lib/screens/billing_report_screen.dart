import 'package:finance_tracker_app/screens/expense_managing_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class BillingReportScreen extends StatefulWidget {
  const BillingReportScreen({super.key});

  @override
  State<BillingReportScreen> createState() => _BillingReportScreenState();
}

class _BillingReportScreenState extends State<BillingReportScreen> {
  int _currentIndex = 1;
  String _selectedMonth = 'February';

  // Category colors mapping - UPDATED to match your category colors
  final Map<String, Color> categoryColors = {
    'Salary': const Color(0xFF5C6BC0), // Indigo
    'Home': const Color(0xFF3F51B5), // Dark Indigo
    'Education': const Color(0xFF4FC3F7), // Light Blue
    'Health care': const Color(0xFFFFB300), // Amber
    'Food': const Color(0xFFE91E63), // Pink
    'Drink': const Color(0xFF00BCD4), // Cyan
    'Gasoline': const Color(0xFFBA68C8), // Purple
    'Cloth': const Color(0xFF66BB6A), // Green
    'Bonus': const Color(0xFF81D4FA), // Light Blue
    'Freelance': const Color(0xFFEF9A9A), // Light Red
    'Other': const Color(0xFF9E9E9E), // Grey
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    // Get all transactions
    final allTransactions = provider.transactions;

    // Filter by selected month
    final monthNumber = _getMonthNumber(_selectedMonth);
    final monthTransactions = allTransactions
        .where(
          (t) =>
              t.date.month == monthNumber && t.date.year == DateTime.now().year,
        )
        .toList();

    // Calculate category totals for the selected month
    Map<String, double> categoryTotals = {};
    for (var transaction in monthTransactions) {
      if (transaction.isExpense) {
        // Only count expenses for the pie chart
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }

    // Calculate total expense for percentages
    final totalExpense = categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    // Prepare pie chart sections from REAL data with CORRECT COLORS
    List<PieChartSectionData> pieSections = [];
    categoryTotals.forEach((category, amount) {
      if (amount > 0) {
        final percentage = (amount / totalExpense * 100).toStringAsFixed(0);
        pieSections.add(
          PieChartSectionData(
            value: amount,
            title: '$percentage%',
            color:
                categoryColors[category] ?? Colors.grey, // This should work now
            radius: 22,
            titleStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  _buildChartCard(pieSections, categoryTotals, totalExpense),
                  const SizedBox(height: 25),
                  _buildTransactionList(monthTransactions, categoryTotals),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransactionPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  int _getMonthNumber(String month) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return months[month] ?? DateTime.now().month;
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 0),
      decoration: const BoxDecoration(
        color: Color(0xFFB388FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Billing Report",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFFB388FF),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      // Update selected month based on picked date
                      setState(() {
                        _selectedMonth = _getMonthName(picked.month);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: Row(
              children: [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
              ].map((m) => _buildMonthTab(m, m == _selectedMonth)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildMonthTab(String month, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMonth = month;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Column(
          children: [
            Text(
              month,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            if (isSelected)
              Container(
                height: 3,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(
    List<PieChartSectionData> pieSections,
    Map<String, double> categoryTotals,
    double totalExpense,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "Total\n\$${totalExpense.toStringAsFixed(0)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    startDegreeOffset: -90,
                    sections: pieSections.isEmpty
                        ? [
                            PieChartSectionData(
                              value: 100,
                              color: Colors.grey[300]!,
                              radius: 22,
                              title: '0%',
                              titleStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ]
                        : pieSections,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildLegendItems(categoryTotals, totalExpense),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLegendItems(
    Map<String, double> categoryTotals,
    double totalExpense,
  ) {
    // Define all possible categories we want to show
    final allCategories = [
      'Salary',
      'Home',
      'Education',
      'Health care',
      'Food',
      'Drink',
      'Gasoline',
      'Cloth',
      'Bonus',
      'Freelance',
    ];

    // Filter categories that have expenses
    final categoriesWithExpenses = allCategories
        .where(
          (cat) => categoryTotals.containsKey(cat) && categoryTotals[cat]! > 0,
        )
        .toList();

    // If no expenses, show message
    if (categoriesWithExpenses.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('No expenses this month'),
        ),
      ];
    }

    return categoriesWithExpenses.map((category) {
      final amount = categoryTotals[category] ?? 0;
      final percentage = totalExpense > 0
          ? (amount / totalExpense * 100).toStringAsFixed(0)
          : '0';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: categoryColors[category] ?? Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '$category $percentage%',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTransactionList(
    List<dynamic> monthTransactions,
    Map<String, double> categoryTotals,
  ) {
    // Group transactions by category and count them
    Map<String, Map<String, dynamic>> categoryData = {};

    for (var transaction in monthTransactions) {
      if (transaction.isExpense) {
        if (!categoryData.containsKey(transaction.category)) {
          categoryData[transaction.category] = {
            'icon': _getCategoryIcon(transaction.category),
            'color':
                categoryColors[transaction.category] ??
                Colors.grey, // Use same color map
            'count': 0,
            'total': 0.0,
          };
        }
        categoryData[transaction.category]!['count']++;
        categoryData[transaction.category]!['total'] += transaction.amount;
      }
    }

    // If no transactions, show empty state
    if (categoryData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No expenses this month',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Convert to list and sort by amount
    final entries = categoryData.entries.toList()
      ..sort(
        (a, b) =>
            (b.value['total'] as double).compareTo(a.value['total'] as double),
      );

    return Column(
      children: entries.map((entry) {
        return _buildTransactionItem(
          entry.value['icon'],
          entry
              .value['color'], // This now uses the same color from categoryColors
          entry.key,
          '${entry.value['count']} transaction${entry.value['count'] > 1 ? 's' : ''}',
          '\$${(entry.value['total'] as double).toStringAsFixed(0)}',
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Salary':
        return Icons.monetization_on;
      case 'Home':
        return Icons.home_filled;
      case 'Education':
        return Icons.school;
      case 'Health care':
        return Icons.favorite;
      case 'Food':
        return Icons.restaurant;
      case 'Drink':
        return Icons.local_cafe;
      case 'Gasoline':
        return Icons.local_gas_station;
      case 'Cloth':
        return Icons.checkroom;
      case 'Bonus':
        return Icons.card_giftcard;
      case 'Freelance':
        return Icons.computer;
      default:
        return Icons.category;
    }
  }

  Widget _buildTransactionItem(
    IconData icon,
    Color color,
    String title,
    String sub,
    String price,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color, // This now matches the pie chart color
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
