import 'package:flutter/material.dart';
import '../lost_item/lost_item.dart';

class LostItemsViewModel extends ChangeNotifier {
  final List<LostItem> _lostItems = [ // Cambiado a final
    LostItem(
      title: 'Llaves encontradas',
      description: 'Encontradas en el aula 203',
      tag: 'Llaves',
      tagColor: Colors.blueAccent,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    LostItem(
      title: 'Cartera perdida',
      description: 'Color negro con documentos',
      tag: 'Carteras',
      tagColor: Colors.redAccent,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  List<LostItem> get lostItems => _lostItems;

  void addLostItem(LostItem item) {
    _lostItems.add(item);
    notifyListeners(); // Notifica a los widgets que deben actualizarse
  }
}

