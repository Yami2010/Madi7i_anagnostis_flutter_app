import 'dart:convert';
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
            'https://yami2010.github.io/flutter-app-control/app_status.json'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['active'] == false) {
          setState(() {
            isActive = false;
            message = data['message'] ?? "App has been disabled remotely.";
          });
        } else {
          setState(() => isActive = true);
        }
      } else {
        // If JSON is unreachable, fallback to active
        setState(() {
          isActive = true;
        });
      }
    } catch (e) {
      // On network error (offline, server down, etc.)
      setState(() {
        isActive = true;
        // You could also make this false to block access without connection
      });
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
                fontSize: 20,
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
