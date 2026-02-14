import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  // Mock data initialization
  TransactionProvider() {
    _initMockData();
  }

  void _initMockData() {
    _transactions = [
      // ===== FEBRUARY TRANSACTIONS (for February Saving) =====
      // Income in February
      Transaction(
        id: 'f1',
        title: 'Salary',
        category: 'Salary',
        amount: 1500.00,
        date: DateTime(2024, 2, 1),
        isExpense: false,
      ),
      Transaction(
        id: 'f2',
        title: 'Bonus',
        category: 'Bonus',
        amount: 500.00,
        date: DateTime(2024, 2, 15),
        isExpense: false,
      ),
      Transaction(
        id: 'f12',
        title: 'Saving',
        category: 'Saving',
        amount: 500.00,
        date: DateTime(2026, 1, 15),
        isExpense: false,
        description: 'Income goals',
      ),
      Transaction(
        id: 'f13',
        title: 'Investment',
        category: 'Investments',
        amount: 300.00,
        date: DateTime(2026, 1, 15),
        isExpense: false,
        description: 'Income goals',
      ),

      // Expenses in February
      Transaction(
        id: 'f3',
        title: 'Health Insurance',
        category: 'Health care',
        amount: 280.00,
        date: DateTime(2026, 1, 5),
        isExpense: true,
        description: 'Monthly premium',
      ),
      Transaction(
        id: 'f4',
        title: 'Groceries',
        category: 'Food',
        amount: 120.00,
        date: DateTime(2026, 1, 10),
        isExpense: true,
        description: 'Weekly groceries',
      ),
      Transaction(
        id: 'f5',
        title: 'Electricity',
        category: 'Home',
        amount: 100.00,
        date: DateTime(2026, 1, 8),
        isExpense: true,
        description: 'Monthly bill',
      ),
      Transaction(
        id: 'f6',
        title: 'Education',
        category: 'Education',
        amount: 80.00,
        date: DateTime(2026, 1, 12),
        isExpense: true,
        description: 'Course fee',
      ),

      // ===== SEPTEMBER TRANSACTIONS (for Recent Transactions) =====
      Transaction(
        id: '7',
        title: 'Transportation',
        category: 'Gasoline',
        amount: 5.00,
        date: DateTime(2026, 1, 10),
        isExpense: true,
        description: 'Uber',
      ),
      Transaction(
        id: '8',
        title: 'Cloth',
        category: 'Cloth',
        amount: 50.00,
        date: DateTime(2026, 2, 14),
        isExpense: true,
      ),
      Transaction(
        id: '9',
        title: 'Coffee',
        category: 'Drink',
        amount: 5.00,
        date: DateTime(2026, 2, 6),
        isExpense: true,
      ),
      Transaction(
        id: '10',
        title: 'Gas',
        category: 'Gasoline',
        amount: 10.00,
        date: DateTime(2026, 2, 10),
        isExpense: true,
      ),
      Transaction(
        id: '11',
        title: 'Food',
        category: 'Food',
        amount: 15.00,
        date: DateTime(2026, 1, 6),
        isExpense: true,
      ),
      // Transaction(
      //   id: '12',
      //   title: 'Rent',
      //   category: 'Home',
      //   amount: 800.00,
      //   date: DateTime(2024, 9, 1),
      //   isExpense: true,
      // ),
    ];
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  double getTotalIncome() {
    return _transactions
        .where((t) => !t.isExpense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getTotalExpense() {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getAvailableBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  Map<String, double> getExpensesByCategory() {
    Map<String, double> expenses = {};
    _transactions.where((t) => t.isExpense).forEach((t) {
      expenses[t.category] = (expenses[t.category] ?? 0) + t.amount;
    });
    return expenses;
  }

  List<Transaction> getRecentTransactions({int limit = 5}) {
    List<Transaction> sorted = List.from(_transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void updateTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (t) => t.id == updatedTransaction.id,
    );
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  // Get total for specific category
  double getCategoryTotal(String category) {
    return _transactions
        .where((t) => t.category == category)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get February saving (Income - Expense for February)
  double getFebruarySaving() {
    // Sum all INCOME in February
    final febIncome = _transactions
        .where((t) => !t.isExpense && t.date.month == 2)
        .fold(0.0, (sum, t) => sum + t.amount);

    // Sum all EXPENSES in February
    final febExpense = _transactions
        .where((t) => t.isExpense && t.date.month == 2)
        .fold(0.0, (sum, t) => sum + t.amount);

    // Print for debugging (remove in production)
    print('February Income: $febIncome');
    print('February Expense: $febExpense');
    print('February Saving: ${febIncome - febExpense}');

    return febIncome - febExpense;
  }

  // Get today's total expense ONLY (not net)
  double getTodayTotalExpense() {
    final now = DateTime.now();
    return _transactions
        .where(
          (t) =>
              t.isExpense &&
              t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
