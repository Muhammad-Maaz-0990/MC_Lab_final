import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final List<String> categories;

  const CategoryDropdown({Key? key, required this.value, required this.onChanged, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: categories.map((cat) => DropdownMenuItem(
        value: cat,
        child: Text(cat),
      )).toList(),
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
    );
  }
} 