import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_final/src/providers/book_provider.dart';
import 'package:proyecto_final/src/models/book.dart';
import 'package:proyecto_final/src/views/start_read_page.dart';
import 'package:proyecto_final/src/widgets/LinearProgress.dart';
import 'package:proyecto_final/src/shared/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bookProvider = BookProvider();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    initMessaging();
  }

  initMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print("User granted permission: ${settings.authorizationStatus}");

    final token = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['page'] && context.mounted) {
        context.goNamed(message.data['page']);
      }
    });

    return Scaffold(
      endDrawer: Drawer(
        width: 320,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[50]!, Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue[700]!, Colors.blue[600]!],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              FirebaseAuth.instance.currentUser?.photoURL ??
                                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face',
                            ),
                            radius: 32,
                            backgroundColor: Colors.blue[100],
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FirebaseAuth.instance.currentUser?.displayName ??
                                    'Lector Premium',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                FirebaseAuth.instance.currentUser?.email ??
                                    'lector@ejemplo.com',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '📚 Nivel Lector',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // datos realess
                    FutureBuilder<Map<String, dynamic>>(
                      future: bookProvider.getUserStats(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatCircle('...', 'Libros', Icons.menu_book_rounded),
                                _buildStatCircle('...', 'Págs.', Icons.auto_stories_rounded),
                                _buildStatCircle('15', 'Días', Icons.local_fire_department_rounded),
                              ],
                            ),
                          );
                        }

                        final stats = snapshot.data ?? {'totalBooks': 0, 'totalPages': 0, 'daysStreak': 15};
                        
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCircle('${stats['totalBooks']}', 'Libros', Icons.menu_book_rounded),
                              _buildStatCircle('${stats['totalPages']}', 'Págs.', Icons.auto_stories_rounded),
                              _buildStatCircle('${stats['daysStreak']}', 'Días', Icons.local_fire_department_rounded),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        'MENÚ PRINCIPAL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 15),

                      // ITEMS DEL MENÚ
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          children: [
                            _buildMenuItem(
                              icon: Icons.home_rounded,
                              title: 'Inicio',
                              isSelected: true,
                              gradient: [Colors.blue[700]!, Colors.blue[600]!],
                            ),
                            _buildMenuItem(
                              icon: Icons.bar_chart_rounded,
                              title: 'Estadísticas',
                              onTap: () {
                                Navigator.pop(context);
                                context.go('/stadistics');
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.bookmark_rounded,
                              title: 'Mis Favoritos',
                              onTap: () {
                                Navigator.pop(context);
                                // favoritos
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.library_books_rounded,
                              title: 'Mi Biblioteca',
                              onTap: () {
                                Navigator.pop(context);
                                // Navegar a biblioteca
                              },
                            ),

                            SizedBox(height: 20),
                            Text(
                              'CONFIGURACIÓN',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 15),

                            _buildMenuItem(
                              icon: Icons.settings_rounded,
                              title: 'Ajustes',
                              onTap: () {
                                Navigator.pop(context);
                                // Navegar a ajustes
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.help_rounded,
                              title: 'Ayuda',
                              onTap: () {
                                Navigator.pop(context);
                                // Navegar a ayuda
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.info_rounded,
                              title: 'Acerca de mi',
                              onTap: () {
                                Navigator.pop(context);
                                context.push('/about');
                              },
                            ),
                          ],
                        ),
                      ),

                      // CERRAR SESIÓN
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.logout_rounded,
                              color: Colors.red[600],
                              size: 22,
                            ),
                            title: Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () => _showLogoutConfirmation(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        title: const Text(
          'Books',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0.2,
        shadowColor: Color(0xFFE5E5E5),
      ),

      body: StreamBuilder(
        stream: bookProvider.getAllBooksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          final List<Book> books = snapshot.data!;

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(12.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: [
              // 12 maximo
              if (books.length < 12 || !snapshot.hasData || snapshot.data!.isEmpty)
                GestureDetector(
                  onTap: () => context.push("/home/create"),
                  child: Card(
                    elevation: 3,
                    color: const Color.fromARGB(255, 233, 227, 227),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),

              ...List.generate(books.length, (index) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      'update-book',
                      pathParameters: {'id': books[index].id},
                      extra: books[index].toJson(),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // IMAGEN DEL LIBRO
                              FutureBuilder<bool>(
                                future: File(books[index].coverImage).exists(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == true) {
                                    return Image.file(
                                      File(books[index].coverImage),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Image(
                                      image: NetworkImage(
                                        "https://i.pinimg.com/736x/d1/d9/ba/d1d9ba37625f9a1210a432731e1754f3.jpg",
                                      ),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                              
                              // BOTÓN EN ESQUINA SUPERIOR DERECHA
                              Positioned(
                                top: -8,
                                right: -12,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'Update':
                                          context.pushNamed(
                                            'update-book',
                                            pathParameters: {'id': books[index].id},
                                            extra: books[index].toJson(),
                                          );
                                          break;
                                        case 'Start':
                                        
                                        try {
                                          GoRouter.of(context).push(
                                            '/start/${books[index].id}',
                                            extra: books[index].toJson(),
                                          );
                                        } catch (e) {
                                      
                                          Navigator.of(context, rootNavigator: true).push(
                                            MaterialPageRoute(
                                              builder: (context) => StartReadPage(
                                                bookId: books[index].id,
                                                bookData: books[index].toJson(),
                                              ),
                                            ),
                                          );
                                        }
                                          break;
                                        case 'Delete':
                                          Utils.showConfirm(
                                            context: context,
                                            confirmButton: () {
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user?.uid)
                                                  .collection('books')
                                                  .doc(books[index].id)
                                                  .delete();

                                              if (!context.mounted) return;
                                              context.pop(books.remove(books[index]));
                                            },
                                          );
                                          break;
                                        default:
                                          return;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(value: 'Update', child: Text('Editar')),
                                      PopupMenuItem(value: 'Start', child: Text('Comenzar a leer')),
                                      PopupMenuItem(value: 'Delete', child: Text('Eliminar', style: TextStyle(color: Colors.red))),
                                    ],
                                    icon: Icon(Icons.more_vert_rounded, size: 16, color: Colors.black),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              books[index].title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              books[index].author,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Row(
                              children: [
                                Text('Progress'),
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LinearProgres(
                                      value: (books[index].currentPage / books[index].totalPages),
                                      min: 4,
                                      width: 80,
                                      heightBar: 3,
                                    ),
                                    Text(
                                      '${((books[index].currentPage / books[index].totalPages) * 100).round()}%',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        height: 50,
        elevation: 0.2,
        shadowColor: Color(0xFFE5E5E5),
        notchMargin: 0,
        padding: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.go('/home');
              },
              icon: Icon(
                Icons.home,
                size: 35,
                color: const Color.fromARGB(255, 31, 31, 31),
              ),
            ),
            IconButton(
              onPressed: () {
                context.go('/stadistics');
              },
              icon: Icon(
                Icons.line_axis_rounded,
                size: 35,
                color: const Color.fromARGB(255, 31, 31, 31),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para círculos de estadísticas
  Widget _buildStatCircle(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.blue[700], size: 22),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  // Método para items del menú
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    List<Color>? gradient,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? null : Colors.transparent,
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient ?? [Colors.blue[700]!, Colors.blue[600]!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                )
              : null,
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
              size: 22,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
            onTap: onTap ?? () {},
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ),
    );
  }

  // Diálogo de confirmación para logout
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey[50]!],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout_rounded, color: Colors.red[600], size: 50),
                SizedBox(height: 15),
                Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '¿Estás seguro de que quieres salir?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            context.replace('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Salir',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}