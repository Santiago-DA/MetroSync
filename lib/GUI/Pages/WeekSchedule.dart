import 'package:flutter/material.dart';
import 'CreateSchedulePage.dart';
import 'package:metrosync/Schedules/Schedule.dart'; // Importar la clase Schedule
import 'package:metrosync/Schedules/TimeSlot.dart'; // Importar la clase TimeSlot

class WeekSchedule extends StatefulWidget {
  final Schedule schedule;
  final Function(TimeSlot, String) onSubjectAdded;
  final Function(TimeSlot, String) onSubjectDeleted;

  const WeekSchedule({
    super.key,
    required this.schedule,
    required this.onSubjectAdded,
    required this.onSubjectDeleted,
  });

  @override
  State<WeekSchedule> createState() => _WeekScheduleState();
}

class _WeekScheduleState extends State<WeekSchedule> {
  // Lista de días de la semana en orden
  final List<String> diasOrdenados = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes'];

  @override
  Widget build(BuildContext context) {
    // Convertir las entradas del mapa en una lista y ordenarla
    final entries = widget.schedule.slotsPerDay.entries.toList();
    entries.sort((a, b) {
      final indexA = diasOrdenados.indexOf(a.key.toString().split('.').last);
      final indexB = diasOrdenados.indexOf(b.key.toString().split('.').last);
      return indexA.compareTo(indexB);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario Semanal'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBotonAgregarClase(context),
            // Mapear las entradas ordenadas
            ...entries.map((entry) => _buildDia(
                  context,
                  dia: entry.key.toString().split('.').last,
                  materias: entry.value,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonAgregarClase(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateSchedulePage(
              onSave: (nuevaMateria, dia) {
                widget.onSubjectAdded(nuevaMateria, dia);
                setState(() {});
              },
            ),
          ),
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
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Agregar clase',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildDia(BuildContext context, {required String dia, required List<TimeSlot> materias}) {
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
              dia,
              context,
            ),
          ),
        ),
        Divider(thickness: 2, color: Theme.of(context).colorScheme.surface),
      ],
    );
  }

  Widget _buildTarjetaMateria(TimeSlot materia, String dia, BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _mostrarPopupMateria(context, materia),
      onLongPress: () => _mostrarDialogoEliminar(context, materia, dia),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                materia.getclassname(),
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Text(
                '${materia.getstarthour().format(context)} - ${materia.getendhour().format(context)}',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              Text(
                materia.getLugar(),
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, TimeSlot materia, String dia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar materia', style: Theme.of(context).textTheme.displayLarge),
        content: Text('¿Seguro que quieres eliminar ${materia.getclassname()}?', 
                 style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(
              color: Theme.of(context).colorScheme.secondary)),
          ),
          TextButton(
            onPressed: () {
              widget.onSubjectDeleted(materia, dia);
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Eliminar', style: TextStyle(
              color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _mostrarPopupMateria(BuildContext context, TimeSlot materia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          materia.getclassname(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Horario: ${materia.getstarthour().format(context)} - ${materia.getendhour().format(context)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Aula: ${materia.getLugar()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Profesor: ${materia.getProfesor()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Trimestre: ${materia.getTrimestre()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}