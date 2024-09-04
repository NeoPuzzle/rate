import 'package:carousel_slider/carousel_slider.dart';
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

  void _showFeedbackDetails(Feedbacks feedback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feedback.subject),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(feedback.detail),
                  const SizedBox(height: 20),
                  if (feedback.image1 != null || feedback.image2 != null) ...[
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        aspectRatio: 16/9,
                        viewportFraction: 0.9,
                      ),
                      items: [
                        if (feedback.image1 != null)
                          Image.file(
                            feedback.image1!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200.0,
                          ),
                        if (feedback.image2 != null)
                          Image.file(
                            feedback.image2!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200.0,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(feedback.messageType),
                  Text('Para: ${feedback.recipientType}'),
                  Text('Date: ${feedback.timestamp}'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: Icon(
                        feedback.messageType == 'Reconocimiento'
                          ? Icons.thumb_up
                          : Icons.feedback,
                        color: Colors.blue[700],
                        ),
                      title: Text(
                        feedback.subject,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        feedback.detail,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
                      onTap: () {
                        _showFeedbackDetails(feedback);
                      },
                    ),
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
              child: const Text('Agregar feedback'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey[100],
    );
  }
}
