import 'package:flutter/material.dart';
import 'package:flashcards_quiz/models/flashcard.dart';

class EditFlashcardScreen extends StatefulWidget {
  final FlashCard flashCard;

  EditFlashcardScreen({required this.flashCard});

  @override
  _EditFlashcardScreenState createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.flashCard.question);
    _answerController = TextEditingController(text: widget.flashCard.answer);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question:'),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Enter question',
              ),
            ),
            SizedBox(height: 16),
            Text('Answer:'),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Enter answer',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save changes and pop the screen
                _saveChanges();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final newQuestion = _questionController.text;
    final newAnswer = _answerController.text;

    // Create a new FlashCard object with updated values
    final updatedFlashCard = FlashCard(
      question: newQuestion,
      answer: newAnswer,
      topic: widget.flashCard.topic,
      options: widget.flashCard.options,
    );

    // You can then save the updated flashcard data to local storage or wherever it's stored

    // Close the edit screen
    Navigator.of(context).pop(updatedFlashCard);
  }
}
