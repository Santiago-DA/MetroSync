import 'package:flutter/material.dart';
import 'package:metrosync/Deals/Deal.dart';
class DealsPage extends StatefulWidget {
  const DealsPage({super.key});
  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  List<Deal> deals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeals();
    insertSampleDeals();
  }
  Future<void> insertSampleDeals() async {
    final sampleDeals = [
      Deal(
        usuario: '@hollychicken',
        promocion: '¡BOWL 2x1!',
        imagen: 'assets/images/promo_hollyshakes.webp',
        menu: [
          {
            "nombre": "Bowl de Pollo Teriyaki",
            "descripcion": "Arroz jazmín, pollo a la parrilla con salsa teriyaki, brócoli, zanahoria y ajonjolí.",
            "precio": "\$10.99"
          },
          // Agrega más ítems del menú aquí...
        ],
      ),
      // Agrega más deals aquí...
    ];

    for (var deal in sampleDeals) {
      await Deal.saveDeal(deal); // Usar el método estático de Deal
    }
    print('Datos de ejemplo insertados en MongoDB.');
  }

  Future<void> _loadDeals() async {
    try {
      var loadedDeals = await Deal.getDeals(); // Usar el método estático de Deal
      setState(() {
        deals = loadedDeals;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando deals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: deals.map((deal) => Column(
          children: [
            // Usuario y botón "Ver menú"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  deal.usuario,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _mostrarMenu(context, deal.usuario, deal.menu);
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
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(deal.imagen),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Nombre de la promoción
            Text(
              deal.promocion,
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
  void _mostrarMenu(BuildContext context, String usuario, List<Map<String, String>> menuItems) {
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
                      item['nombre']!,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['descripcion']!,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['precio']!,
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
                foregroundColor: colors.secondary,
              ),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}