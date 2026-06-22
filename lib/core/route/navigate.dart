import 'package:flutter/material.dart';

class Navigate {
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget widget,
  ) {
    return Navigator.push<T?>(
      context,
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  static Future<void> replacement(BuildContext context, Widget widget) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  static void pushAndRemove(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => widget),
      (route) => false,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
