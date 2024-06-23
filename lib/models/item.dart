import 'dart:io';

class Item {
  String id;
  String name;
  int quantity;
  String category;
  File? image;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    this.category = 'Inne',
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'imagePath': image?.path,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      category: map['category'],
      image: map['imagePath'] != null ? File(map['imagePath']) : null,
    );
  }
}
