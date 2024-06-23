import 'package:flutter/material.dart';
import 'package:garage_inventory/screens/inventory_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inwentaryzacja Garażu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InventoryPage(),
    );
  }
}
