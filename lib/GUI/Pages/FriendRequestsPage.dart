import 'package:flutter/material.dart';
import 'package:metrosync/MongoManager/MongoDb.dart';
import 'package:metrosync/User/Current.dart';



class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});
  
  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _isLoading = true;
  bool _isProcessing = false; // Estado para evitar múltiples clics
  

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    final currentUser = Current().currentUser;
    if (currentUser != null) {
      setState(() => _isLoading = true);
      _pendingRequests = await currentUser.getPendingFriendRequests();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _ensureDatabaseConnection() async {
    if (!MongoDB.isConnected) {
      await MongoDB.connect(); // Abrir la conexión si está cerrada
    }
  }

  Future<void> _acceptFriendRequest(String fromUsername) async {
    final currentUser = Current().currentUser;
    if (currentUser != null && !_isProcessing) {
      setState(() => _isProcessing = true); // Deshabilitar el botón

      try {
        await _ensureDatabaseConnection(); // Asegurar que la conexión esté abierta
        await currentUser.acceptFriendRequest(fromUsername);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitud de $fromUsername aceptada'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadPendingRequests(); // Recargar las solicitudes pendientes
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al aceptar la solicitud: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isProcessing = false); // Habilitar el botón
      }
    }
  }

  Future<void> _rejectFriendRequest(String fromUsername) async {
    final currentUser = Current().currentUser;
    if (currentUser != null && !_isProcessing) {
      setState(() => _isProcessing = true); // Deshabilitar el botón

      try {
        await _ensureDatabaseConnection(); // Asegurar que la conexión esté abierta
        await currentUser.rejectFriendRequest(fromUsername);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitud de $fromUsername rechazada'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadPendingRequests(); // Recargar las solicitudes pendientes
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar la solicitud: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isProcessing = false); // Habilitar el botón
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solicitudes de amistad',
          style: theme.textTheme.displayMedium,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pendingRequests.isEmpty
              ? Center(
                  child: Text(
                    'No tienes solicitudes de amistad pendientes',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = _pendingRequests[index];
                    return Card(
                      elevation: 2.0, // Sombra suave
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                        side: BorderSide(
                          color: theme.colorScheme.secondary.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        title: Text(
                          request['from'],
                          style: theme.textTheme.displaySmall,
                        ),
                        subtitle: Text(
                          'Te ha enviado una solicitud de amistad',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: _isProcessing
                                  ? null // Deshabilitar el botón si se está procesando
                                  : () async {
                                      await _acceptFriendRequest(request['from']);
                                    },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: _isProcessing
                                  ? null // Deshabilitar el botón si se está procesando
                                  : () async {
                                      await _rejectFriendRequest(request['from']);
                                    },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}