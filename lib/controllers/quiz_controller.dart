import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuizController extends ChangeNotifier {
  List<Question> _allQuestions = [];
  List<Question> _currentQuizQuestions = [];
  int _currentQuestionIndex = 0;
  Map<int, int> _userAnswers = {};
  bool _isLoading = true;
  bool _quizCompleted = false;
  int _score = 0;

  // Getters
  List<Question> get allQuestions => _allQuestions;
  List<Question> get currentQuizQuestions => _currentQuizQuestions;
  Question? get currentQuestion => _currentQuizQuestions.isNotEmpty 
      ? _currentQuizQuestions[_currentQuestionIndex] 
      : null;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _currentQuizQuestions.length;
  bool get isLoading => _isLoading;
  bool get quizCompleted => _quizCompleted;
  int get score => _score;
  int? get selectedAnswer => _userAnswers[currentQuestion?.id];
  bool get isLastQuestion => _currentQuestionIndex == _currentQuizQuestions.length - 1;
  
  // Progreso del quiz
  double get progress => _currentQuizQuestions.isEmpty 
      ? 0.0 
      : (_currentQuestionIndex + 1) / _currentQuizQuestions.length;

  QuizController() {
    _loadQuestions();
  }

  // Cargar preguntas desde el archivo JSON
  Future<void> _loadQuestions() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Cargar el archivo JSON desde assets
      String jsonString = await rootBundle.loadString('Quiz/preguntas_viales.json');
      List<dynamic> jsonList = json.decode(jsonString);
      
      _allQuestions = jsonList.map((json) => Question.fromJson(json)).toList();
      
      print('Cargadas ${_allQuestions.length} preguntas del archivo JSON');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error cargando preguntas: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Iniciar un nuevo quiz con 10 preguntas aleatorias
  void startNewQuiz() {
    if (_allQuestions.isEmpty) {
      print('No hay preguntas disponibles');
      return;
    }

    // Reiniciar estado
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _quizCompleted = false;
    _score = 0;

    // Seleccionar 10 preguntas aleatorias
    final random = Random();
    final shuffledQuestions = List<Question>.from(_allQuestions)..shuffle(random);
    _currentQuizQuestions = shuffledQuestions.take(10).toList();

    print('Quiz iniciado con ${_currentQuizQuestions.length} preguntas');
    notifyListeners();
  }

  // Seleccionar una respuesta
  void selectAnswer(int optionIndex) {
    if (currentQuestion != null && !_quizCompleted) {
      _userAnswers[currentQuestion!.id] = optionIndex;
      notifyListeners();
    }
  }

  // Ir a la siguiente pregunta
  void nextQuestion() {
    if (_currentQuestionIndex < _currentQuizQuestions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  // Ir a la pregunta anterior
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  // Ir a una pregunta específica
  void goToQuestion(int index) {
    if (index >= 0 && index < _currentQuizQuestions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  // Finalizar el quiz y calcular resultados
  void finishQuiz() {
    _calculateScore();
    _quizCompleted = true;
    notifyListeners();
  }

  // Calcular el puntaje
  void _calculateScore() {
    _score = 0;
    for (Question question in _currentQuizQuestions) {
      int? userAnswer = _userAnswers[question.id];
      if (userAnswer != null && userAnswer == question.answerIndex) {
        _score++;
      }
    }
  }

  // Obtener resultados detallados
  List<Map<String, dynamic>> getDetailedResults() {
    List<Map<String, dynamic>> results = [];
    
    for (Question question in _currentQuizQuestions) {
      int? userAnswer = _userAnswers[question.id];
      bool isCorrect = userAnswer != null && userAnswer == question.answerIndex;
      
      results.add({
        'question': question,
        'userAnswer': userAnswer,
        'userAnswerText': userAnswer != null ? question.options[userAnswer] : 'Sin respuesta',
        'correctAnswer': question.correctAnswer,
        'isCorrect': isCorrect,
      });
    }
    
    return results;
  }

  // Verificar si todas las preguntas están respondidas
  bool get allQuestionsAnswered {
    return _currentQuizQuestions.every((question) => _userAnswers.containsKey(question.id));
  }

  // Obtener estadísticas del quiz
  Map<String, dynamic> getQuizStats() {
    return {
      'totalQuestions': _currentQuizQuestions.length,
      'answeredQuestions': _userAnswers.length,
      'score': _score,
      'percentage': _currentQuizQuestions.isEmpty ? 0 : (_score / _currentQuizQuestions.length * 100).round(),
    };
  }

  // Reiniciar el controlador
  void reset() {
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _quizCompleted = false;
    _score = 0;
    _currentQuizQuestions.clear();
    notifyListeners();
  }
}
