import 'package:app/screens/auth/auth_provider.dart';
import 'package:app/screens/charts/line_chart.dart' as line_chart;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/expense.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/mock/expenses_mock_data.dart';

class OverviewScreen extends StatelessWidget {
  final List<Expense> expenses = ExpensesMockData.getMockExpenses();
  OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;
    final yoloExtractedViewModel = Provider.of<YoloExtractedViewModel>(context);

    return Scaffold(
      appBar: AppBar(
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
              line_chart.LineChartSample1(),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await yoloExtractedViewModel.takePhoto();
          if (yoloExtractedViewModel.capturedImage != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image captured!')),
            );
            Navigator.pushNamedAndRemoveUntil(context, '/yolo', (_) => true);
          }
        },
        foregroundColor: Colors.deepPurple.shade800,
        elevation: 12,
        hoverElevation: 24,
        splashColor: Colors.deepPurple.shade200,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
