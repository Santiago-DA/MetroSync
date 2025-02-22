import 'package:flutter/material.dart';
import 'CreateSchedulePage.dart';

class WeekSchedule extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> horarioSemanal = {
    'Lunes': [
      {
        'materia': 'Sistemas Operativos',
        'horario': '8:00 - 10:00',
        'aula': 'A1-301',
        'profesor': 'Prof. García',
        'trimestre': 'XI',
      },
      {
        'materia': 'Física',
        'horario': '10:30 - 12:30',
        'aula': 'A2-105',
        'profesor': 'Prof. López',
        'trimestre': 'XI',
      },
    ],
    'Martes': [
      {
        'materia': 'Química',
        'horario': '9:00 - 11:00',
        'aula': 'A3-204',
        'profesor': 'Prof. Martínez',
        'trimestre': 'XI',
      },
    ],
    'Miércoles': [
      {
        'materia': 'Biología',
        'horario': '8:30 - 10:30',
        'aula': 'A2-102',
        'profesor': 'Prof. Rodríguez',
        'trimestre': 'XI',
      },
      {
        'materia': 'Historia',
        'horario': '11:00 - 13:00',
        'aula': 'A1-303',
        'profesor': 'Prof. Fernández',
        'trimestre': 'XI',
      },
    ],
    'Jueves': [
      {
        'materia': 'Literatura',
        'horario': '10:00 - 12:00',
        'aula': 'A1-101',
        'profesor': 'Prof. Gómez',
        'trimestre': 'XI',
      },
    ],
    'Viernes': [
      {
        'materia': 'Educación Física',
        'horario': '7:30 - 9:30',
        'aula': 'Gimnasio',
        'profesor': 'Prof. Pérez',
        'trimestre': 'XI',
      },
    ],
  };

  WeekSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario Semanal'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBotonGigante(context),
            ...horarioSemanal.entries.map((entry) => _buildDia(
                  context,
                  dia: entry.key,
                  materias: entry.value,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonGigante(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateSchedulePage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            'Agregar clase',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildDia(
    BuildContext context, {
    required String dia,
    required List<Map<String, dynamic>> materias,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            dia,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: materias.length,
            itemBuilder: (context, index) => _buildTarjetaMateria(
              materias[index],
              context,
            ),
          ),
        ),
        Divider(thickness: 2, color: Theme.of(context).colorScheme.surface),
      ],
    );
  }

  Widget _buildTarjetaMateria(Map<String, dynamic> materia, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _mostrarPopupMateria(context, materia);
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                materia['materia'],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.access_time, materia['horario'], context),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, materia['aula'], context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _mostrarPopupMateria(BuildContext context, Map<String, dynamic> materia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            materia['materia'],
            style: Theme.of(context).textTheme.displayLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.access_time, materia['horario'], context),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, materia['aula'], context),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person, materia['profesor'], context),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_today, 'Trimestre: ${materia['trimestre']}', context),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, // Color secundario del tema
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}