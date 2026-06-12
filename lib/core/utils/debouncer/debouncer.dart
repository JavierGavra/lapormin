import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    // Kalau pelayan masih jalan, suruh balik dulu
    if (_timer != null) {
      _timer!.cancel();
    }
    // Set timer baru, kalau udah [milliseconds] berlalu, baru eksekusi
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
