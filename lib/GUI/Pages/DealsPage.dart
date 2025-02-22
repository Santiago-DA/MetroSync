import 'package:flutter/material.dart';

class DealsPage extends StatelessWidget {
  // Datos de ejemplo para las publicaciones
  final List<Map<String, dynamic>> deals = [
    {
      'usuario': '@pinchopan',
      'promocion': 'SUPER OMBO!',
      'imagen': 'assets/images/promo1.jpg', // Ruta de la imagen de la promoción
    },
    {
      'usuario': '@tucalvopizero',
      'promocion': 'PIZZO',
      'imagen': 'assets/images/promo2.jpg', // Ruta de la imagen de la promoción
    },
    {
      'usuario': '@burgerlover',
      'promocion': 'BURGER MANIA',
      'imagen': 'assets/images/promo3.jpg', // Ruta de la imagen de la promoción
    },
    {
      'usuario': '@sushiking',
      'promocion': 'SUSHI DELIGHT',
      'imagen': 'assets/images/promo4.jpg', // Ruta de la imagen de la promoción
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: deals.map((deal) => Column(
          children: [
            // Usuario y botón "Ver menú"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  deal['usuario'] as String,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarMenu(context, deal['usuario'] as String); // Mostrar menú al presionar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Ver menú',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Cajita para la imagen de la promoción
            Card(
              elevation: 5, // Sombra para dar profundidad
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados para la imagen
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(deal['imagen'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Nombre de la promoción
            Text(
              deal['promocion'] as String,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Separador entre publicaciones
            const Divider(height: 24, thickness: 2),
          ],
        )).toList(),
      ),
    );
  }

  // Función para mostrar el menú en un popup
  void _mostrarMenu(BuildContext context, String usuario) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Datos del menú inventado
    final List<Map<String, dynamic>> menuItems = [
      {
        'nombre': 'Hamburguesa Clásica',
        'descripcion': 'Carne de res, queso, lechuga, tomate y salsa especial.',
        'precio': '\$8.99',
      },
      {
        'nombre': 'Pizza Margarita',
        'descripcion': 'Mozzarella fresca, tomate y albahaca.',
        'precio': '\$12.99',
      },
      {
        'nombre': 'Sushi Roll',
        'descripcion': 'Roll de salmón, aguacate y pepino.',
        'precio': '\$15.99',
      },
      {
        'nombre': 'Ensalada César',
        'descripcion': 'Lechuga romana, croutones, parmesano y aderezo César.',
        'precio': '\$6.99',
      },
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Menú de $usuario',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      item['nombre'] as String,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['descripcion'] as String,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['precio'] as String,
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: colors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: colors.secondary, // Color del texto
              ),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}