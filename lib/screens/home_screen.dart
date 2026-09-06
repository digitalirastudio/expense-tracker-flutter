import 'package:expense_tracker/screens/add_expenses_screen.dart';
import 'package:expense_tracker/screens/transactions_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const Text(
              'Kiran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
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
                      children: const [Text('Welcome back 👋'), Text('Kiran')],
                    ),
                  ],
                ),

                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF235347),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(color: Color(0xFFDAF1DE)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$ 1,200.00',
                    style: TextStyle(
                      color: Color(0xFFDAF1DE),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Income: \$ 2,000.00 | Expenses: \$ 800.00',
                    style: TextStyle(color: Color(0xFFDAF1DE)),
                  ),
                  SizedBox(height: 8),
                ],
              ),
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
            Column(
              children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: const Color(0xFF235347),
                  leading: const Icon(
                    Icons.food_bank_outlined,
                    color: Color(0xFFDAF1DE),
                  ),
                  title: const Text(
                    'Food',
                    style: TextStyle(color: Color(0xFFDAF1DE)),
                  ),
                  subtitle: const Text(
                    'Today, 10:00 AM',
                    style: TextStyle(color: Color(0xFFDAF1DE)),
                  ),
                  trailing: const Text(
                    '- \$50.00',
                    style: TextStyle(color: Color(0xFFDAF1DE)),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: const Color(0xFF235347),
                    leading: const Icon(
                      Icons.directions_car,
                      color: Color(0xFFDAF1DE),
                    ),
                    title: const Text(
                      'Transport',
                      style: TextStyle(color: Color(0xFFDAF1DE)),
                    ),
                    subtitle: const Text(
                      'Yesterday, 7:30 PM',
                      style: TextStyle(color: Color(0xFFDAF1DE)),
                    ),
                    trailing: const Text(
                      '- \$30.00',
                      style: TextStyle(color: Color(0xFFDAF1DE)),
                    ),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: const Color(0xFF235347),
                    leading: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFFDAF1DE),
                    ),
                    title: const Text(
                      'Shopping',
                      style: TextStyle(color: Color(0xFFDAF1DE)),
                    ),
                    subtitle: const Text(
                      'Yesterday, 5:00 PM',
                      style: TextStyle(color: Color(0xFFDAF1DE)),
                    ),
                    trailing: const Text(
                      '+ \$2,000.00',
                      style: TextStyle(color: Color(0xFFDAF1DE)),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
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
