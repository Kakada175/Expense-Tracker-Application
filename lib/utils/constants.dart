import 'package:flutter/material.dart';

class AppConstants {
  static const List<String> categories = [
    'Education',
    'Home',
    'Drink',
    'Gasoline',
    'Food',
    'Health care',
    'Cloth',
    'Other',
  ];

  static const List<String> incomeSources = [
    'Salary',
    'Bonus',
    'Freelance',
    'Other',
  ];

  static const List<String> months = [
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

  static const Map<String, Color> categoryColors = {
    'Salary': Color(0xFF4CAF50),
    'Bonus': Color(0xFF2196F3),
    'Freelance': Color(0xFF9C27B0),
    'Home': Color(0xFFF44336),
    'Health care': Color(0xFFFF9800),
    'Food': Color(0xFFFFC107),
    'Drink': Color(0xFF00BCD4),
    'Cloth': Color(0xFFE91E63),
    'Gasoline': Color(0xFF607D8B),
    'Education': Color(0xFF3F51B5),
    'Other': Color(0xFF9E9E9E),
  };
}

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color accent = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
}
