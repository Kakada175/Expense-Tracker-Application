class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'isExpense': isExpense,
      'description': description,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      isExpense: json['isExpense'],
      description: json['description'],
    );
  }
}
