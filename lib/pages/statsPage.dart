import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/todo_item.dart';

class StatsPage extends StatefulWidget {
  final List<TodoItem> todos;

  const StatsPage({super.key, required this.todos});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String _yAxis = "Items Completed";
  String _xAxis = "Week";

  final List<String> yOptions = ["Items Completed", "Items Added"];
  final List<String> xOptions = ["Week", "Month", "Year", "Academic Year"];

  List<FlSpot> _generateData() {
    // Example: simple dummy for week (7 points)
    List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      double val = (_yAxis == "Items Completed")
          ? widget.todos.where((t) => t.isDone).length * (i + 1) / 7
          : widget.todos.length * (i + 1) / 7;
      spots.add(FlSpot(i.toDouble(), val));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final data = _generateData();

    return Scaffold(
      appBar: AppBar(title: const Text("Stats"), backgroundColor: const Color(0xFF73877B)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _yAxis,
                  items: yOptions.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                  onChanged: (v) => setState(() => _yAxis = v!),
                ),
                DropdownButton<String>(
                  value: _xAxis,
                  items: xOptions.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
                  onChanged: (v) => setState(() => _xAxis = v!),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: data.length.toDouble() - 1,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      color: const Color(0xFF73877B),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  ),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
