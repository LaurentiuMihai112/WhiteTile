import 'package:flutter/material.dart';
import 'package:white_tile/menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'White Tile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MenuPage(title: 'Menu'),
    );
  }
}
