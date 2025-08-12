class Question {
  final int id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String category;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      answerIndex: json['answer_index'] as int,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'answer_index': answerIndex,
      'category': category,
    };
  }

  String get correctAnswer => options[answerIndex];
}
