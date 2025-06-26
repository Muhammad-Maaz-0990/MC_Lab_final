import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'category_dropdown.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? initialExpense;
  final void Function(Expense expense) onSubmit;
  final List<String> categories;

  const ExpenseForm({Key? key, this.initialExpense, required this.onSubmit, required this.categories}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late String _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _title = widget.initialExpense?.title ?? '';
    _amount = widget.initialExpense?.amount ?? 0.0;
    _category = widget.initialExpense?.category ?? widget.categories.first;
    _date = widget.initialExpense?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Enter a title' : null,
              onSaved: (value) => _title = value!,
              maxLength: 30,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            TextFormField(
              initialValue: _amount == 0.0 ? '' : _amount.toString(),
              decoration: InputDecoration(
                labelText: 'Amount (₨)',
                prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter an amount';
                final n = double.tryParse(value);
                if (n == null || n <= 0) return 'Enter a valid amount';
                return null;
              },
              onSaved: (value) => _amount = double.parse(value!),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            CategoryDropdown(
              value: _category,
              onChanged: (val) => setState(() => _category = val!),
              categories: widget.categories,
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.date_range, color: Colors.teal),
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat.yMMMd().format(_date)),
                    Icon(Icons.edit_calendar, size: 18, color: Colors.teal),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.save, color: Colors.white),
                label: Text(widget.initialExpense == null ? 'Add Expense' : 'Update Expense'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(Expense(
                      id: widget.initialExpense?.id,
                      title: _title,
                      amount: _amount,
                      category: _category,
                      date: _date,
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 