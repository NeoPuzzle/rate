import 'package:flutter/material.dart';
import 'package:fullventas_gym_rate/models/feedbackModel.dart';
import 'package:fullventas_gym_rate/pages/observation_create_screen.dart';

class RecognitionSuggestionsListScreen extends StatefulWidget {
  const RecognitionSuggestionsListScreen({super.key});

  @override
  State<RecognitionSuggestionsListScreen> createState() => _RecognitionSuggestionsListScreen();
}

class _RecognitionSuggestionsListScreen extends State<RecognitionSuggestionsListScreen> {
    final List<Feedbacks> _feedbacks = [];

    void _addFeedback(Feedbacks feedback) {
      setState(() {
        _feedbacks.add(feedback);
      });
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _feedbacks.length,
                itemBuilder: (context, index) {
                  final feedback = _feedbacks[index];
                  return ListTile(
                    title: Text(feedback.subject),
                    subtitle: Text(feedback.detail),
                    onTap: () {

                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecognitionSuggestionsScreen(
                      onFeedbackSubmitted: _addFeedback,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BD9D),
              ), 
              child: const Text('Agregar feedback'))
          ],
        ),
        ),
    );
  }
}