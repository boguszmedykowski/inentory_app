import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:garage_inventory/models/item.dart';
import 'package:garage_inventory/models/category.dart';

class InventoryPage extends StatefulWidget {
  final Category category;

  const InventoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Item> items = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inwentaryzacja ${widget.category.name}'),
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
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Dodaj przedmiot',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newItemName = "";
        int newItemQuantity = 0;
        List<String> newItemCategories = [];

        return AlertDialog(
          title: const Text('Dodaj nowy przedmiot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => newItemName = value,
                decoration: const InputDecoration(hintText: "Nazwa przedmiotu"),
              ),
              TextField(
                onChanged: (value) =>
                    newItemQuantity = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(hintText: "Ilość"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  newItemCategories =
                      value.split(',').map((e) => e.trim()).toList();
                },
                decoration: const InputDecoration(
                    hintText: "Kategorie (oddzielone przecinkami)"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Dodaj'),
              onPressed: () {
                setState(() {
                  items.add(Item(
                    id: DateTime.now().toString(),
                    name: newItemName,
                    quantity: newItemQuantity,
                    categories: newItemCategories,
                  ));
                });
                _saveItems();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editItem(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedName = item.name;
        int editedQuantity = item.quantity;
        List<String> editedCategories = List.from(item.categories);

        return AlertDialog(
          title: const Text('Edytuj przedmiot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => editedName = value,
                decoration: const InputDecoration(hintText: "Nazwa przedmiotu"),
                controller: TextEditingController(text: item.name),
              ),
              TextField(
                onChanged: (value) =>
                    editedQuantity = int.tryParse(value) ?? item.quantity,
                decoration: const InputDecoration(hintText: "Ilość"),
                keyboardType: TextInputType.number,
                controller:
                    TextEditingController(text: item.quantity.toString()),
              ),
              TextField(
                onChanged: (value) {
                  editedCategories =
                      value.split(',').map((e) => e.trim()).toList();
                },
                decoration: const InputDecoration(
                    hintText: "Kategorie (oddzielone przecinkami)"),
                controller: TextEditingController(
                  text: item.categories.join(', '),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Zapisz'),
              onPressed: () {
                setState(() {
                  item.name = editedName;
                  item.quantity = editedQuantity;
                  item.categories = editedCategories;
                });
                _saveItems();
                Navigator.of(context).pop();
              },
            ),
          ],
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
