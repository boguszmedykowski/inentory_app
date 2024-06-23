import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garage_inventory/models/category.dart';

class DbService {
  Future<void> insertCategory(Category category) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Category> categories = await getCategories();
    categories.add(category);
    final String encodedData = json.encode(
      categories.map((category) => category.toMap()).toList(),
    );
    await prefs.setString('categories', encodedData);
  }

  Future<List<Category>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('categories');
    if (encodedData != null) {
      return (json.decode(encodedData) as List)
          .map((data) => Category.fromMap(data))
          .toList();
    }
    return [];
  }
}
