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
          // Optional: Log message
          debugPrint(
              "App disabled remotely: ${data['message'] ?? 'No message'}");

          // Exit the app immediately
          exit(1);
        } else {
          setState(() => isActive = true);
        }
      } else {
        setState(() => isActive = true);
      }
    } catch (e) {
      // If network error occurs, allow app to run
      setState(() => isActive = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isActive == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return widget.child;
  }
}
