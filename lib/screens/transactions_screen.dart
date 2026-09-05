import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

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
                            ListTile(title: Text('All'), onTap: () {}),
                            ListTile(title: Text('Today'), onTap: () {}),
                            ListTile(title: Text('This Week'), onTap: () {}),
                            ListTile(title: Text('This Month'), onTap: () {}),
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
                                          onTap: () => Navigator.pop(context),
                                        ),
                                        ListTile(
                                          title: const Text('Transport'),
                                          onTap: () => Navigator.pop(context),
                                        ),
                                        ListTile(
                                          title: const Text('Shopping'),
                                          onTap: () => Navigator.pop(context),
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
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with your actual transaction count
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFFDAF1DE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text('Transaction ${index + 1}'),
                      subtitle: Text('Details of transaction ${index + 1}'),
                      trailing: Text('\$${(index + 1) * 10}'),
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
