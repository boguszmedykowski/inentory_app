import 'package:flutter/material.dart';
import 'package:garage_inventory/models/item.dart';
import 'package:garage_inventory/models/category.dart';

class ItemAddEditDialog extends StatefulWidget {
  final List<Category> availableCategories;
  final Item? item;
  final void Function(String, int, List<String>) onSave;

  const ItemAddEditDialog({
    Key? key,
    required this.availableCategories,
    this.item,
    required this.onSave,
  }) : super(key: key);

  @override
  _ItemAddEditDialogState createState() => _ItemAddEditDialogState();
}

class _ItemAddEditDialogState extends State<ItemAddEditDialog> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late List<String> itemCategories;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item?.name ?? '');
    quantityController =
        TextEditingController(text: widget.item?.quantity.toString() ?? '0');
    itemCategories = widget.item?.categories ?? [];
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.item == null ? 'Dodaj nowy przedmiot' : 'Edytuj przedmiot'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Nazwa przedmiotu"),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(hintText: "Ilość"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                items: widget.availableCategories.map((Category category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && !itemCategories.contains(newValue)) {
                    setState(() {
                      itemCategories.add(newValue);
                    });
                  }
                },
                decoration: InputDecoration(hintText: 'Wybierz kategorie'),
              ),
              Wrap(
                children: itemCategories.map((category) {
                  return Chip(
                    label: Text(category),
                    onDeleted: () {
                      setState(() {
                        itemCategories.remove(category);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Anuluj'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(widget.item == null ? 'Dodaj' : 'Zapisz'),
          onPressed: () {
            widget.onSave(
              nameController.text,
              int.tryParse(quantityController.text) ?? 0,
              itemCategories,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
