import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';
import 'quiz_page.dart';
import 'camera_page.dart';
import 'study_page.dart';
import 'challenge_page.dart';
import 'my_profile.dart';

class MainNavigationWidget extends StatefulWidget {
  const MainNavigationWidget({Key? key}) : super(key: key);

  @override
  State<MainNavigationWidget> createState() => _MainNavigationWidgetState();
}

class _MainNavigationWidgetState extends State<MainNavigationWidget> {
  int _selectedIndex = 0;
  bool _isDrawerView = false; // Controla si estamos en una vista del drawer

  final List<Widget> _pages = [
    const HomeContent(), // Contenido de la home page sin Scaffold
    const QuizPage(),
    const CameraPage(),
    const StudyPage(),
    const ChallengePage(),
  ];

  final List<Widget> _drawerPages = [
    const MyProfileView(), // Página de perfil
  ];

  // Método para cambiar a vista del drawer
  void _switchToDrawerView(int drawerIndex) {
    setState(() {
      _isDrawerView = true;
      _selectedIndex = drawerIndex;
    });
  }

  // Método para regresar a vistas del bottom navigation
  void _switchToBottomNavView(int index) {
    setState(() {
      _isDrawerView = false;
      _selectedIndex = index;
    });
  }


  // Colores para los íconos seleccionados según cada página
  final List<Color> _selectedIconColors = [
    Colors.blue, // Home - azul
    Colors.blue.shade700, // Quiz - azul oscuro
    Colors.orange.shade700, // Cámara - naranja oscuro
    Colors.green.shade700, // Estudio - verde oscuro
    Colors.purple.shade700, // Desafío - morado oscuro
  ];

  void _onItemTapped(int index) {
    _switchToBottomNavView(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color dinámico según la página
      appBar: _isDrawerView ? AppBar(
        title: const Text('Mi Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _switchToBottomNavView(0), // Regresar al inicio
        ),
      ) : null,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.traffic,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Señales de Tránsito',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.pop(context);
                _switchToDrawerView(0); // Cambiar a la vista de perfil
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                final authController = Provider.of<AuthController>(context, listen: false);
                await authController.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _isDrawerView ? _drawerPages[_selectedIndex] : _pages[_selectedIndex],
      bottomNavigationBar: _isDrawerView ? null : BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _selectedIconColors[_selectedIndex], // Color dinámico según la página
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Estudio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Desafío',
          ),
        ],
      ),
    );
  }
}
