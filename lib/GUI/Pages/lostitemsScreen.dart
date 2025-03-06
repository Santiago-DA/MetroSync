import 'package:flutter/material.dart';

class LostItemsPage extends StatelessWidget {
  const LostItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const SizedBox.shrink(),
        backgroundColor: colors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: colors.inversePrimary),
                backgroundColor: colors.surface,
                foregroundColor: colors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Enviar solicitud',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 20),
             TextField(
            cursorColor: colors.inversePrimary,
            decoration: InputDecoration(
              hintText: 'Buscar',
              hintStyle: theme.textTheme.bodyMedium,
              prefixIcon: Icon(Icons.search, color: colors.inversePrimary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.secondary),
              ),
            ),
          ),
          const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, 
                          color: colors.secondary, 
                          size: 24),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          foregroundColor: colors.inversePrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Etiquetas',
                            style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.access_time,
                          color: colors.secondary,
                          size: 24),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          foregroundColor: colors.inversePrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Recientes',
                            style: theme.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPublicationCard(
                    context: context,
                    objectName: 'Cargador negro',
                    username: '@gabgaru',
                    date: '20/01/2025',
                    location: 'Edificio A - Sala 205',
                    imageUrl: 'https://picsum.photos/200',
                  ),
                  _buildPublicationCard(
                    context: context,
                    objectName: 'Billetera marrón',
                    username: '@usuario24',
                    date: '21/01/2025',
                    location: 'Cafetería principal',
                    imageUrl: 'https://picsum.photos/201',
                  ),
                  _buildPublicationCard(
                    context: context,
                    objectName: 'Laptop plateada',
                    username: '@tecno_user',
                    date: '22/01/2025',
                    location: 'Sala de conferencias',
                    imageUrl: 'https://picsum.photos/202',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicationCard({
    required BuildContext context,
    required String objectName,
    required String username,
    required String date,
    required String location,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.inversePrimary.withOpacity(0.3), width: 1),
          bottom: BorderSide(color: colors.inversePrimary.withOpacity(0.3), width: 1),
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: colors.surface,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.inversePrimary)),
                    child: Icon(Icons.question_mark,
                        size: 18, color: colors.inversePrimary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(objectName,
                              style: theme.textTheme.displaySmall,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(username,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(date, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.inversePrimary),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(location,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.inversePrimary,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 160,
                          height: 30,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: colors.inversePrimary, width: 2),
                            borderRadius: BorderRadius.zero,
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () {},
                            child: Text('Contacto',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors.inversePrimary,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 220,
                    height: 180,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      border: Border.all(
                        color: colors.inversePrimary,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}