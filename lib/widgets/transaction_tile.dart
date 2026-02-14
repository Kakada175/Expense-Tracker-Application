import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = transaction.isExpense ? AppColors.error : AppColors.success;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const SizedBox(), // Replace with actual screen
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
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
                    transaction.category,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: transaction.isExpense
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('d MMM yyyy').format(transaction.date),
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
      case 'Salary':
      case 'Bonus':
      case 'Freelance':
        return Icons.attach_money;
      case 'Home':
        return Icons.home;
      case 'Health care':
        return Icons.favorite;
      case 'Food':
        return Icons.restaurant;
      case 'Drink':
        return Icons.local_cafe;
      case 'Cloth':
        return Icons.shopping_bag;
      case 'Gasoline':
        return Icons.local_gas_station;
      case 'Education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}
