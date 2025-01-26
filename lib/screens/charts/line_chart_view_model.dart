import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:app/models/expense.dart';
import 'package:app/mock/expenses_mock_data.dart';

class LineChartViewModel extends ChangeNotifier {
  List<Expense> expenses = ExpensesMockData.getMockExpenses();

  List<FlSpot> getFlSpots() {
    List<FlSpot> spots = [];
    double value = 0;
    for (int i = 0; i < expenses.length; i++) {
      value += expenses[i].amount;
      spots.add(FlSpot(expenses[i].date.day.toDouble(), value));
    }
    notifyListeners();
    return spots;
  }
}
