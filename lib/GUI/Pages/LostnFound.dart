import 'package:flutter/material.dart';
import '../../lost_item/lost_item.dart';


class LostnFound extends StatefulWidget {
  @override
  _LostnFoundState createState() => _LostnFoundState();
}

class _LostnFoundState extends State<LostnFound> {
  final List<Map<String, dynamic>> tags = [
    {'text': 'Llaves', 'color': Colors.blueAccent},
    {'text': 'Dispositivos', 'color': Colors.lightBlue},
    {'text': 'Cables', 'color': Colors.indigoAccent},
    {'text': 'Ropa', 'color': Colors.cyan},
    {'text': 'Carteras', 'color': Colors.redAccent},
    {'text': 'Utensilios', 'color': Colors.teal},
    {'text': 'Accesorios', 'color': Colors.amber},
    {'text': 'Termos', 'color': Colors.lightBlue.shade300},
    {'text': 'Otros', 'color': Colors.blueGrey},
  ];

  final List<Map<String, dynamic>> lostItems = [
    {
      'title': 'Llaves encontradas',
      'description': 'Encontradas en el aula 203',
      'tag': 'Llaves',
      'tagColor': Colors.blueAccent,
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Cartera perdida',
      'description': 'Color negro con documentos',
      'tag': 'Carteras',
      'tagColor': Colors.redAccent,
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Termo olvidado',
      'description': 'Botella térmica verde',
      'tag': 'Termos',
      'tagColor': Colors.teal,
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  bool isDropdownVisible = false;

  void toggleDropdown() {
    setState(() {
      isDropdownVisible = !isDropdownVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = const ColorScheme.light(
      primary: Colors.blue,
      onPrimary: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text(
          'Objetos Perdidos',
          style: TextStyle(fontSize: 20, color: colors.onPrimary),
        ),
        leading: Icon(Icons.arrow_back, color: colors.onPrimary),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              cursorColor: colors.primary,
              decoration: InputDecoration(
                hintText: 'Buscar',
                hintStyle: TextStyle(color: colors.onBackground),
                prefixIcon: Icon(Icons.search, color: colors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
            ),
          ),
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                if (!isDropdownVisible)
                  Icon(Icons.filter_list, color: colors.primary),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: toggleDropdown,
                  child: Container(
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft:
                            isDropdownVisible ? Radius.zero : Radius.circular(20),
                        bottomRight:
                            isDropdownVisible ? Radius.zero : Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Etiquetas',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, color: colors.primary),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    print('Recientes presionado');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Recientes',
                    style: TextStyle(color: colors.onPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista de tarjetas
          Expanded(
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false, // Oculta la barra de scroll
                  ),
                  child: ListView.builder(
                    itemCount: lostItems.length, // Número de elementos en la lista
                    itemBuilder: (context, index) {
                      final item = lostItems[index]; // Elemento actual

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: SizedBox(
                          height: 150,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item['title'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: item['tagColor'],
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              item['tag'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['description'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Acción del botón
                                          },
                                          child: const Text('Contactar'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colors.primary,
                                            minimumSize: Size(100, 36),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    item['imageUrl'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text(
                                          'Imagen no disponible',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (isDropdownVisible)
                  Positioned(
                    top: 105,
                    left: 16,
                    child: Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Container(
                        width: 160,
                        constraints: const BoxConstraints(maxHeight: 160),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            final tag = tags[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: tag['color'],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag['text'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para agregar una nueva solicitud
          print('Botón de agregar solicitud presionado');
        },
        backgroundColor: colors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
