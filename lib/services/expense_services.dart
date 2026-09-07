import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/expense.dart';

class ExpenseService {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();
  Future<void> addExpense(Expense expense) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not signed in.');
    }

    final expenseRef = _database
        .child('users')
        .child(user.uid)
        .child('expenses')
        .push();

    await expenseRef.set(expense.toMap());
  }
}
