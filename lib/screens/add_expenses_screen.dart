import 'package:expense_tracker/services/expense_services.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class AddExpensesScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpensesScreen({super.key, this.expense});

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
  void initState() {
    super.initState();

    final expense = widget.expense;

    if (expense != null) {
      categoryController.text = expense.category;
      amountController.text = expense.amount.toString();
      dateController.text = expense.date;
      timeController.text = expense.time;
      noteController.text = expense.note;
    }
  }

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
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFDAF1DE),
                          hintText: 'Date',
                          hintStyle: TextStyle(color: Color(0xFF235347)),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            dateController.text =
                                '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                          }
                        },
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
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFDAF1DE),
                          hintText: 'Time',
                          hintStyle: TextStyle(color: Color(0xFF235347)),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            timeController.text = pickedTime.format(context);
                          }
                        },
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
                      id: widget.expense?.id ?? '',
                      category: categoryController.text.trim(),
                      amount: amount,
                      date: dateController.text.trim(),
                      time: timeController.text.trim(),
                      note: noteController.text.trim(),
                    );

                    if (widget.expense == null) {
                      await ExpenseService().addExpense(expense);
                    } else {
                      await ExpenseService().updateExpense(expense);
                    }

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Expense added successfully.'),
                      ),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add expense: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFFDAF1DE),
                  backgroundColor: Color(0xFF235347),
                ),
                child: Text(
                  widget.expense == null ? 'Add Expense' : 'Update Expense',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFFDAF1DE),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
