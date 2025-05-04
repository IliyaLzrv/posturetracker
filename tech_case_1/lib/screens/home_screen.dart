import 'package:flutter/material.dart';
import 'package:tech_case_1/screens/posture_report_screen.dart';
import 'package:tech_case_1/screens/settings_screen.dart';
import 'package:tech_case_1/services/posture_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String postureStatus = "Good Posture 😀";
  Color bgColor = Colors.green;

  @override
  void initState() {
    super.initState();
    PostureService().startTrackingPosture((status, color) {
      setState(() {
        postureStatus = status;
        bgColor = color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posture Monitor'), actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsScreen())),
        )
      ]),
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              postureStatus,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('View Posture Report'),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PostureReportScreen())),
            )
          ],
        ),
      ),
    );
  }
}