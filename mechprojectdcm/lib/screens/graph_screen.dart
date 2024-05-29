import 'dart:async';

//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mechprojectdcm/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';

double maxTorque = 0.8, maxRPM = 5000;

class GraphsScreen extends StatefulWidget {
  const GraphsScreen({
    super.key,
  });

  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  double timeInterval = 10;
  double newTime = 10;
  var selectedRange = const RangeValues(10, 120);
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();
    //getMax();

    // defines a timer
    _everySecond = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      setState(() {
        //getMax();
      });
    });
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        children: [
          const Gap(40),
          Text("Data Graphs\n& Statistics",
              style: Styles.headlineStyle1.copyWith(fontSize: 35)),
          const Gap(40),
          Text(
            "All Graphs",
            style: Styles.headlineStyle2,
          ),
          const Gap(15),
          // FREEZES APP??
          // LineChart(LineChartData(
          //     minX: 0,
          //     maxX: maxTorque,
          //     minY: 0,
          //     maxY: maxRPM,
          //     lineBarsData: [
          //       LineChartBarData(spots: [
          //         FlSpot(0, 3),
          //         FlSpot(4, 2),
          //       ], color: Colors.blue, barWidth: 6, isCurved: true),
          //     ],
          //     titlesData: const FlTitlesData(
          //         topTitles:
          //             AxisTitles(sideTitles: SideTitles(showTitles: false)),
          //         rightTitles:
          //             AxisTitles(sideTitles: SideTitles(showTitles: false)),
          //         leftTitles: AxisTitles(
          //             axisNameWidget: Text("RPM"),
          //             sideTitles: SideTitles(showTitles: true))))),
        ],
      ),
    );
  }
}

Future getMax() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  maxTorque = prefs.getDouble('maxTorque')!;
  maxRPM = prefs.getDouble('maxRPM')!;
  maxCurrent = prefs.getDouble('maxCurrent')!;
  maxPower = prefs.getDouble('maxPower')!;
  maxEff = prefs.getDouble('maxEff')!;
}
