import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tech_case_1/services/posture_service.dart';

class PostureReportScreen extends StatefulWidget {
  @override
  _PostureReportScreenState createState() => _PostureReportScreenState();
}

class _PostureReportScreenState extends State<PostureReportScreen> {
  List<FlSpot> postureData = [];
  double postureScore = 0.0;
  final PostureAnalyticsService _analyticsService = PostureAnalyticsService();

  @override
  void initState() {
    super.initState();
    loadPostureData();
  }

  void loadPostureData() async {
    List<Map<String, dynamic>> logs = await _analyticsService.getPostureLogs();
    double score = await _analyticsService.calculatePostureScore();

    setState(() {
      postureScore = score;
      postureData = logs.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value['isGoodPosture'] ? 1 : 0);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posture Report')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Posture Score: ${postureScore.toStringAsFixed(1)}/10",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: postureData,
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
