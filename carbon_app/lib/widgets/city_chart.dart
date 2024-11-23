import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class CityChart extends StatefulWidget {
  final String city;

  const CityChart({required this.city, super.key});

  @override
  State<CityChart> createState() => _CityChartState();
}

class _CityChartState extends State<CityChart> {
  List<BarChartGroupData> barGroups = [];
  List<FlSpot> trendLine = [];
  List<int> years = [];
  List<double> totalEmissions = [];
  Map<String, List<double>> departmentData = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    // Load datasets
    final totalEmissionData =
        await rootBundle.loadString('assets/data/TotalCarbonEmissions_AllSectors_10ktonCO2e.csv');
    final residentialData =
        await rootBundle.loadString('assets/data/ResidentialSector_CarbonEmissions_10ktonCO2e.csv');
    final servicesData =
        await rootBundle.loadString('assets/data/ServiceIndustry_CarbonEmissions_10ktonCO2e.csv');
    final energyData = 
        await rootBundle.loadString('assets/data/EnergySector_CarbonEmissions_10ktonCO2e.csv');
    final manufacturingData =
        await rootBundle.loadString('assets/data/ManufacturingAndConstruction_CarbonEmissions_10ktonCO2e.csv');
    final transportationData =
        await rootBundle.loadString('assets/data/TransportationSector_CarbonEmissions_10ktonCO2e.csv');
    final electricityData =
        await rootBundle.loadString('assets/data/Electricity_CarbonEmissions_10ktonCO2e.csv');

    // Parse CSV data
    final cityIndex = _getCityIndex(widget.city);
    final allDepartments = {
      "Residential": residentialData,
      "Services": servicesData,
      "Energy": energyData,
      "Manufacturing": manufacturingData,
      "Transportation": transportationData,
      "Electricity": electricityData,
    };

    final yearRange = List<int>.generate(2024 - 1990, (i) => 1990 + i);

    departmentData = {};
    for (final department in allDepartments.keys) {
      departmentData[department] = List<double>.filled(yearRange.length, 0);
      final rows = const LineSplitter().convert(allDepartments[department]!);
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i].split(',');
        final year = int.parse(row[0]);
        final value = double.parse(row[cityIndex]); // City column
        if (year >= 1990 && year <= 2023) {
          departmentData[department]![year - 1990] += value;
        }
      }
    }

    // Total emissions and trend line
    years = yearRange;
    totalEmissions = List<double>.filled(yearRange.length, 0);
    for (var i = 0; i < yearRange.length; i++) {
      for (final department in departmentData.keys) {
        totalEmissions[i] += departmentData[department]![i];
      }
    }

    // Generate BarChartGroupData
    barGroups = years.map((year) {
      final index = year - 1990;
      double stackBottom = 0;
      final rods = departmentData.keys.map((department) {
        final value = departmentData[department]![index];
        final rod = BarChartRodData(toY: value + stackBottom, color: _getColorForDepartment(department));
        stackBottom += value;
        return rod;
      }).toList();
      return BarChartGroupData(x: year, barRods: rods);
    }).toList();

    // Generate trend line
    trendLine = List.generate(
      years.length,
      (index) => FlSpot(years[index].toDouble(), totalEmissions[index]),
    );

    setState(() {});
  }

  int _getCityIndex(String city) {
    final cities = [
      "南投縣", "台中市", "台北市", "台南市", "台東縣", "嘉義市", "嘉義縣", "基隆市",
      "宜蘭縣", "屏東縣", "彰化縣", "新北市", "新竹市", "新竹縣", "桃園市",
      "澎湖縣", "花蓮縣", "苗栗縣", "連江縣", "金門縣", "雲林縣", "高雄市"
    ];
    return cities.indexOf(city) + 3; // City columns start at index 3
  }

  Color _getColorForDepartment(String department) {
    switch (department) {
      case "Residential":
        return Colors.orange;
      case "Services":
        return Colors.blue;
      case "Energy":
        return Colors.green;
      case "Manufacturing":
        return Colors.purple;
      case "Transportation":
        return Colors.red;
      case "Electricity":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: barGroups.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text(value.toInt().toString()),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    extraLinesOnTop: true,
                    horizontalLines: trendLine
                        .map((spot) => HorizontalLine(
                              y: spot.y,
                              color: Colors.black,
                              strokeWidth: 2,
                            ))
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
