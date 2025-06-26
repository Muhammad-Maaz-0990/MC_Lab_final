import 'package:flutter/material.dart';
import 'models/expense.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_edit_expense_screen.dart';
import 'screens/search_filter_screen.dart';
import 'db/expense_db.dart';
import 'widgets/feedback_snackbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({Key? key}) : super(key: key);

  static const List<String> categories = ['Food', 'Transport', 'Entertainment', 'Other'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Expense? _editingExpense;
  bool _showSearch = false;

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (_showSearch) {
      return SearchFilterScreen(
        categories: ExpenseApp.categories,
      );
    }
    return DashboardScreen(
      onAddExpense: () async {
        final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AddEditExpenseScreen(categories: ExpenseApp.categories),
        ));
        if (result == true) _refresh();
      },
      onEditExpense: (expense) async {
        final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AddEditExpenseScreen(expense: expense, categories: ExpenseApp.categories),
        ));
        if (result == true) _refresh();
      },
      onSearch: () => setState(() => _showSearch = true),
    );
  }
}
