import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PostureService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Timer? _reminderTimer;
  int reminderInterval = 30; // Default: 30 minutes

  void setReminderInterval(int minutes) {
    reminderInterval = minutes;
    _startReminderTimer();
  }

  void _startReminderTimer() {
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(Duration(minutes: reminderInterval), (timer) {
      _showNotification("Posture Check: Remember to sit up straight!");
    });
  }

  double sensitivity = 1.8;

  void setSensitivity(double newSensitivity) {
    sensitivity = newSensitivity;
  }

  void startTrackingPosture(Function(String, Color) callback) {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      final double tiltX = event.x;
      final bool isGoodPosture = !_isBadPosture(tiltX);

      logPostureData(isGoodPosture);

      if (!isGoodPosture) {
        callback("Bad Posture! ⚠️", Colors.red);
        _showNotification("You're leaning too far, sit up straight!");
      } else {
        callback("Good Posture 😀", Colors.green);
      }
    });
  }

  bool _isBadPosture(double tiltX) {
    return tiltX > sensitivity || tiltX < -sensitivity;
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'posture_channel',
      'Posture Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(0, 'Posture Alert', message, details);
  }

  Future<void> logPostureData(bool isGoodPosture) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> logs = prefs.getStringList('postureLogs') ?? [];

    Map<String, dynamic> logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'isGoodPosture': isGoodPosture,
    };

    logs.add(jsonEncode(logEntry));
    prefs.setStringList('postureLogs', logs);
  }

  Future<List<Map<String, dynamic>>> getPostureLogs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? logs = prefs.getStringList('postureLogs');
    if (logs == null) return [];
    return logs.map((log) => jsonDecode(log) as Map<String, dynamic>).toList();
  }

  Future<double> calculatePostureScore() async {
    List<Map<String, dynamic>> logs = await getPostureLogs();
    if (logs.isEmpty) return 0.0;

    int goodPostureCount = logs.where((log) => log['isGoodPosture'] as bool).length;
    return (goodPostureCount / logs.length) * 10;
  }
}

class PostureAnalyticsService {
  final PostureService _postureService = PostureService();

  Future<void> logPostureData(bool isGoodPosture) async {
    await _postureService.logPostureData(isGoodPosture);
  }

  Future<List<Map<String, dynamic>>> getPostureLogs() async {
    return await _postureService.getPostureLogs();
  }

  Future<double> calculatePostureScore() async {
    return await _postureService.calculatePostureScore();
  }
}


