import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> dataMap;
  const ExpensePieChart({Key? key, required this.dataMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections = dataMap.entries.map((entry) {
      final color = _categoryColor(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '₨${entry.value.toStringAsFixed(0)}',
        radius: 45,
        titleStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 30,
        sectionsSpace: 2,
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orangeAccent;
      case 'Transport':
        return Colors.blueAccent;
      case 'Entertainment':
        return Colors.purpleAccent;
      default:
        return Colors.teal;
    }
  }
} 