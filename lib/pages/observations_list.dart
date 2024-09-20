import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fullventas_gym_rate/helper/database_helper.dart';
import 'package:fullventas_gym_rate/models/feedbackModel.dart';
import 'package:fullventas_gym_rate/pages/observation_create_screen.dart';
class RecognitionSuggestionsListScreen extends StatefulWidget {
  const RecognitionSuggestionsListScreen({super.key});

  @override
  State<RecognitionSuggestionsListScreen> createState() => _RecognitionSuggestionsListScreen();
}

class _RecognitionSuggestionsListScreen extends State<RecognitionSuggestionsListScreen> {
  final List<Feedbacks> _feedbacks = [];
  // final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // _loadFeedbacks();
  }

  void _loadFeedbacks() async {
    final dbHelper = DatabaseHelper();
    final feedbacksDB = await dbHelper.getFeedbacks();
    setState(() {
      _feedbacks.clear();
      _feedbacks.addAll(feedbacksDB);
    });
  }

  void _addFeedback(Feedbacks feedback) {
    setState(() {
      _feedbacks.add(feedback);
    });
  }

  Future<void> _showFeedbackDetails(Feedbacks feedback) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text(feedback.timestamp, style: const TextStyle(color: Colors.deepPurple, fontSize: 12)),
              Text(feedback.userId!, style: const TextStyle(color: Colors.deepPurple, fontSize: 12)),
            ],
          ) ,          
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(feedback.subject, style: const TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold),),
                  Text(feedback.detail),
                  const SizedBox(height: 20),
                  if (feedback.image1Url != null || feedback.image2Url != null) ...[
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16/9,
                        viewportFraction: 0.9,
                      ),
                      items: [
                        if (feedback.image1Url != null)
                          Image.file(
                            feedback.image1Url!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200.0,
                          ),
                        if (feedback.image2Url != null)
                          Image.file(
                            feedback.image2Url!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200.0,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(feedback.messageType,style: const TextStyle(fontWeight: FontWeight.bold),),
                  Text(feedback.recipientType),
                  if(feedback.recipientType == 'Gimnasio' && feedback.gymLocation != null) ...[
                    Text('${feedback.gymLocation}'),
                  ],                  
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
                        color: Colors.orange[700],
                        ),
                      title: Text(
                        feedback.subject,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feedback.detail,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
                          ),
                          if(feedback.recipientType == 'Gimnasio' && feedback.gymLocation != null) ...[
                            Text(
                              'Ubicacion: ${feedback.gymLocation}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(feedback.timestamp)
                        ],
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
                backgroundColor: Colors.orange,
              ), 
              child: Text('Agregar feedback', style: TextStyle(color: Colors.grey[900]),),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey[900],
    );
  }
}
