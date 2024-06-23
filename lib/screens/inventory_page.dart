import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:garage_inventory/models/item.dart';
import 'package:garage_inventory/models/category.dart';
import 'package:garage_inventory/services/db_service.dart';
import 'package:garage_inventory/screens/item_detail_page.dart';
import 'package:garage_inventory/screens/item_add_edit_dialog.dart';

class InventoryPage extends StatefulWidget {
  final Category category;

  const InventoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Item> items = [];
  String _searchQuery = '';
  List<Category> availableCategories = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadCategories();
  }

  void _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('items');
    if (encodedData != null) {
      final List<Item> allItems = (json.decode(encodedData) as List)
          .map((item) => Item.fromMap(item))
          .toList();
      setState(() {
        items = allItems
            .where((item) => item.categories.contains(widget.category.name))
            .toList();
      });
    }
  }

  void _loadCategories() async {
    final dbService = DbService();
    availableCategories = await dbService.getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.name}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                hintText: "Szukaj przedmiotów",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items
                  .where((item) =>
                      item.name.toLowerCase().contains(_searchQuery) ||
                      item.categories.any((category) =>
                          category.toLowerCase().contains(_searchQuery)))
                  .length,
              itemBuilder: (context, index) {
                final filteredItems = items
                    .where((item) =>
                        item.name.toLowerCase().contains(_searchQuery) ||
                        item.categories.any((category) =>
                            category.toLowerCase().contains(_searchQuery)))
                    .toList();
                final item = filteredItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      'Ilość: ${item.quantity} | Kategorie: ${item.categories.join(', ')}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editItem(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _addPhoto(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            items.remove(item);
                          });
                          _saveItems();
                        },
                      ),
                    ],
                  ),
                  leading: item.image != null
                      ? Image.file(item.image!,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailPage(item: item),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context),
        tooltip: 'Dodaj przedmiot',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemAddEditDialog(
          availableCategories: availableCategories,
          onSave: (newItemName, newItemQuantity, newItemCategories) {
            setState(() {
              items.add(Item(
                id: DateTime.now().toString(),
                name: newItemName,
                quantity: newItemQuantity,
                categories: newItemCategories,
              ));
            });
            _saveItems();
          },
        );
      },
    );
  }

  void _editItem(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemAddEditDialog(
          availableCategories: availableCategories,
          item: item,
          onSave: (editedName, editedQuantity, editedCategories) {
            setState(() {
              item.name = editedName;
              item.quantity = editedQuantity;
              item.categories = editedCategories;
            });
            _saveItems();
          },
        );
      },
    );
  }

  Future<void> _addPhoto(Item item) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        item.image = File(image.path);
      });
      _saveItems();
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      items.map((item) => item.toMap()).toList(),
    );
    await prefs.setString('items', encodedData);
  }
}
