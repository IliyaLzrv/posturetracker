import 'package:flutter/material.dart';

import '../services/posture_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PostureService _postureService = PostureService();
  int selectedInterval = 30; // Default 30 minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          ListTile(
            title: Text("Set Reminder Interval"),
            trailing: DropdownButton<int>(
              value: selectedInterval,
              items: [15, 30, 45, 60].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value minutes"),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedInterval = value;
                    _postureService.setReminderInterval(value);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
