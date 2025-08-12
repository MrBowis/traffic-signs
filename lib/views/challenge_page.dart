import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/challenge_controller.dart';
import '../models/question_model.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeController>(
      builder: (context, challengeController, child) {
        if (challengeController.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando desafío...'),
              ],
            ),
          );
        }

        if (!challengeController.isGameActive && !challengeController.isGameOver) {
          return _buildWelcomeScreen(context, challengeController);
        }

        if (challengeController.isGameOver) {
          return _buildGameOverScreen(context, challengeController);
        }

        return _buildChallengeScreen(context, challengeController);
      },
    );
  }

  Widget _buildWelcomeScreen(BuildContext context, ChallengeController challengeController) {
    return Column(
      children: [
        // Header personalizado
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.red],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
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
                    child: Text(
                      'Modo Desafío',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
        // Contenido principal con scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bolt,
                  size: 120,
                  color: Colors.purple,
                ),
                const SizedBox(height: 24),
                const Text(
                  '¡Racha Perfecta!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Responde correctamente todas las preguntas que puedas antes de que se acabe el tiempo.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Reglas del Desafío',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildRuleItem('⏰', 'Tiempo inicial: 60 segundos'),
                        _buildRuleItem('✅', 'Respuesta correcta: +5 segundos'),
                        _buildRuleItem('❌', 'Respuesta incorrecta: FIN DEL JUEGO'),
                        _buildRuleItem('🔥', 'Objetivo: Máxima racha posible'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => challengeController.startChallenge(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('¡Comenzar Desafío!'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRuleItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeScreen(BuildContext context, ChallengeController challengeController) {
    final question = challengeController.currentQuestion!;
    final selectedAnswer = challengeController.selectedAnswer;
    final hasAnswered = challengeController.hasAnswered;

    return Column(
      children: [
        // Header con temporizador y racha
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.red],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Racha
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              '${challengeController.streak}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tiempo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: challengeController.timeLeft <= 10 ? Colors.red : Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${challengeController.timeLeft}s',
                              style: TextStyle(
                                color: challengeController.timeLeft <= 10 ? Colors.red : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Barra de progreso del tiempo
                  LinearProgressIndicator(
                    value: challengeController.timeProgress,
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      challengeController.timeLeft <= 10 ? Colors.red : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Contenido de la pregunta con scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categoría
                Chip(
                  label: Text(question.category),
                  backgroundColor: Colors.purple.shade100,
                ),
                const SizedBox(height: 16),
                // Pregunta
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Opciones
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedAnswer == index;
                    final isCorrect = index == question.answerIndex;
                    
                    Color? backgroundColor;
                    Color? borderColor;
                    
                    if (hasAnswered) {
                      if (isSelected) {
                        backgroundColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
                        borderColor = isCorrect ? Colors.green : Colors.red;
                      } else if (isCorrect) {
                        backgroundColor = Colors.green.shade50;
                        borderColor = Colors.green;
                      }
                    } else if (isSelected) {
                      backgroundColor = Colors.purple.shade50;
                      borderColor = Colors.purple;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: isSelected ? 4 : 1,
                        child: InkWell(
                          onTap: hasAnswered ? null : () => challengeController.selectAnswer(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: backgroundColor,
                              border: borderColor != null
                                  ? Border.all(color: borderColor, width: 2)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: borderColor ?? Colors.grey.shade300,
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D
                                    style: TextStyle(
                                      color: borderColor != null ? Colors.white : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    question.options[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: borderColor,
                                    ),
                                  ),
                                ),
                                if (hasAnswered && isCorrect)
                                  const Icon(Icons.check_circle, color: Colors.green),
                                if (hasAnswered && isSelected && !isCorrect)
                                  const Icon(Icons.cancel, color: Colors.red),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameOverScreen(BuildContext context, ChallengeController challengeController) {
    final stats = challengeController.getChallengeStats();
    final performanceMessage = challengeController.getPerformanceMessage();
    final streakColor = challengeController.getStreakColor();

    return Column(
      children: [
        // Header de fin de juego
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.flag,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Fin del Desafío!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    performanceMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Estadísticas del desafío con scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Racha principal
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: streakColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: streakColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: streakColor,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${challengeController.streak}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: streakColor,
                        ),
                      ),
                      Text(
                        'Racha máxima',
                        style: TextStyle(
                          fontSize: 16,
                          color: streakColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Estadísticas detalladas
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatRow('Preguntas respondidas', '${stats['questionsAnswered']}'),
                        const Divider(),
                        _buildStatRow('Tiempo total', '${stats['timeElapsed'].toInt()} segundos'),
                        const Divider(),
                        _buildStatRow(
                          'Tiempo promedio', 
                          '${stats['averageTimePerQuestion'].toStringAsFixed(1)} seg/pregunta'
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Botón para reiniciar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => challengeController.resetChallenge(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Intentar de Nuevo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
