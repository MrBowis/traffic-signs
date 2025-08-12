import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes agregar navegación a diferentes páginas según el índice
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
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
            icon: Icon(Icons.psychology),
            label: 'Desafío',
          ),
        ],
      ),
    );
  }
}

// Widget separado para el contenido de la página principal
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Gradient Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Señales de Tránsito',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Aprende y practica las normas viales',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48), // Balance del botón menú
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Descripción de la aplicación
                const Text(
                  '¿Qué es esta aplicación?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Una aplicación educativa diseñada para ayudarte a aprender y dominar las señales de tránsito y las normas viales de manera interactiva y divertida.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Título de funciones
                const Text(
                  'Funciones incluidas:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Lista de funciones
                _buildFeatureCard(
                  icon: Icons.quiz,
                  title: 'Quiz Interactivo',
                  description: 'Pon a prueba tus conocimientos con cuestionarios de 10 preguntas aleatorias sobre señales de tránsito.',
                  color: Colors.purple,
                ),
                const SizedBox(height: 16),
                
                _buildFeatureCard(
                  icon: Icons.camera_alt,
                  title: 'Reconocimiento por Cámara',
                  description: 'Utiliza la cámara para identificar señales de tránsito en tiempo real y aprende sobre ellas.',
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                
                _buildFeatureCard(
                  icon: Icons.psychology,
                  title: 'Desafíos y Práctica',
                  description: 'Ejercicios especializados para reforzar tu aprendizaje y prepararte para exámenes viales.',
                  color: Colors.red,
                ),
                const SizedBox(height: 30),
                
                // Información adicional
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.blue,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '¡Mejora tu seguridad vial!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Conocer las señales de tránsito es fundamental para la seguridad de todos en las vías. Esta aplicación te ayuda a convertirte en un conductor más responsable.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
