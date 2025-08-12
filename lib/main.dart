import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:pry_traffic_signs/controllers/auth_controller.dart';
import 'package:pry_traffic_signs/controllers/quiz_controller.dart';
import 'package:pry_traffic_signs/controllers/challenge_controller.dart';
import 'package:pry_traffic_signs/views/main_navigation_widget.dart';
import 'package:pry_traffic_signs/views/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializar Firebase con configuración específica
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('Firebase inicializado correctamente');
  } catch (e) {
    print('Error inicializando Firebase: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => QuizController()),
        ChangeNotifierProvider(create: (context) => ChallengeController()),
      ],
      child: MaterialApp(
        title: 'Señales de tráfico',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthWrapper(),
        routes: {
          '/home': (context) => const MainNavigationWidget(),
          '/login': (context) => const LoginPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        if (authController.isLoggedIn) {
          return const MainNavigationWidget();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
