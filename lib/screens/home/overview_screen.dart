import 'package:app/screens/auth/auth_provider.dart';
import 'package:app/screens/charts/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/expense.dart';
import 'package:app/mock/expenses_mock_data.dart';

class OverviewScreen extends StatelessWidget {
  final List<Expense> expenses = ExpensesMockData.getMockExpenses();
  OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              }
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${userData?['name']}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              LineChartWidget(),
            ],
          )),
    );
  }
}
