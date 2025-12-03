import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:final_project/models/todo_item.dart';

class UserStats extends StatefulWidget {
  final List<TodoItem> tasks;

  const UserStats({super.key, required this.tasks});

  @override
  _UserStatsState createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  String selectedYAxis = "Tasks Added";
  String selectedPeriod = "Week";

  Map<int, int> bucketTasks() {
    final now = DateTime.now();
    Map<int, int> bucket = {};

    for (var task in widget.tasks) {
      final created = task.id != null
          ? DateTime.fromMillisecondsSinceEpoch(task.id!)
          : now;
      final done = task.isDone;

      int key;

      switch (selectedPeriod) {
        case "Week":
          key = created.weekday - 1; // 0=Mon, ..., 6=Sun
          break;
        case "Month":
          key = created.day - 1; // 0-based
          break;
        case "Year":
          key = created.month - 1; // 0-based Jan=0
          break;
        case "Academic Year":
        // Shift months so Sept=0, Oct=1 ... Aug=11
          key = (created.month + 12 - 9) % 12;
          break;
        default:
          key = 0;
      }

      if (!bucket.containsKey(key)) bucket[key] = 0;

      if (selectedYAxis == "Tasks Added") {
        bucket[key] = bucket[key]! + 1;
      } else if (selectedYAxis == "Tasks Completed" && done) {
        bucket[key] = bucket[key]! + 1;
      }
    }

    return bucket;
  }

  List<String> getXAxisLabels() {
    switch (selectedPeriod) {
      case "Week":
        return ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
      case "Month":
        return List.generate(31, (i) => "${i+1}");
      case "Year":
        return ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
      case "Academic Year":
        return ["Sep","Oct","Nov","Dec","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug"];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = bucketTasks();
    final xLabels = getXAxisLabels();

    int maxY = (data.values.isEmpty ? 1 : data.values.reduce((a,b)=> a>b?a:b));

    return Scaffold(
      backgroundColor: const Color(0xFFBDBBB6),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Stats",
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'ComicNeue',
                color: Color(0xFF4F5A52),
              ),
            ),
            const SizedBox(height: 20),

            // ---------------- DROPDOWNS ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedYAxis,
                  items: ["Tasks Added", "Tasks Completed"]
                      .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedYAxis = value!);
                  },
                ),
                DropdownButton<String>(
                  value: selectedPeriod,
                  items: ["Week", "Month", "Year", "Academic Year"]
                      .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedPeriod = value!);
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ---------------- BAR CHART ----------------
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: maxY + 1.0,
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (selectedPeriod == "Month") {
                            if ((idx + 1) % 2 != 0) return const SizedBox.shrink();
                          }
                          if (idx >= 0 && idx < xLabels.length) {
                            return RotatedBox(
                              quarterTurns: selectedPeriod == "Month" ? 1 : 0,
                              child: Text(
                                xLabels[idx],
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1),
                    ),
                  ),
                  barGroups: List.generate(xLabels.length, (i) {
                    double y = data[i] != null ? data[i]!.toDouble() : 0;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: y,
                          color: const Color(0xFF73877B),
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- EXTRA STATS ----------------
            Text("⭐ Total Tasks: ${widget.tasks.length}",
                style: const TextStyle(fontSize: 18)),
            Text(
                "✔ Completed: ${widget.tasks.where((task) => task.isDone).length}",
                style: const TextStyle(fontSize: 18)),
            Text(
              "📅 Completion Rate: "
                  "${((widget.tasks.where((t) => t.isDone).length / (widget.tasks.isEmpty ? 1 : widget.tasks.length)) * 100).toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
