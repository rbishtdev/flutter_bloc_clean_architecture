import 'package:flutter/material.dart';

extension SnackBarX on BuildContext {
  void showSnack(
      String message, {
        Color color = Colors.black,
      }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSuccess(String message) =>
      showSnack(message, color: Colors.green);

  void showError(String message) =>
      showSnack(message, color: Colors.red);
}
