// ignore_for_file: use_build_context_synchronously
import 'package:expense_tracker/screens/profile_screen.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:expense_tracker/screens/auth_gate.dart';
import 'package:expense_tracker/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Avatar variable to hold the current avatar
  String _avatar = '👤';
  // Database reference for expenses
  final DatabaseReference _expensesRef =
      FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
          )
          .ref()
          .child('users')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('expenses');
  // Function to get a stream of expenses from the database
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

  Map<String, double> _getCategoryTotals(List<Expense> expenses) {
    final categoryTotals = <String, double>{};

    for (final expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  //avtar stream to update the avatar in real-time
  Stream<String> _avatarStream() {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
        )
        .ref()
        .child('users')
        .child(user!.uid)
        .child('profile')
        .child('avatar')
        .onValue
        .map((event) {
          final avatar = event.snapshot.value?.toString() ?? '👤';

          if (mounted && _avatar != avatar) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _avatar = avatar;
                });
              }
            });
          }

          return avatar;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Expense Tracker'),
      ),
      // Drawer for navigation and user account information
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF235347)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color(0xFFDAF1DE),
                child: Text(_avatar, style: const TextStyle(fontSize: 32)),
              ),
              accountName: Text(
                FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
              ),
            ),
            // Drawer items for navigation
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Transactions'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionsScreen(),
                  ),
                );
              },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // StreamBuilder to listen for avatar changes in real-time
                  StreamBuilder<String>(
                    stream: _avatarStream(),
                    builder: (context, snapshot) {
                      final avatar = snapshot.data ?? _avatar;

                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFDAF1DE),
                          child: Text(
                            avatar,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Welcome Back'),
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ??
                              'User',
                        ),
                      ],
                    ),
                  ),
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
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF235347),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Color(0xFFDAF1DE),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Total Expenses',
                          style: TextStyle(
                            color: Color(0xFFDAF1DE),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rs. ${totalExpenses.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFFDAF1DE),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${expenses.length} transaction${expenses.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Color(0xFFDAF1DE),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              StreamBuilder<List<Expense>>(
                stream: _expensesStream(),
                builder: (context, snapshot) {
                  final expenses = snapshot.data ?? [];

                  final now = DateTime.now();

                  final monthlyExpenses = expenses.where((expense) {
                    final parts = expense.date.split('-');

                    if (parts.length != 3) return false;

                    final year = int.tryParse(parts[0]);
                    final month = int.tryParse(parts[1]);

                    if (year == null || month == null) return false;

                    return year == now.year && month == now.month;
                  }).toList();

                  final monthlyTotal = monthlyExpenses.fold<double>(
                    0,
                    (sum, expense) => sum + expense.amount,
                  );

                  return Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAF1DE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Color(0xFF235347),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This Month',
                          style: TextStyle(
                            color: Color(0xFF235347),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rs. ${monthlyTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFF235347),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${monthlyExpenses.length} transaction${monthlyExpenses.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Color(0xFF235347),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              StreamBuilder<List<Expense>>(
                stream: _expensesStream(),
                builder: (context, snapshot) {
                  final expenses = snapshot.data ?? [];
                  final categoryTotals = _getCategoryTotals(expenses);

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF235347),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.pie_chart_outline,
                              color: Color(0xFFDAF1DE),
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Category Breakdown',
                              style: TextStyle(
                                color: Color(0xFFDAF1DE),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (categoryTotals.isEmpty)
                          const Text(
                            'No expenses yet.',
                            style: TextStyle(color: Color(0xFFDAF1DE)),
                          )
                        else
                          ...categoryTotals.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      entry.key,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFFDAF1DE),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          minHeight: 8,
                                          value:
                                              entry.value /
                                              categoryTotals.values.reduce(
                                                (a, b) => a > b ? a : b,
                                              ),
                                          backgroundColor: const Color(
                                            0xFFDAF1DE,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Rs. ${entry.value.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFFDAF1DE),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
