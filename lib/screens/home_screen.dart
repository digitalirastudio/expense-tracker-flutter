import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:expense_tracker/screens/auth_gate.dart';
import 'package:expense_tracker/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _expensesRef =
      FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
          )
          .ref()
          .child('users')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('expenses');
  Stream<List<Expense>> _expensesStream() {
    return _expensesRef.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return <Expense>[];
      }

      final expensesMap = Map<dynamic, dynamic>.from(data as Map);

      return expensesMap.entries.map((entry) {
        return Expense.fromMap(
          entry.key.toString(),
          Map<dynamic, dynamic>.from(entry.value),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Expense Tracker'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Icon(
              Icons.account_circle,
              size: 100,
              color: Color(0xFF235347),
            ),
            Text(
              FirebaseAuth.instance.currentUser?.displayName ?? 'User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(
                          Icons.account_circle,
                          size: 48,
                          color: Color(0xFF235347),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Welcome back 👋'),
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ??
                              'User',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            ),

            const SizedBox(height: 24),

            StreamBuilder<List<Expense>>(
              stream: _expensesStream(),
              builder: (context, snapshot) {
                final expenses = snapshot.data ?? [];

                final totalExpenses = expenses.fold<double>(
                  0,
                  (sum, expense) => sum + expense.amount,
                );

                return Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF235347),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Expenses',
                        style: TextStyle(color: Color(0xFFDAF1DE)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rs. ${totalExpenses.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFFDAF1DE),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${expenses.length} transaction${expenses.length == 1 ? '' : 's'}',
                        style: const TextStyle(color: Color(0xFFDAF1DE)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransactionsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            StreamBuilder<List<Expense>>(
              stream: _expensesStream(),
              builder: (context, snapshot) {
                final expenses = snapshot.data ?? [];

                if (expenses.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No expenses yet.'),
                  );
                }

                final recentExpenses = List<Expense>.from(expenses)
                  ..sort((a, b) => b.id.compareTo(a.id));

                final displayedExpenses = recentExpenses.take(3).toList();

                return Column(
                  children: displayedExpenses.map((expense) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: const Color(0xFF235347),
                        leading: const Icon(
                          Icons.receipt_long,
                          color: Color(0xFFDAF1DE),
                        ),
                        title: Text(
                          expense.category,
                          style: const TextStyle(color: Color(0xFFDAF1DE)),
                        ),
                        subtitle: Text(
                          '${expense.date} • ${expense.time}',
                          style: const TextStyle(color: Color(0xFFDAF1DE)),
                        ),
                        trailing: Text(
                          'Rs. ${expense.amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFFDAF1DE),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensesScreen()),
          );
        },
        backgroundColor: const Color(0xFF235347),
        child: const Icon(Icons.add, color: Color(0xFFDAF1DE)),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
