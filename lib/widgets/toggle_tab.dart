import 'package:flutter/material.dart';

class ToggleTab extends StatelessWidget {
  final bool isExpend;
  final ValueChanged<bool> onChanged;

  const ToggleTab({super.key, required this.isExpend, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 224, 223, 223), // Light grey track
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildButton('Expend', isExpend, () => onChanged(true)),
          _buildButton('Income', !isExpend, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _buildButton(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF6200EE) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[500],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
