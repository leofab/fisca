import 'package:app/models/expense.dart';

class ExpensesMockData {
  static List<Expense> getMockExpenses() {
    return [
      Expense(
        id: '1',
        title: 'Food',
        amount: 150.0,
        date: DateTime(2023, 10, 1),
      ),
      Expense(
        id: '2',
        title: 'Transport',
        amount: 50.0,
        date: DateTime(2023, 10, 2),
      ),
      Expense(
        id: '3',
        title: 'Entertainment',
        amount: 75.0,
        date: DateTime(2023, 10, 3),
      ),
      Expense(
        id: '4',
        title: 'Shopping',
        amount: 200.0,
        date: DateTime(2023, 10, 4),
      ),
      Expense(
        id: '5',
        title: 'Utilities',
        amount: 100.0,
        date: DateTime(2023, 10, 5),
      ),
      Expense(
        id: '6',
        title: 'Health',
        amount: 60.0,
        date: DateTime(2023, 10, 6),
      ),
      Expense(
        id: '7',
        title: 'Travel',
        amount: 300.0,
        date: DateTime(2023, 10, 7),
      ),
    ];
  }
}
