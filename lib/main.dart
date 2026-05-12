import 'package:flutter/material.dart';
import 'package:lapormin/core/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaporMin!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "DM Sans",
        colorScheme: MaterialTheme.lightScheme(),
      ),
      home: TempPage(),
    );
  }
}

class TempPage extends StatelessWidget {
  const TempPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text("Appbar")),
      body: Column(
        children: [
          Text(
            "Hello World",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color.primary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            textAlign: TextAlign.center,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur.",
          ),
        ],
      ),
    );
  }
}
