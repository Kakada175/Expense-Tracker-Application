import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double current;
  final double total;
  final Color color;
  final IconData icon;

  const BudgetCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.current,
    required this.total,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate width factor for the progress bar
    double progressPercent = (current / total).clamp(0.0, 1.0);

    return Container(
      width: 280, // Fixed width for horizontal scrolling
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // Very light grey/white
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF000000).withValues(alpha: .5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Circular Icon matching the UI
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .2),
                  shape: BoxShape.circle,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stack for the Progress Bar with text inside
          Stack(
            children: [
              // Background Bar
              Container(
                height: 32,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFCDCD),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              // Progress Fill
              FractionallySizedBox(
                widthFactor: progressPercent,
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63), // Pink from UI
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '\$${current.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Total text at the end
              Positioned(
                right: 12,
                top: 8,
                child: Text(
                  '\$${total.toInt()}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
