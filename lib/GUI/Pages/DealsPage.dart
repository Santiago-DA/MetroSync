import 'package:flutter/material.dart';

class DealsPage extends StatelessWidget {
  // Datos de ejemplo para las publicaciones
  final List<Map<String, dynamic>> deals = [
    {
      'usuario': '@hollychicken',
      'promocion': '¡BOWL 2x1!',
      'imagen': 'assets/images/promo_hollyshakes.webp', // Ruta de la imagen de la promoción
      'menu': [
        {
          "nombre": "Bowl de Pollo Teriyaki",
          "descripcion": "Arroz jazmín, pollo a la parrilla con salsa teriyaki, brócoli, zanahoria y ajonjolí.",
          "precio": "\$10.99"
        },
        {
          "nombre": "Bowl Mediterráneo",
          "descripcion": "Quinoa, falafel, hummus, pepino, tomate, aceitunas y aderezo de yogur con limón.",
          "precio": "\$12.49"
        },
        {
          "nombre": "Bowl de Salmón Poké",
          "descripcion": "Arroz de sushi, salmón fresco, aguacate, edamame, alga nori y salsa de soya.",
          "precio": "\$14.99"
        },
        {
          "nombre": "Bowl Vegano de Buda",
          "descripcion": "Arroz integral, garbanzos asados, espinaca, zanahoria rallada, aguacate y aderezo de tahini.",
          "precio": "\$9.99"
        }
      ]

    },
    {
      'usuario': '@Pepperonis',
      'promocion': '¡HELADO GRATIS!',
      'imagen': 'assets/images/promo_pepperonis.webp', // Ruta de la imagen de la promoción
      'menu': [
        {
          "nombre": "Pizza Cuatro Quesos",
          "descripcion": "Masa artesanal con mozzarella, gorgonzola, parmesano y provolone.",
          "precio": "\$13.99"
        },
        {
          "nombre": "Pasta Carbonara",
          "descripcion": "Spaghetti con salsa cremosa de huevo, queso pecorino, panceta y pimienta negra.",
          "precio": "\$11.99"
        },
        {
          "nombre": "Pasticho Clásico",
          "descripcion": "Capas de pasta, carne en salsa de tomate, bechamel y queso gratinado.",
          "precio": "\$14.49"
        },
        {
          "nombre": "Pizza Vegetariana",
          "descripcion": "Masa fina con tomate, mozzarella, champiñones, pimientos y aceitunas negras.",
          "precio": "\$12.49"
        }
      ]

    },
    {
      'usuario': '@Molokai',
      'promocion': 'SUSHI MANIA',
      'imagen': 'assets/images/promo_molokai.webp', // Ruta de la imagen de la promoción
      'menu': [
        {
          "nombre": "Sushi Roll de Salmón y Aguacate",
          "descripcion": "Roll relleno de salmón fresco, aguacate y queso crema, cubierto con semillas de sésamo.",
          "precio": "\$14.99"
        },
        {
          "nombre": "Poké Bowl de Atún",
          "descripcion": "Arroz de sushi, atún fresco, edamame, pepino, alga nori y salsa ponzu.",
          "precio": "\$16.49"
        },
        {
          "nombre": "Roll Tempura de Camarón",
          "descripcion": "Camarón crujiente tempurizado, aguacate y salsa spicy mayo.",
          "precio": "\$15.99"
        },
        {
          "nombre": "Poké Bowl Vegano",
          "descripcion": "Quinoa, tofu marinado, mango, pepino, edamame y aderezo de sésamo.",
          "precio": "\$13.49"
        }
      ]

    },
    {
      'usuario': '@GRANIER',
      'promocion': '2X1 EN CROISSANTS',
      'imagen': 'assets/images/promo_granier.webp', // Ruta de la imagen de la promoción
      'menu': [
        {
          "nombre": "Café Latte",
          "descripcion": "Espresso con leche vaporizada y una suave capa de espuma.",
          "precio": "\$4.50"
        },
        {
          "nombre": "Capuccino Clásico",
          "descripcion": "Espresso con una perfecta combinación de leche vaporizada y espuma cremosa.",
          "precio": "\$4.75"
        },
        {
          "nombre": "Tostada con Aguacate",
          "descripcion": "Pan artesanal con aguacate, tomate cherry y un toque de limón.",
          "precio": "\$6.99"
        },
        {
          "nombre": "Croissant de Mantequilla",
          "descripcion": "Crujiente y esponjoso croissant de mantequilla, recién horneado.",
          "precio": "\$3.99"
        }
      ]

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
                    _mostrarMenu(context, deal['usuario'] as String, deal['menu']); // Mostrar menú al presionar
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
  void _mostrarMenu(BuildContext context, String usuario, menuItems) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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