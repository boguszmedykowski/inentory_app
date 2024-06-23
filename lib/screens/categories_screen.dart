import 'package:flutter/material.dart';
import 'package:garage_inventory/models/category.dart';
import 'package:garage_inventory/services/db_service.dart';
import 'package:garage_inventory/screens/inventory_page.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];
  final DbService dbService = DbService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    categories = await dbService.getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategorie'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index].name),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InventoryPage(category: categories[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
