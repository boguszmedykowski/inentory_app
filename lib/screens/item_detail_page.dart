import 'package:flutter/material.dart';
import 'package:garage_inventory/models/item.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Przedmiotu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Ilość: ${item.quantity}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Kategorie: ${item.categories.join(', ')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            if (item.toolImage != null)
              Image.file(
                item.toolImage!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            if (item.locationImage != null)
              Image.file(
                item.locationImage!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            if (item.borrowedTo != null)
              Text(
                'Pożyczono do: ${item.borrowedTo}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 16),
            if (item.borrowDate != null)
              Text(
                'Data pożyczenia: ${item.borrowDate}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 16),
            if (item.returnDate != null)
              Text(
                'Przewidywana data zwrotu: ${item.returnDate}',
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
