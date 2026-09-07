import 'package:expense_tracker/services/expense_services.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF235347),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFDAF1DE),
                  hintText: 'Category',
                  hintStyle: TextStyle(color: Color(0xFF235347)),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF235347),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFDAF1DE),
                  hintText: 'Amount',
                  hintStyle: TextStyle(color: Color(0xFF235347)),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 16),
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
                      controller: dateController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDAF1DE),
                        hintText: 'Date',
                        hintStyle: TextStyle(color: Color(0xFF235347)),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF235347),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: timeController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDAF1DE),
                        hintText: 'Time',
                        hintStyle: TextStyle(color: Color(0xFF235347)),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF235347),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFDAF1DE),
                  hintText: 'Note (Optional)',
                  hintStyle: TextStyle(color: Color(0xFF235347)),
                  border: OutlineInputBorder(),
                ),
                controller: noteController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text.trim());

                if (categoryController.text.trim().isEmpty ||
                    amount == null ||
                    dateController.text.trim().isEmpty ||
                    timeController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields.'),
                    ),
                  );
                  return;
                }

                try {
                  final expense = Expense(
                    id: '',
                    category: categoryController.text.trim(),
                    amount: amount,
                    date: dateController.text.trim(),
                    time: timeController.text.trim(),
                    note: noteController.text.trim(),
                  );

                  await ExpenseService().addExpense(expense);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Expense added successfully.'),
                    ),
                  );

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add expense: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFDAF1DE),
                backgroundColor: Color(0xFF235347),
              ),
              child: const Text(
                'Add Expense',
                style: TextStyle(fontSize: 18, color: Color(0xFFDAF1DE)),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
