import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class ChallengeController extends ChangeNotifier {
  List<Question> _allQuestions = [];
  Question? _currentQuestion;
  int _streak = 0;
  int _timeLeft = 60; // Tiempo inicial en segundos
  bool _isGameActive = false;
  bool _isGameOver = false;
  bool _isLoading = true;
  Timer? _timer;
  int? _selectedAnswer;
  bool _hasAnswered = false;

  // Getters
  List<Question> get allQuestions => _allQuestions;
  Question? get currentQuestion => _currentQuestion;
  int get streak => _streak;
  int get timeLeft => _timeLeft;
  bool get isGameActive => _isGameActive;
  bool get isGameOver => _isGameOver;
  bool get isLoading => _isLoading;
  int? get selectedAnswer => _selectedAnswer;
  bool get hasAnswered => _hasAnswered;
  
  // Progreso del temporizador (0.0 a 1.0)
  double get timeProgress => _timeLeft / 60.0;

  ChallengeController() {
    _loadQuestions();
  }

  // Cargar preguntas desde el archivo JSON
  Future<void> _loadQuestions() async {
    try {
      _isLoading = true;
      notifyListeners();

      String jsonString = await rootBundle.loadString('Quiz/preguntas_viales.json');
      List<dynamic> jsonList = json.decode(jsonString);
      
      _allQuestions = jsonList.map((json) => Question.fromJson(json)).toList();
      
      print('Cargadas ${_allQuestions.length} preguntas para el desafío');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error cargando preguntas para desafío: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Iniciar el desafío
  void startChallenge() {
    if (_allQuestions.isEmpty) {
      print('No hay preguntas disponibles para el desafío');
      return;
    }

    // Reiniciar estado
    _streak = 0;
    _timeLeft = 60;
    _isGameActive = true;
    _isGameOver = false;
    _selectedAnswer = null;
    _hasAnswered = false;

    // Obtener primera pregunta
    _getRandomQuestion();

    // Iniciar temporizador
    _startTimer();

    print('Desafío iniciado');
    notifyListeners();
  }

  // Obtener una pregunta aleatoria
  void _getRandomQuestion() {
    if (_allQuestions.isNotEmpty) {
      final random = Random();
      _currentQuestion = _allQuestions[random.nextInt(_allQuestions.length)];
      _selectedAnswer = null;
      _hasAnswered = false;
      print('Nueva pregunta: ${_currentQuestion?.question}');
    }
  }

  // Iniciar el temporizador
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && _isGameActive) {
        _timeLeft--;
        notifyListeners();
      } else {
        // Se acabó el tiempo
        _endGame();
      }
    });
  }

  // Seleccionar una respuesta
  void selectAnswer(int optionIndex) {
    if (!_isGameActive || _hasAnswered || _currentQuestion == null) return;

    _selectedAnswer = optionIndex;
    _hasAnswered = true;
    notifyListeners();

    // Verificar respuesta después de un breve delay para mostrar la selección
    Future.delayed(const Duration(milliseconds: 500), () {
      _checkAnswer(optionIndex);
    });
  }

  // Verificar si la respuesta es correcta
  void _checkAnswer(int selectedOption) {
    if (_currentQuestion == null) return;

    bool isCorrect = selectedOption == _currentQuestion!.answerIndex;

    if (isCorrect) {
      // Respuesta correcta
      _streak++;
      _timeLeft += 5; // Añadir 5 segundos
      
      // Limitar el tiempo máximo a 120 segundos para evitar que se acumule demasiado
      if (_timeLeft > 120) {
        _timeLeft = 120;
      }

      print('¡Correcto! Racha: $_streak, Tiempo añadido: +5 seg');

      // Continuar con la siguiente pregunta después de mostrar el resultado
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (_isGameActive) {
          _getRandomQuestion();
          notifyListeners();
        }
      });
    } else {
      // Respuesta incorrecta - terminar el juego
      print('Respuesta incorrecta. Fin del desafío.');
      _endGame();
    }

    notifyListeners();
  }

  // Terminar el juego
  void _endGame() {
    _isGameActive = false;
    _isGameOver = true;
    _timer?.cancel();
    
    print('Desafío terminado. Racha final: $_streak');
    notifyListeners();
  }

  // Reiniciar el desafío
  void resetChallenge() {
    _timer?.cancel();
    _streak = 0;
    _timeLeft = 60;
    _isGameActive = false;
    _isGameOver = false;
    _currentQuestion = null;
    _selectedAnswer = null;
    _hasAnswered = false;
    
    print('Desafío reiniciado');
    notifyListeners();
  }

  // Obtener estadísticas del desafío
  Map<String, dynamic> getChallengeStats() {
    return {
      'streak': _streak,
      'timeElapsed': 60 - _timeLeft,
      'questionsAnswered': _streak,
      'averageTimePerQuestion': _streak > 0 ? (60 - _timeLeft) / _streak : 0,
    };
  }

  // Obtener mensaje de rendimiento basado en la racha
  String getPerformanceMessage() {
    if (_streak == 0) {
      return '¡Inténtalo de nuevo! La práctica hace al maestro.';
    } else if (_streak < 5) {
      return '¡Buen comienzo! Sigue practicando.';
    } else if (_streak < 10) {
      return '¡Excelente! Tienes buenos conocimientos.';
    } else if (_streak < 20) {
      return '¡Impresionante! Eres un experto en señales.';
    } else {
      return '¡INCREÍBLE! Eres un maestro de las señales de tránsito.';
    }
  }

  // Obtener color basado en la racha
  Color getStreakColor() {
    if (_streak < 5) return Colors.orange;
    if (_streak < 10) return Colors.blue;
    if (_streak < 20) return Colors.purple;
    return Colors.green;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
