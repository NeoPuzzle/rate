import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fullventas_gym_rate/models/feedbackModel.dart';

class RecognitionSuggestionsScreen extends StatefulWidget {
  final Function(Feedbacks) onFeedbackSubmitted;

  const RecognitionSuggestionsScreen({super.key, required this.onFeedbackSubmitted});

  @override
  State<RecognitionSuggestionsScreen> createState() => _RecognitionSuggestionsScreenState();
}

class _RecognitionSuggestionsScreenState extends State<RecognitionSuggestionsScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  String _messageType = 'Reconocimiento';
  String _recipientType = 'Aplicación';
  File? _image1;
  File? _image2;

  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _image2 = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lima = tz.getLocation('America/Lima');
    final now = tz.TZDateTime.now(lima);
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Text('SmartFitCV', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _messageType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _messageType = newValue!;
                      });
                    },
                    items: <String>['Reconocimiento', 'Sugerencias']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: _recipientType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _recipientType = newValue!;
                      });
                    },
                    items: <String>['Aplicación', 'Gimnasio']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Asunto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Detalle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(1),
                    child: Container(
                        height: 100,
                        color:const Color(0xFF8BD7D2),
                        child: _image1 == null ? const Center(child: Text('Imagen 1')) : Image.file(_image1!),
                      ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(2),
                    child: Container(
                        height: 100,
                        color:const Color(0xFF8BD7D2),
                        child: _image2 == null ? const Center(child: Text('Imagen 2')) : Image.file(_image2!),
                      ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final feedback = Feedbacks(
                  subject: _subjectController.text,
                  detail: _detailController.text,
                  messageType: _messageType,
                  recipientType: _recipientType,
                  image1: _image1,
                  image2: _image2,
                  timestamp: formattedDate,
                );

                widget.onFeedbackSubmitted(feedback);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BD9D),
              ),
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}