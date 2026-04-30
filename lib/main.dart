// lib/main.dart
//
// Application entry point. Intentionally minimal — all structure lives in
// the files imported below. See lib/README.md for a project map.

import 'package:flutter/material.dart';
import 'theme/frutiger_aero_theme.dart';
import 'state/main_navigation.dart';

void main() {
  runApp(const TeenChatApp());
}

class TeenChatApp extends StatelessWidget {
  const TeenChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeenChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FrutigerAeroTheme.oceanBlue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Segoe UI',
      ),
      home: const MainNavigation(),
    );
  }
}
