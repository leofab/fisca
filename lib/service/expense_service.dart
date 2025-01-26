import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/expense.dart';

class ExpenseService {
  final CollectionReference _expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(Expense expense) async {
    await _expenseCollection.add(expense.toMap());
  }
}
