import 'package:flutter/material.dart';

//TODO: agregar alguna animacion
SnackBar customSnackBar(BuildContext context, {required String message}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).colorScheme.primary,
    padding: const EdgeInsets.all(16),
    content: Text(message),
  );
}
