import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:app/models/expense.dart';
import 'package:app/service/db_service.dart' as db;
import 'package:logger/logger.dart';

class LineChartViewModel extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;
  bool? _hasData;
  bool get hasData => _hasData!;

  Future<void> fetchFromDB() async {
    try {
      _expenses = await db.DBService().fetchFromDB();
      notifyListeners();
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  List<FlSpot> getFlSpots() {
    try {
      if (expenses.isEmpty) return [];
      List<FlSpot> spots = [];
      double value = 0;
      for (int i = 0; i < expenses.length; i++) {
        value += expenses[i].amount;
        spots.add(FlSpot(expenses[i].date.day.toDouble(), value));
      }
      notifyListeners();
      return spots;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }
}
