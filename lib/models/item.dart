import 'dart:io';

class Item {
  String id;
  String name;
  int quantity;
  List<String> categories;
  File? toolImage;
  File? locationImage;
  String? borrowedTo;
  String? borrowDate;
  String? returnDate;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.categories,
    this.toolImage,
    this.locationImage,
    this.borrowedTo,
    this.borrowDate,
    this.returnDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'categories': categories,
      'toolImagePath': toolImage?.path,
      'locationImagePath': locationImage?.path,
      'borrowedTo': borrowedTo,
      'borrowDate': borrowDate,
      'returnDate': returnDate,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      categories: List<String>.from(map['categories']),
      toolImage:
          map['toolImagePath'] != null ? File(map['toolImagePath']) : null,
      locationImage: map['locationImagePath'] != null
          ? File(map['locationImagePath'])
          : null,
      borrowedTo: map['borrowedTo'],
      borrowDate: map['borrowDate'],
      returnDate: map['returnDate'],
    );
  }
}
