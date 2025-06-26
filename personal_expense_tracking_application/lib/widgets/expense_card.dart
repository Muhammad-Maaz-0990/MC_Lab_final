import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool highlight;

  const ExpenseCard({Key? key, required this.expense, this.onTap, this.onDelete, this.highlight = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: highlight ? Colors.red[100] : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _categoryColor(expense.category),
          child: Icon(_categoryIcon(expense.category), color: Colors.white),
        ),
        title: Text(
          expense.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(DateFormat.yMMMd().format(expense.date)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₨${expense.amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: highlight ? Colors.red : Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.grey[600]),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Transport':
        return Icons.directions_car;
      case 'Entertainment':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Entertainment':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
} 