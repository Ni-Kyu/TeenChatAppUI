// lib/widgets/logout_text.dart
//
// Hoverable "Log out" text shown on the Profile screen.
// In the demo it shows an informational dialog because there is no real
// auth session to end. When auth is implemented, replace the dialog body
// with the actual sign-out call.

import 'package:flutter/material.dart';
import '../theme/frutiger_aero_theme.dart';

class LogOutText extends StatefulWidget {
  const LogOutText({super.key});

  @override
  State<LogOutText> createState() => _LogOutTextState();
}

class _LogOutTextState extends State<LogOutText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _showLogOutDialog,
        child: Text(
          'Log out',
          style: TextStyle(
            color: FrutigerAeroTheme.danger,
            fontSize: 14,
            decoration:
                _isHovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: FrutigerAeroTheme.danger,
          ),
        ),
      ),
    );
  }

  void _showLogOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Whoops!'),
        content: const Text(
          "You can't log out if you were never logged in, as this is just the demo!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
