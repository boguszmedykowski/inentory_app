import 'package:flutter/material.dart';
import 'package:garage_inventory/models/category.dart';
import 'package:garage_inventory/services/db_service.dart';

class ItemForm extends StatefulWidget {
  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  List<Category> availableCategories = []; // List of available categories
  List<String> selectedCategories =
      []; // List of selected categories for the item

  @override
  void initState() {
    super.initState();
    _loadCategories();
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
        title: Text('Dodaj/Edytuj Przedmiot'),
      ),
      body: Column(
        children: [
          // Existing fields
          DropdownButtonFormField<Category>(
            items: availableCategories.map((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (Category? newValue) {
              if (newValue != null &&
                  !selectedCategories.contains(newValue.name)) {
                setState(() {
                  selectedCategories.add(newValue.name);
                });
              }
            },
            decoration: InputDecoration(hintText: 'Kategorie'),
          ),
          Wrap(
            children: selectedCategories.map((category) {
              return Chip(
                label: Text(category),
                onDeleted: () {
                  setState(() {
                    selectedCategories.remove(category);
                  });
                },
              );
            }).toList(),
          ),
          // Existing fields and buttons
        ],
      ),
    );
  }

  void _saveItem() {
    // Save item with selected categories
  }
}
