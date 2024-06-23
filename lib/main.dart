import 'package:flutter/material.dart';
import 'package:garage_inventory/screens/inventory_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inwentaryzacja Garażu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InventoryPage(),
    );
  }
}
