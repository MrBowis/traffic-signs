import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Aprende señales de tránsito',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Statistics Cards
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '25',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Señales aprendidas',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.percent,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '87%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Precisión',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Cómo quieres estudiar?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Elige tu método de aprendizaje favorito',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    // Study Method Cards
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.quiz, color: Colors.blue, size: 30),
                        title: const Text('Práctica con Quiz'),
                        subtitle: const Text(
                          'Responde preguntas sobre señales de tránsito',
                        ),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.camera_alt,
                          color: Colors.orange,
                          size: 30,
                        ),
                        title: const Text('Reconocimiento Visual'),
                        subtitle: const Text(
                          'Identifica señales usando la cámara',
                        ),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.book,
                          color: Colors.green,
                          size: 30,
                        ),
                        title: const Text('Estudio Guiado'),
                        subtitle: const Text(
                          'Aprende paso a paso con lecciones',
                        ),
                        onTap: () {},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.psychology,
                          color: Colors.purple,
                          size: 30,
                        ),
                        title: const Text('Modo Desafío'),
                        subtitle: const Text('Pon a prueba tus conocimientos'),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
