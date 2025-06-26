import 'package:flutter/material.dart';
import '../db/expense_db.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/category_dropdown.dart';
import 'package:intl/intl.dart';

class SearchFilterScreen extends StatefulWidget {
  final List<String> categories;
  const SearchFilterScreen({Key? key, required this.categories}) : super(key: key);

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Expense> _results = [];

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    final all = await ExpenseDB.instance.readAll();
    List<Expense> filtered = all;
    if (_selectedCategory != null) {
      filtered = filtered.where((e) => e.category == _selectedCategory).toList();
    }
    if (_startDate != null) {
      filtered = filtered.where((e) => !e.date.isBefore(_startDate!)).toList();
    }
    if (_endDate != null) {
      filtered = filtered.where((e) => !e.date.isAfter(_endDate!)).toList();
    }
    filtered.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    setState(() {
      _results = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search & Filter'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CategoryDropdown(
                    value: _selectedCategory ?? widget.categories.first,
                    onChanged: (val) => setState(() {
                      _selectedCategory = val == widget.categories.first ? null : val;
                      _search();
                    }),
                    categories: [widget.categories.first, ...widget.categories],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() { _startDate = picked; _search(); });
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_startDate == null ? 'Any' : DateFormat.yMMMd().format(_startDate!)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() { _endDate = picked; _search(); });
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_endDate == null ? 'Any' : DateFormat.yMMMd().format(_endDate!)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: _results.isEmpty
                  ? Center(child: Text('No results'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, i) => ExpenseCard(
                        expense: _results[i],
                        highlight: _results[i].amount > 2000,
                        onTap: () {},
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 