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
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    categories = await dbService.getCategories();
    setState(() {});
  }

  void _addCategory() async {
    if (_categoryController.text.isNotEmpty) {
      final newCategory = Category(
        id: DateTime.now().toString(),
        name: _categoryController.text,
      );
      await dbService.insertCategory(newCategory);
      _categoryController.clear();
      _loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategorie'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(hintText: 'Nowa kategoria'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }
}
