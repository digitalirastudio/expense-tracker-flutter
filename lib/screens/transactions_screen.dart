import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/expense.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  TextEditingController searchController = TextEditingController();
  String searchtext = '';
  String selectedFilter = 'All';
  String selectedCategory = '';
  final DatabaseReference _expensesRef =
      FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
          )
          .ref()
          .child('users')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('expenses');
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteExpense(String expenseId) async {
    try {
      await _expensesRef.child(expenseId).remove();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete expense: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF235347),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchtext = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Color(0xFFDAF1DE),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Color(0xFF235347)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text('All'),
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'All';
                                  selectedCategory = '';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Today'),
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Today';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Yesterday'),
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Yesterday';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('This Week'),
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'This Week';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('This Month'),
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'This Month';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Category'),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      children: [
                                        const Text('Select Category'),
                                        ListTile(
                                          title: const Text('Food'),
                                          onTap: () {
                                            setState(() {
                                              selectedCategory = 'Food';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('Transport'),
                                          onTap: () {
                                            setState(() {
                                              selectedCategory = 'Transport';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('Shopping'),
                                          onTap: () {
                                            setState(() {
                                              selectedCategory = 'Shopping';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('Bills'),
                                          onTap: () {
                                            setState(() {
                                              selectedCategory = 'Bills';
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.filter_list),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDAF1DE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                selectedCategory.isNotEmpty
                    ? 'Category: $selectedCategory'
                    : 'Filter: $selectedFilter',
                style: const TextStyle(
                  color: Color(0xFF235347),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _expensesRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load transactions.'),
                    );
                  }

                  final data = snapshot.data?.snapshot.value;

                  if (data == null) {
                    return const Center(child: Text('No expenses yet.'));
                  }

                  final Map<dynamic, dynamic> expensesMap =
                      data as Map<dynamic, dynamic>;

                  final expenses = expensesMap.entries.map((entry) {
                    return Expense.fromMap(
                      entry.key.toString(),
                      Map<dynamic, dynamic>.from(entry.value),
                    );
                  }).toList();

                  final filteredExpenses = expenses.where((expense) {
                    final matchesSearch = expense.category
                        .toLowerCase()
                        .contains(searchtext.toLowerCase());

                    final transactionDate = DateTime.tryParse(expense.date);
                    final today = DateTime.now();

                    if (transactionDate == null) {
                      return matchesSearch &&
                          (selectedCategory.isEmpty ||
                              expense.category.toLowerCase() ==
                                  selectedCategory.toLowerCase());
                    }

                    final matchesFilter =
                        selectedFilter == 'All' ||
                        (selectedFilter == 'Today' &&
                            transactionDate.year == today.year &&
                            transactionDate.month == today.month &&
                            transactionDate.day == today.day) ||
                        (selectedFilter == 'Yesterday' &&
                            transactionDate.year ==
                                today.subtract(const Duration(days: 1)).year &&
                            transactionDate.month ==
                                today.subtract(const Duration(days: 1)).month &&
                            transactionDate.day ==
                                today.subtract(const Duration(days: 1)).day) ||
                        (selectedFilter == 'This Week' &&
                            transactionDate.isAfter(
                              today.subtract(const Duration(days: 7)),
                            )) ||
                        (selectedFilter == 'This Month' &&
                            transactionDate.year == today.year &&
                            transactionDate.month == today.month);

                    return matchesSearch &&
                        matchesFilter &&
                        (selectedCategory.isEmpty ||
                            expense.category.toLowerCase() ==
                                selectedCategory.toLowerCase());
                  }).toList();

                  if (filteredExpenses.isEmpty) {
                    return const Center(child: Text('No matching expenses.'));
                  }

                  return ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];

                      return Card(
                        color: const Color(0xFFDAF1DE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.receipt_long,
                            color: Color(0xFF235347),
                          ),
                          title: Text(expense.category),
                          subtitle: Text(
                            '${expense.date} • ${expense.time}\n${expense.note}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rs. ${expense.amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Color(0xFF235347),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddExpensesScreen(expense: expense),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    await _deleteExpense(expense.id);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
