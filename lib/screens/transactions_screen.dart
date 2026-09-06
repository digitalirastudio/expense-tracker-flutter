import 'package:flutter/material.dart';

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
  final transactions = [
    {
      'icon': Icons.restaurant,
      'name': 'Food',
      'details': 'Restaurant',
      'amount': 'Rs. 500',
      'date': DateTime.now(),
    },
    {
      'icon': Icons.directions_bus,
      'name': 'Transport',
      'details': 'Bus',
      'amount': 'Rs. 200',
      'date': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'icon': Icons.shopping_bag,
      'name': 'Shopping',
      'details': 'Clothes',
      'amount': 'Rs. 1,200',
      'date': DateTime.now().subtract(Duration(days: 3)),
    },
    {
      'icon': Icons.receipt_long,
      'name': 'Bills',
      'details': 'Electricity',
      'amount': 'Rs. 800',
      'date': DateTime.now().subtract(Duration(days: 2)),
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                Container(
                  width: 300,
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
              child: ListView.builder(
                itemCount: transactions.where((transaction) {
                  final matchesSearch = transaction['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchtext.toLowerCase());

                  final transactionDate = transaction['date'] as DateTime;
                  final today = DateTime.now();

                  final matchesFilter =
                      selectedFilter == 'All' ||
                      (selectedFilter == 'Today' &&
                          transactionDate.year == today.year &&
                          transactionDate.month == today.month &&
                          transactionDate.day == today.day) ||
                      (selectedFilter == 'Yesterday' &&
                          transactionDate.year ==
                              today.subtract(Duration(days: 1)).year &&
                          transactionDate.month ==
                              today.subtract(Duration(days: 1)).month &&
                          transactionDate.day ==
                              today.subtract(Duration(days: 1)).day) ||
                      (selectedFilter == 'This Week' &&
                          transactionDate.isAfter(
                            today.subtract(Duration(days: 7)),
                          )) ||
                      (selectedFilter == 'This Month' &&
                          transactionDate.year == today.year &&
                          transactionDate.month == today.month);

                  return matchesSearch &&
                      matchesFilter &&
                      (selectedCategory.isEmpty ||
                          transaction['name'] == selectedCategory);
                }).length,
                itemBuilder: (context, index) {
                  final filteredTransactions = transactions.where((
                    transaction,
                  ) {
                    final matchesSearch = transaction['name']
                        .toString()
                        .toLowerCase()
                        .contains(searchtext.toLowerCase());

                    final transactionDate = transaction['date'] as DateTime;
                    final today = DateTime.now();

                    final matchesFilter =
                        selectedFilter == 'All' ||
                        (selectedFilter == 'Today' &&
                            transactionDate.year == today.year &&
                            transactionDate.month == today.month &&
                            transactionDate.day == today.day) ||
                        (selectedFilter == 'Yesterday' &&
                            transactionDate.year ==
                                today.subtract(Duration(days: 1)).year &&
                            transactionDate.month ==
                                today.subtract(Duration(days: 1)).month &&
                            transactionDate.day ==
                                today.subtract(Duration(days: 1)).day) ||
                        (selectedFilter == 'This Week' &&
                            transactionDate.isAfter(
                              today.subtract(Duration(days: 7)),
                            )) ||
                        (selectedFilter == 'This Month' &&
                            transactionDate.year == today.year &&
                            transactionDate.month == today.month);

                    return matchesSearch &&
                        matchesFilter &&
                        (selectedCategory.isEmpty ||
                            transaction['name'] == selectedCategory);
                  }).toList();
                  final transaction = filteredTransactions[index];

                  return Card(
                    color: const Color(0xFFDAF1DE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        transaction['icon'] as IconData,
                        color: const Color(0xFF235347),
                      ),
                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: transaction['name'] as String,
                              style: TextStyle(
                                backgroundColor:
                                    searchtext.isNotEmpty &&
                                        (transaction['name'] as String)
                                            .toLowerCase()
                                            .contains(searchtext.toLowerCase())
                                    ? Color(0xFF235347)
                                    : Colors.transparent,
                                color:
                                    searchtext.isNotEmpty &&
                                        (transaction['name'] as String)
                                            .toLowerCase()
                                            .contains(searchtext.toLowerCase())
                                    ? Color(0xFFDAF1DE)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(transaction['details'] as String),
                      trailing: Text(
                        transaction['amount'] as String,
                        style: const TextStyle(
                          color: Color(0xFF235347),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
