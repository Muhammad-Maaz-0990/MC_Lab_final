import 'package:flutter/material.dart';
import '../db/expense_db.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/pie_chart.dart';
import '../widgets/feedback_snackbar.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  final void Function()? onAddExpense;
  final void Function(Expense expense)? onEditExpense;
  final void Function()? onSearch;

  const DashboardScreen({Key? key, this.onAddExpense, this.onEditExpense, this.onSearch}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Expense> _expenses = [];
  double _monthlyTotal = 0.0;
  Map<String, double> _categoryTotals = {};
  Expense? _recentlyDeleted;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final expenses = await ExpenseDB.instance.readAll();
    expenses.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    final now = DateTime.now();
    final thisMonth = expenses.where((e) => e.date.year == now.year && e.date.month == now.month).toList();
    final monthlyTotal = thisMonth.fold(0.0, (sum, e) => sum + e.amount);
    final Map<String, double> categoryTotals = {};
    for (var e in thisMonth) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }
    setState(() {
      _expenses = expenses;
      _monthlyTotal = monthlyTotal;
      _categoryTotals = categoryTotals;
    });
  }

  void _deleteExpense(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await ExpenseDB.instance.delete(expense.id!);
      setState(() {
        _recentlyDeleted = expense;
      });
      _loadExpenses();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await ExpenseDB.instance.create(_recentlyDeleted!);
              _loadExpenses();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recent = _expenses.take(5).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: widget.onSearch,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadExpenses,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              color: Colors.teal[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total This Month', style: TextStyle(fontSize: 16, color: Colors.teal[900])),
                    SizedBox(height: 8),
                    Text('₨${_monthlyTotal.toStringAsFixed(0)}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700])),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_categoryTotals.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('By Category', style: TextStyle(fontSize: 16, color: Colors.teal[900])),
                      SizedBox(height: 8),
                      SizedBox(height: 120, child: ExpensePieChart(dataMap: _categoryTotals)),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16),
            Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800])),
            SizedBox(height: 8),
            ...recent.map((e) => ExpenseCard(
              expense: e,
              onTap: () => widget.onEditExpense?.call(e),
              onDelete: () => _deleteExpense(e),
              highlight: e.amount > 2000,
            )),
            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No transactions yet.'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Add Expense'),
        backgroundColor: Colors.teal,
        onPressed: widget.onAddExpense,
      ),
    );
  }
} 