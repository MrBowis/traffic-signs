import 'package:flutter/material.dart';
import 'home_page.dart';
import 'quiz_page.dart';
import 'camera_page.dart';
import 'study_page.dart';
import 'challenge_page.dart';

class MainNavigationWidget extends StatefulWidget {
  const MainNavigationWidget({Key? key}) : super(key: key);

  @override
  State<MainNavigationWidget> createState() => _MainNavigationWidgetState();
}

class _MainNavigationWidgetState extends State<MainNavigationWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(), // Contenido de la home page sin Scaffold
    const QuizPage(),
    const CameraPage(),
    const StudyPage(),
    const ChallengePage(),
  ];


  // Colores para los íconos seleccionados según cada página
  final List<Color> _selectedIconColors = [
    Colors.blue, // Home - azul
    Colors.blue.shade700, // Quiz - azul oscuro
    Colors.orange.shade700, // Cámara - naranja oscuro
    Colors.green.shade700, // Estudio - verde oscuro
    Colors.purple.shade700, // Desafío - morado oscuro
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color dinámico según la página
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
                Icons.login,
                color: Colors.blue,
              ),
              title: const Text('Iniciar sesión'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navegando a Iniciar sesión'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
