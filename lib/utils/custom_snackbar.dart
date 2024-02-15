import 'package:flutter/material.dart';

SnackBar customSnackBar(String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.black87,
    padding: const EdgeInsets.all(16),
    content: Text(message,),
  );
}
