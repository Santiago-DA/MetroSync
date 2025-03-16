import 'package:flutter/material.dart';
import 'package:metrosync/GUI/Pages/CreatePost.dart';
import 'package:metrosync/MongoManager/MongoDb.dart';
import 'DealsPage.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onMailPressed;
  final VoidCallback onhandpressed;

  const HomePage({
    super.key,
    required this.onMailPressed,
    required this.onhandpressed,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final MongoDB _db = MongoDB();
  List<Map<String, dynamic>> _allPosts = [];
  List<Map<String, dynamic>> _filteredPosts = [];
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 0;
  final int _postsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    try {
      await MongoDB.connect();
      var posts = await _db.findManyFrom('Posts', null);
      
      setState(() {
        _allPosts = posts;
        _filteredPosts = _allPosts
          .take((_currentPage + 1) * _postsPerPage)
          .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando posts: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    } finally {
      await MongoDB.close();
    }
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPosts = _allPosts
          .where((post) => post['tittle'].toString().toLowerCase().contains(query))
          .take((_currentPage + 1) * _postsPerPage)
          .toList();
    });
  }

  void _loadMorePosts() {
    setState(() {
      _currentPage++;
      _filteredPosts = _allPosts
          .take((_currentPage + 1) * _postsPerPage)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 4),
              Image.asset('assets/images/logo_solo.png'),
              const SizedBox(width: 8),
              Text('MetroSync', style: theme.textTheme.titleSmall),
            ],
          ),
          backgroundColor: colors.surface,
          actions: [
            IconButton(
              icon: Icon(Icons.handshake, color: colors.inversePrimary),
              onPressed: widget.onhandpressed,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.mail, color: colors.inversePrimary),
              onPressed: widget.onMailPressed,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Divider(thickness: 5, color: theme.colorScheme.secondary),
          const SizedBox(height: 5),
          Container(
            width: 306,
            height: 175,
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildImageContainer(
                      context, 'assets/images/advertisement_hollyshakes.webp'),
                  _buildImageContainer(
                      context, 'assets/images/anuncio_granier.webp'),
                  _buildImageContainer(
                      context, 'assets/images/anuncio_pepperonis.webp'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _searchController,
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
              Icon(Icons.filter_list, color: colors.inversePrimary),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _filterByLabel('Etiqueta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Etiquetas', style: theme.textTheme.labelMedium),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, color: colors.inversePrimary),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _sortByRecent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Recientes', style: theme.textTheme.labelMedium),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _hasError
                  ? Center(child: Text('Error cargando posts'))
                  : _filteredPosts.isEmpty
                      ? Center(child: Text('No hay posts disponibles'))
                      : Column(
                          children: [
                            ..._filteredPosts.map((post) => PostWidget(
                                  userName: post['username'] ?? 'Anónimo',
                                  title: post['tittle'] ?? 'Sin título',
                                  description: post['description'] ?? '',
                                  contentLabel: post['label'] ?? 'General',
                                  likes: (post['likes'] ?? 0).toInt(),
                                  comments: (post['comments']?.length ?? 0).toInt(),
                                  onTap: () => _showPostDetails(context, post),
                                )).toList(),
                            if (_allPosts.length > _filteredPosts.length)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: _loadMorePosts,
                                  child: Text('Cargar más posts'),
                                ),
                              ),
                          ],
                        ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
          _loadPosts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _sortByRecent() {
    setState(() {
      _allPosts.sort((a, b) => b['date'].compareTo(a['date']));
      _filteredPosts = _allPosts.take((_currentPage + 1) * _postsPerPage).toList();
    });
  }

  void _filterByLabel(String label) {
    setState(() {
      _filteredPosts = _allPosts
          .where((post) => post['label'] == label)
          .take((_currentPage + 1) * _postsPerPage)
          .toList();
    });
  }

  Widget _buildImageContainer(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DealsPage()),
      ),
      child: Container(
        width: 306,
        height: 164,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showPostDetails(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => PostDetailsDialog(post: post),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String userName;
  final String title;
  final String description;
  final String contentLabel;
  final int likes;
  final int comments;
  final VoidCallback? onTap;

  const PostWidget({
    super.key,
    required this.userName,
    required this.title,
    required this.description,
    required this.contentLabel,
    required this.likes,
    required this.comments,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/user_avatar.png'),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  contentLabel,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up, size: 20),
                    onPressed: () {},
                  ),
                  Text('$likes Likes'),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.comment, size: 20),
                    onPressed: () {},
                  ),
                  Text('$comments Comments'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailsDialog({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<dynamic> comments = post['comments'] ?? [];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: screenWidth * 0.95,
        height: screenHeight * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/user_avatar.png'),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  post['username'] ?? 'Anónimo',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['tittle'] ?? 'Sin título',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post['description'] ?? '',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Comentarios (${comments.length})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    comments.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Text(
                                'Nadie ha comentado nada',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    radius: 16,
                                    child: Icon(Icons.person, size: 18),
                                  ),
                                  title: Text(
                                    comments[index]['user']?.toString() ?? 'Usuario',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  subtitle: Text(
                                    comments[index]['text']?.toString() ?? '',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}