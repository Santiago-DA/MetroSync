import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metrosync/ViewModel/ViewModel.dart';

class CreateLostItem extends StatelessWidget {
  const CreateLostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Reportar Objeto Perdido",
          style: Theme
              .of(context)
              .textTheme
              .labelLarge,
        ),
      ),
    );
  }

}