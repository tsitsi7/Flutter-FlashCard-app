class FlashCard {
  final String question;
  final String answer;
  final String topic;
  final List<String> options;

  FlashCard({
    required this.question,
    required this.answer,
    required this.topic,
    required this.options,
  });
  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      question: json['question'],
      answer: json['answer'],
      topic: json['topic'],
      options: List<String>.from(json['options']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'question': question,
      'answer': answer,
      'options': options,
    };
  }
}
