import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StartupCheck extends StatefulWidget {
  final Widget child;
  const StartupCheck({required this.child, super.key});

  @override
  State<StartupCheck> createState() => _StartupCheckState();
}

class _StartupCheckState extends State<StartupCheck> {
  bool? isActive;
  String message = "Checking app status...";

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://yami2010.github.io/flutter-app-control/app_status.json',
        ),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['active'] == false) {
          message = data['message'] ?? "🚫 This app has been disabled remotely.";

          // Option A: exit the app
          // exit(1);

          // Option B: block the app with a message screen
          setState(() => isActive = false);
          return;
        } else {
          setState(() => isActive = true);
        }
      } else {
        message = "⚠️ Failed to check app status. Server returned ${res.statusCode}.";
        setState(() => isActive = false); // Block app if cannot verify status
      }
    } catch (e) {
      message = "❌ Error: Could not connect to server.\nMake sure you're online.";
      setState(() => isActive = false); // Block app if network fails
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isActive == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isActive == false) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
