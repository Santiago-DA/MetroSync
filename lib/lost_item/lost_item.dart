import 'package:flutter/material.dart';
class LostItem {
  final String title; // Título del objeto
  final String description; // Descripción breve
  final String tag; // Etiqueta
  final Color tagColor; // Color de la etiqueta
  final String imageUrl; // URL de la imagen

  LostItem({
    required this.title,
    required this.description,
    required this.tag,
    required this.tagColor,
    required this.imageUrl,
  });

}
