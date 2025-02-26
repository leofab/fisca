import 'dart:io' as io;
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:app/models/expense.dart';

class DBService {
  Future<void> initializeDB() async {
    final io.Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, 'expenses.db');
    await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY, title TEXT, amount REAL, date TEXT)');
    });
  }

  Future<void> insertExpense(Map<String, dynamic> expense) async {
    try {
      final io.Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDirectory.path, 'expenses.db');
      final db = await databaseFactory.openDatabase(dbPath);
      await db.insert('expenses', expense,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  Future<List<Expense>> fetchFromDB() async {
    try {
      final io.Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      final String dbPath = path.join(documentsDirectory.path, 'expenses.db');
      final db = await databaseFactory.openDatabase(dbPath);
      final List<Map<String, dynamic>> expenses = await db.query('expenses');
      return List.generate(expenses.length, (i) {
        return Expense(
          id: expenses[i]['id'].toString(),
          title: expenses[i]['title'].toString(),
          amount: expenses[i]['amount'].toDouble(),
          date: DateTime.parse(expenses[i]['date']),
        );
      });
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }
}
