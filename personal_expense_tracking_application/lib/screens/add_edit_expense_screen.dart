import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../db/expense_db.dart';
import '../widgets/expense_form.dart';
import '../widgets/feedback_snackbar.dart';

class AddEditExpenseScreen extends StatelessWidget {
  final Expense? expense;
  final List<String> categories;

  const AddEditExpenseScreen({Key? key, this.expense, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpenseForm(
          initialExpense: expense,
          categories: categories,
          onSubmit: (exp) async {
            if (expense == null) {
              await ExpenseDB.instance.create(exp);
              showFeedback(context, 'Expense added!');
            } else {
              await ExpenseDB.instance.update(exp);
              showFeedback(context, 'Expense updated!');
            }
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
} 