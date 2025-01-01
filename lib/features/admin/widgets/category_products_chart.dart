import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesData;

  const CategoryProductsChart({
    Key? key,
    required this.salesData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false), // Optional: Remove grid lines
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        barGroups: salesData.map((sales) {
          return BarChartGroupData(
            x: salesData.indexOf(sales), // Position of each bar
            barRods: [
              BarChartRodData(
                toY: sales.earning.toDouble(),
                color: Colors.blue, // Color of bars
                width: 20, // Width of each bar
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
