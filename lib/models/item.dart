import 'dart:io';

class Item {
  String id;
  String name;
  int quantity;
  List<String> categories; // Lista kategorii
  File? image;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    this.categories = const ['Inne'], // Domyślna kategoria to 'Inne'
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'categories': categories, // Konwertowanie listy kategorii do mapy
      'imagePath': image?.path,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      categories:
          List<String>.from(map['categories']), // Konwertowanie z mapy do listy
      image: map['imagePath'] != null ? File(map['imagePath']) : null,
    );
  }
}
