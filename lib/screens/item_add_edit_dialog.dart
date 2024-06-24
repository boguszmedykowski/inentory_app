import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:garage_inventory/models/item.dart';
import 'package:garage_inventory/models/category.dart';

class ItemAddEditDialog extends StatefulWidget {
  final List<Category> availableCategories;
  final Item? item;
  final void Function(
          String, int, List<String>, File?, File?, String?, String?, String?)
      onSave;

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
  late TextEditingController borrowedToController;
  late TextEditingController borrowDateController;
  late TextEditingController returnDateController;
  late List<String> itemCategories;
  File? toolImage;
  File? locationImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item?.name ?? '');
    quantityController =
        TextEditingController(text: widget.item?.quantity.toString() ?? '0');
    borrowedToController =
        TextEditingController(text: widget.item?.borrowedTo ?? '');
    borrowDateController =
        TextEditingController(text: widget.item?.borrowDate ?? '');
    returnDateController =
        TextEditingController(text: widget.item?.returnDate ?? '');
    itemCategories = widget.item?.categories ?? [];
    toolImage = widget.item?.toolImage;
    locationImage = widget.item?.locationImage;
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    borrowedToController.dispose();
    borrowDateController.dispose();
    returnDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, bool isToolImage) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        if (isToolImage) {
          toolImage = File(image.path);
        } else {
          locationImage = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.item == null ? 'Dodaj nowy przedmiot' : 'Edytuj przedmiot'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(hintText: "Nazwa przedmiotu"),
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
                    if (newValue != null &&
                        !itemCategories.contains(newValue)) {
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Zdjęcie narzędzia'),
                          toolImage != null
                              ? Image.file(toolImage!, width: 100, height: 100)
                              : Container(),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () =>
                                _pickImage(ImageSource.camera, true),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Zdjęcie położenia'),
                          locationImage != null
                              ? Image.file(locationImage!,
                                  width: 100, height: 100)
                              : Container(),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () =>
                                _pickImage(ImageSource.camera, false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: borrowedToController,
                  decoration:
                      const InputDecoration(hintText: "Komu pożyczyłeś"),
                ),
                TextField(
                  controller: borrowDateController,
                  decoration: const InputDecoration(
                      hintText: "Data pożyczenia (DD-MM-RRRR)"),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      setState(() {
                        borrowDateController.text = formattedDate;
                      });
                    }
                  },
                ),
                TextField(
                  controller: returnDateController,
                  decoration: const InputDecoration(
                      hintText: "Przewidywana data zwrotu (DD-MM-RRRR)"),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      setState(() {
                        returnDateController.text = formattedDate;
                      });
                    }
                  },
                ),
              ],
            ),
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
              toolImage,
              locationImage,
              borrowedToController.text,
              borrowDateController.text,
              returnDateController.text,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
