import 'dart:async';
import 'package:agrotech_app/api.dart'; // Ensure your ApiService is properly imported
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnimatedChartsPage extends StatefulWidget {
  @override
  _AnimatedChartsPageState createState() => _AnimatedChartsPageState();
}

class _AnimatedChartsPageState extends State<AnimatedChartsPage> {
  ApiService apiService = ApiService(); // Instance of your ApiService class
  List<dynamic> expenses = [];
  Timer? _timer;
  bool isRadarChart = true;
  bool isLineChart = false;
  bool isPieChart = false;
  bool isScatterChart = false;

  @override
  void initState() {
    super.initState();
    _fetchExpenses(); // Fetch expenses on page load
    _startChartAnimation(); // Start chart animation
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchExpenses() async {
    try {
      List<dynamic> fetchedExpenses = await apiService.fetchExpenses();
      setState(() {
        expenses = fetchedExpenses;
      });
    } catch (e) {
      print("Error fetching expenses: $e");
    }
  }

  void _startChartAnimation() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        isRadarChart = !isRadarChart;
        if (!isRadarChart) {
          isLineChart = !isLineChart;
          if (!isLineChart) {
            isPieChart = !isPieChart;
            if (!isPieChart) {
              isScatterChart = !isScatterChart;
            }
          }
        }
      });
    });
  }

  List<FlSpot> _generateLineSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < expenses.length; i++) {
      double amount = double.parse(expenses[i]['amount'].toString());
      spots.add(FlSpot(i.toDouble(), amount));
    }
    return spots;
  }

  List<PieChartSectionData> _generatePieSections() {
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      String category = expense['category'];
      double amount = double.parse(expense['amount'].toString());
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      } else {
        categoryTotals[category] = amount;
      }
    }
    return categoryTotals.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        color: Colors.primaries[
            categoryTotals.keys.toList().indexOf(entry.key) %
                Colors.primaries.length],
        title: '${entry.key}: ${entry.value.toStringAsFixed(2)}',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  List<RadarEntry> _generateRadarEntries() {
    return expenses.asMap().entries.map((e) {
      return RadarEntry(value: double.parse(e.value['amount'].toString()));
    }).toList();
  }

  List<ScatterSpot> _generateScatterSpots() {
    List<ScatterSpot> spots = [];
    for (int i = 0; i < expenses.length; i++) {
      double amount = double.parse(expenses[i]['amount'].toString());
      spots.add(ScatterSpot(i.toDouble(), amount));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: height * 0.5,
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDarkMode ? Colors.black : Colors.black,
            ),
            child: expenses.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: isRadarChart && _generateRadarEntries().length >= 3
                          ? RadarChart(
                              key: ValueKey('RadarChart'),
                              RadarChartData(
                                radarShape: RadarShape.polygon,
                                dataSets: [
                                  RadarDataSet(
                                    fillColor: Colors.blue.withOpacity(0.2),
                                    borderColor: Colors.blue,
                                    borderWidth: 2,
                                    dataEntries: _generateRadarEntries(),
                                  ),
                                ],
                                radarBorderData: BorderSide.none,
                                titleTextStyle: TextStyle(fontSize: 14),
                                radarBackgroundColor:
                                    Colors.white.withOpacity(0.1),
                                tickCount: 5,
                                ticksTextStyle: TextStyle(fontSize: 10),
                              ),
                            )
                          : isLineChart
                              ? LineChart(
                                  key: ValueKey('LineChart'),
                                  LineChartData(
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: _generateLineSpots(),
                                        isCurved: true,
                                        color: Colors.blue,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.blue.withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: true),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: true),
                                      ),
                                    ),
                                    gridData: FlGridData(show: false),
                                  ),
                                )
                              : isPieChart
                                  ? PieChart(
                                      key: ValueKey('PieChart'),
                                      PieChartData(
                                        sections: _generatePieSections(),
                                        borderData: FlBorderData(show: false),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 50,
                                      ),
                                    )
                                  : ScatterChart(
                                      key: ValueKey('ScatterChart'),
                                      ScatterChartData(
                                        scatterSpots: _generateScatterSpots(),
                                        borderData: FlBorderData(show: false),
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: true),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: true),
                                          ),
                                        ),
                                      ),
                                    ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
