import 'package:flutter/material.dart';
import 'WeekSchedule.dart';
import 'package:metrosync/Schedules/Schedule.dart'; // Importar la clase Schedule
import 'package:metrosync/Schedules/TimeSlot.dart'; 
import 'package:metrosync/User/Current.dart'; 
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:metrosync/MongoManager/MongoDB.dart';
class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({super.key});
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Schedule _schedule; // Horario del usuario
  late String _username ;
  List<Map<String,String>> _friends = []; // Lista de amigos
  List<Map<String, dynamic>> _huecosComunes = []; // Huecos en común
 // Nombre de usuario actual (debe ser dinámico en una app real)

  bool _isLoading = true;

@override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
  final currentUser = Current().currentUser;
  if (currentUser != null) {
    _username = currentUser.getusername();
    await _loadFriends(); // Esperar a que los amigos se carguen
  } else {
    _username = 'usuario_no_logueado';
  }
  _schedule = Schedule(_username);
  await _loadSchedule(); // Esperar a que el horario se cargue
}

Future<void> _loadFriends() async {
  final currentUser = Current().currentUser;
  if (currentUser != null) {
    try {
      // Conectar a la base de datos
      await MongoDB.connect();

      // Cargar amigos desde la base de datos
      await currentUser.loadFriends();

      // Actualizar el estado con los amigos cargados
      setState(() {
        _friends = currentUser.getFriends();
        print('Amigos cargados: $_friends');
      });
    } catch (e) {
      print('Error cargando amigos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cargando amigos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Cerrar la conexión a la base de datos
      await MongoDB.close();
    }
  } else {
    print('Usuario no logueado, no se pueden cargar amigos.');
  }
}

  // Cargar el horario desde la base de datos
   Future<void> _loadSchedule() async {
    setState(() => _isLoading = true); // Activar estado de carga
    await _schedule.loadfromBD();
    setState(() => _isLoading = false); // Desactivar estado de carga
  }

  // Añadir una materia al horario
  void _agregarMateria(TimeSlot nuevaMateria, String dia) async {
    setState(() {
      _schedule.newslot(dia, nuevaMateria); // Añadir al horario
    });
    // Guardar cambios en la base de datos
  }

  // Eliminar una materia del horario
  void _eliminarMateria(TimeSlot materia, String dia) async {
  setState(() {
    _schedule.removeSlot(
      materia.getclassname(),
      materia.getstarthour(),
      materia.getendhour(),
    );
  });
}
void _sincronizarConAmigo(){
  print("yei");
}

  // Obtener las materias del día actual
  List<TimeSlot> _materiasDelDia() {
    final diaActual = "Lunes";
    final dayEnum = _schedule.strtoenum(diaActual);
    return _schedule.slotsPerDay[dayEnum] ?? [];
  }

  // Obtener el día actual
  String _obtenerDiaActual() {
    final now = DateTime.now();
    final weekday = now.weekday;
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miercoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sabado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

 
  final List<Map<String, dynamic>> huecosComunes = [
    
  ];



List<TimeOfDay> parseHorario(String horario) {
  List<String> parts = horario.split(' - ');
  TimeOfDay start = _parseTimePart(parts[0]);
  TimeOfDay end = _parseTimePart(parts[1]);
  return [start, end];
}

TimeOfDay _parseTimePart(String part) {
  part = part.trim().toLowerCase();
  bool isAM = part.contains('a.m');
  String timeStr = part.replaceAll(RegExp(r'[a.m.p.m. ]'), '');
  List<String> components = timeStr.split(':');
  int hour = int.parse(components[0]);
  int minute = components.length > 1 ? int.parse(components[1]) : 0;

  if (!isAM && hour != 12) {
    hour += 12;
  } else if (isAM && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}
  
@override
Widget build(BuildContext context) {
  if (_isLoading) {
    // Muestra una pantalla de carga mientras se cargan los datos
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // Verificar si no hay materias
  final bool noHayMaterias = _schedule.slotsPerDay.isEmpty ||
      _schedule.slotsPerDay.values.every((list) => list.isEmpty);

  // Mostrar un SnackBar si no hay materias
if (noHayMaterias) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Para agregar materias, presione el botón "+"',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          action: SnackBarAction(
            label: 'Entendido',
            textColor: Theme.of(context).colorScheme.surface,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          duration: Duration(seconds: 7),
        ),
      );
    });
  }

  // Muestra la interfaz principal cuando los datos están listos
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 4),
          _buildSeccion(
            context: context,
            height: 180,
            title: 'Mi Horario Hoy',
            items: _materiasDelDia(),
            builder: _buildTarjetaMateria,
            accion: Tooltip(
              message: 'Presiona aquí para crear tu horario en WeekSchedule',
              child: IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeekSchedule(
                        schedule: _schedule,
                        onSubjectAdded: _agregarMateria,
                        onSubjectDeleted: _eliminarMateria,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Sección de Huecos en Común
          _buildSeccion1(
            context: context,
            height: 130,
            title: 'Huecos en Común',
            items: _huecosComunes,
            builder: _buildTarjetaHueco,
          ),
          // Sección de Amigos
          _buildSeccion1(
            context: context,
            height: 180,
            title: 'Amigos',
            items: _friends, // Pasar la lista de amigos directamente
            builder: _buildTarjetaAmigo,
          ),
        ],
      ),
    ),
  );
} 
    
  Widget _buildSeccion1({
  required BuildContext context,
  required double height,
  required String title,
  required List<Map<String, dynamic>> items, // Cambiar a List<Map<String, dynamic>>
  required Widget Function(BuildContext, Map<String, dynamic>) builder, // Cambiar el tipo del builder
  Widget? accion,
}) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(26.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            if (accion != null) accion,
          ],
        ),
      ),
      SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => builder(context, items[index]),
        ),
      ),
      Divider(thickness: 10, color: theme.colorScheme.surface),
    ],
  );
}

 Widget _buildSeccion({
  required BuildContext context,
  required double height,
  required String title,
  required List<TimeSlot> items,
  required Widget Function(BuildContext, TimeSlot) builder,
  Widget? accion,
}) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(26.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            if (accion != null) accion,
          ],
        ),
      ),
      SizedBox(
        height: height,
        child: items.isEmpty
            ? Center(
                child: Text(
                  'No hay materias agregadas',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.inversePrimary,
                  ),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) => builder(context, items[index]),
              ),
      ),
      Divider(thickness: 10, color: theme.colorScheme.surface),
    ],
  );
}
  Widget _buildTarjetaMateria(BuildContext context, TimeSlot materia) {
  final theme = Theme.of(context);

  return GestureDetector(
    onTap: () => _mostrarPopupMateria(context, materia),
    onLongPress: () => _mostrarDialogoEliminar(context, materia),
    child: Container(
      height:180,
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
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${materia.getstarthour().format(context)} - ${materia.getendhour().format(context)}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Center( // Centrar el texto del lugar
              child: Text(
                materia.getLugar(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _mostrarDialogoEliminar(BuildContext context, TimeSlot materia) {
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
              _eliminarMateria(materia, _obtenerDiaActual());
              Navigator.pop(context);
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


 Widget _buildTarjetaHueco(BuildContext context, Map<String, dynamic> hueco) {
  final theme = Theme.of(context);

  return Container(
    width: 200,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: theme.colorScheme.primary, // Usar el color primario del tema
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group, size: 32, color: theme.colorScheme.inversePrimary),
          const SizedBox(height: 8),
          Text(
            hueco['nombre'] ?? 'Hueco común', // Valor por defecto si no hay nombre
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hueco['horario'] ?? 'Horario no disponible', // Valor por defecto si no hay horario
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
        ],
      ),
    ),
  );
}

Widget _buildTarjetaAmigo(BuildContext context, Map<String, dynamic> amigo) {
  final theme = Theme.of(context);

  return Container(
    width: 200,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: theme.colorScheme.primary, // Usar el color primario del tema
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícono de account_circle
          Icon(
            Icons.account_circle,
            size: 48,
            color: theme.colorScheme.surface,
          ),
          const SizedBox(height: 8),
          // Nombre de usuario
          Text(
            amigo['username'] ?? 'Usuario', // Valor por defecto si no hay username
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Nombre completo
          Text(
            amigo['name'] ?? 'Nombre no disponible', // Valor por defecto si no hay name
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _sincronizarConAmigo(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.inversePrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Sincronizar',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}}