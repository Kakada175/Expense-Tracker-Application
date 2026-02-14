import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'billing_report_screen.dart';

// ========== MAIN TRANSACTION PAGE ==========
class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int _currentIndex = 2;
  bool _showAllTransactions = false; // Track if showing all or recent

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    // Get transactions based on view mode
    final List<Transaction> displayTransactions = _showAllTransactions
        ? provider
              .transactions // Show ALL transactions
        : provider.getRecentTransactions(limit: 5); // Show only 5 recent

    // Sort by date (newest first)
    displayTransactions.sort((a, b) => b.date.compareTo(a.date));

    final balance = provider.getAvailableBalance();
    final income = provider.getTotalIncome();
    final expense = provider.getTotalExpense();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: Text(
          _showAllTransactions ? 'All Transactions' : 'Transactions Managing',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
          // Add back button when showing all transactions
          if (_showAllTransactions)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                setState(() {
                  _showAllTransactions = false; // Go back to recent view
                });
              },
            ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Balance Card (always show)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6200EE), Color(0xFF9C27B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your available balance',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Income',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${income.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Expense',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${expense.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent/All Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showAllTransactions
                      ? 'All Transactions'
                      : 'Recent Transactions',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_showAllTransactions)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllTransactions = true; // Show all transactions
                      });
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF6200EE),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Text(
                    '${displayTransactions.length} transactions',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Transaction List
            displayTransactions.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add a transaction',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayTransactions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final transaction = displayTransactions[index];
                      return _buildTransactionItem(transaction);
                    },
                  ),
            const SizedBox(height: 20),

            // Show total count at bottom when viewing all
            if (_showAllTransactions && displayTransactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    'Showing all ${displayTransactions.length} transactions',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BillingReportScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionPage(initialTab: 0),
            ),
          ).then((_) {
            // Refresh when returning
            setState(() {});
          });
        },
        backgroundColor: const Color(0xFF6200EE),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Transaction Item Widget
  Widget _buildTransactionItem(Transaction transaction) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTransactionPage(
              transaction: transaction,
              initialTab: transaction.isExpense ? 0 : 1,
            ),
          ),
        ).then((_) {
          // Refresh when returning from edit
          setState(() {});
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (transaction.isExpense ? Colors.red : Colors.green)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: transaction.isExpense ? Colors.red : Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.description ?? 'No description',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Amount and Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: transaction.isExpense ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Transportation':
        return Icons.directions_car;
      case 'Cloth':
        return Icons.checkroom;
      case 'Coffee':
        return Icons.local_cafe;
      case 'Gas':
      case 'Gasoline':
        return Icons.local_gas_station;
      case 'Food':
        return Icons.restaurant;
      case 'Health care':
        return Icons.favorite;
      case 'Home':
        return Icons.home_filled;
      case 'Education':
        return Icons.school;
      case 'Drink':
        return Icons.local_cafe;
      case 'Salary':
        return Icons.attach_money;
      case 'Bonus':
        return Icons.card_giftcard;
      case 'Freelance':
        return Icons.computer;
      default:
        return Icons.more_horiz;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbr(date.month)} ${date.year}';
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

// ========== ADD TRANSACTION PAGE ==========
class AddTransactionPage extends StatefulWidget {
  final Transaction? transaction;
  final int initialTab;

  const AddTransactionPage({super.key, this.transaction, this.initialTab = 0});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late bool isExpense;
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late String selectedCategory;
  late DateTime selectedDate;
  bool isEditMode = false;

  // Categories for Expense
  final List<Map<String, dynamic>> expenseCategories = [
    {
      'name': 'Education',
      'icon': Icons.school,
      'color': const Color(0xFF4FC3F7),
    },
    {
      'name': 'Home',
      'icon': Icons.home_filled,
      'color': const Color(0xFF3F51B5),
    },
    {
      'name': 'Drink',
      'icon': Icons.local_cafe,
      'color': const Color(0xFF1197A9),
    },
    {
      'name': 'Gasoline',
      'icon': Icons.local_gas_station,
      'color': const Color(0xFFBA68C8),
    },
    {
      'name': 'Food',
      'icon': Icons.restaurant,
      'color': const Color(0xFFE91E63),
    },
    {
      'name': 'Health care',
      'icon': Icons.add,
      'color': const Color(0xFFFF9800),
    },
    {
      'name': 'Cloth',
      'icon': Icons.checkroom,
      'color': const Color(0xFF66BB6A),
    },
    {
      'name': 'Other',
      'icon': Icons.more_horiz,
      'color': const Color(0xFF9E9E9E),
    },
  ];

  // Sources for Income
  final List<Map<String, dynamic>> incomeSources = [
    {
      'name': 'Salary',
      'icon': Icons.monetization_on,
      'color': const Color(0xFF5C6BC0),
    },
    {
      'name': 'Bonus',
      'icon': Icons.card_giftcard,
      'color': const Color(0xFF81D4FA),
    },
    {
      'name': 'Freelance',
      'icon': Icons.computer,
      'color': const Color(0xFFEF9A9A),
    },
    {
      'name': 'Other',
      'icon': Icons.more_horiz,
      'color': const Color(0xFFC4C5C6),
    },
  ];

  @override
  void initState() {
    super.initState();
    isEditMode = widget.transaction != null;

    if (isEditMode) {
      isExpense = widget.transaction!.isExpense;
      amountController = TextEditingController(
        text: widget.transaction!.amount.toString(),
      );
      descriptionController = TextEditingController(
        text: widget.transaction!.description ?? '',
      );
      selectedCategory = widget.transaction!.category;
      selectedDate = widget.transaction!.date;
    } else {
      isExpense = widget.initialTab == 0;
      amountController = TextEditingController();
      descriptionController = TextEditingController();
      selectedCategory = isExpense ? 'Food' : 'Salary';
      selectedDate = DateTime.now();
    }

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: isExpense ? 0 : 1,
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      isExpense = _tabController.index == 0;
      selectedCategory = isExpense ? 'Food' : 'Salary';
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6200EE)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double amount;
    try {
      amount = double.parse(amountController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = Provider.of<TransactionProvider>(context, listen: false);

    if (isEditMode) {
      final updatedTransaction = Transaction(
        id: widget.transaction!.id,
        title: selectedCategory,
        category: selectedCategory,
        amount: amount,
        date: selectedDate,
        isExpense: isExpense,
        description: descriptionController.text,
      );
      provider.updateTransaction(updatedTransaction);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${isExpense ? 'Expense' : 'Income'} updated'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: selectedCategory,
        category: selectedCategory,
        amount: amount,
        date: selectedDate,
        isExpense: isExpense,
        description: descriptionController.text,
      );
      provider.addTransaction(newTransaction);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${isExpense ? 'Expense' : 'Income'} added'),
          backgroundColor: Colors.green,
        ),
      );
    }

    Navigator.pop(context);
  }

  void _deleteTransaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isExpense ? 'Delete Expense' : 'Delete Income'),
        content: Text(
          'Are you sure you want to delete this ${isExpense ? 'expense' : 'income'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      provider.deleteTransaction(widget.transaction!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${isExpense ? 'Expense' : 'Income'} deleted'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditMode
              ? (isExpense ? 'Edit Expense' : 'Edit Income')
              : (isExpense ? 'Add Expends' : 'Add Income'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ), // Add padding to move arrow down
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        titleSpacing: 0, // Adjust title spacing
        toolbarHeight: 100, // Increase toolbar height to give more space
        actions: isEditMode
            ? [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ), // Add padding to move delete icon down
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: _deleteTransaction,
                  ),
                ),
              ]
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.purple[400],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold, // Changed to bold
                ),
                tabs: const [
                  Tab(text: 'Expense'),
                  Tab(text: 'Income'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Field
            const Text(
              'Amount',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  hintText: '0.00',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  prefixStyle: TextStyle(
                    color: isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category/Source Field
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Square Categories Grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: (isExpense ? expenseCategories : incomeSources).map((
                item,
              ) {
                final isSelected = item['name'] == selectedCategory;
                final backgroundColor = item['color'] as Color;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = item['name'];
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Icon(item['icon'], color: Colors.white, size: 24),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Date Field
            const Text(
              'Date',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: isExpense ? Colors.red : Colors.green,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description Field
            const Text(
              'Description(Optional)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter description...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEditMode ? 'Update' : 'Save',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
