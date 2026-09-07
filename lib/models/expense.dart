class Expense {
  final String id;
  final String category;
  final double amount;
  final String date;
  final String time;
  final String note;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.time,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'date': date,
      'time': time,
      'note': note,
    };
  }

  factory Expense.fromMap(String id, Map<dynamic, dynamic> map) {
    return Expense(
      id: id,
      category: map['category'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      note: map['note'] ?? '',
    );
  }
}
