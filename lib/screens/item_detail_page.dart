import 'package:flutter/material.dart';
import 'package:garage_inventory/models/item.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły Przedmiotu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Ilość: ${item.quantity}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Kategorie: ${item.categories.join(', ')}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            item.image != null
                ? Image.file(
                    item.image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
