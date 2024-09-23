import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fullventas_gym_rate/api/api.service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FeedbackCreateScreen extends StatefulWidget {

  const FeedbackCreateScreen({super.key});

  @override
  State<FeedbackCreateScreen> createState() => _FeedbackCreateScreenState();
}

class _FeedbackCreateScreenState extends State<FeedbackCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final ApiService _apiService = ApiService();

  String? _feedbackTypes;
  String? _destinationTypes;
  String? _gymLocations;
  String? _currentUserName;

  File? _image1;
  File? _image2;
  
  

  Map<String, String> _feedbackTypesMap = {};
  Map<String, String> _destinationTypesMap = {};
  Map<String, String> _gymLocationsMap = {};
  Map<String, String> _users = {};

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _fetchCurrentUser();
    _fetchFeedbackTypes();
    _fetchDestinationTypes();
    _fetchLocal();
  }
  

  Future<void> _fetchCurrentUser() async {
    try {
      final users = await _apiService.fetchUsers();
      setState(() {
        _users = {for (var item in users) item['name'].toString() : item['id'].toString() }; 
        if (_users.isNotEmpty) {
          _currentUserName = _currentUserName ?? _users.keys.first;
        }
      });
    } catch (e) {
      print('Error fetching feedback types: $e');
    }
  }

  Future<void> _fetchFeedbackTypes() async {
    try {
      final feedbackTypes = await _apiService.fetchTypeFeedback();
      setState(() {
        _feedbackTypesMap = { for (var item in feedbackTypes) item['description'].toString() : item['id'].toString() };
        if (_feedbackTypesMap.isNotEmpty) {
          _feedbackTypes = _feedbackTypes ?? _feedbackTypesMap.keys.first;
        }
      });
    } catch (e) {
      print('Error fetching feedback types: $e');
    }
  }

  Future<void> _fetchDestinationTypes() async {
    try {
      final destinationTypes = await _apiService.fetchTypeDestination();
      setState(() {
        _destinationTypesMap = {for (var item in destinationTypes) item['description'].toString() : item['id'].toString()};
        if (_destinationTypesMap.isNotEmpty) {
          _destinationTypes = _destinationTypes ?? _destinationTypesMap.keys.first;
        }
      });
    } catch (e) {
      print('Error fetching destination types: $e');
    }
  }

  Future<void> _fetchLocal() async {
    try {
      final local = await _apiService.fetchLocal();
      setState(() {
        _gymLocationsMap = {for (var item in local) item['name'].toString() : item['id'].toString() };
        if (_gymLocationsMap.isNotEmpty) {
          _gymLocations = _gymLocations ?? _gymLocationsMap.keys.first;
        }
      });
    } catch (e) {
      print('Error fetching local: $e');
    }
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
        title: const Text('Agregar Feedback',style: TextStyle(color: Colors.orange),),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha y hora: $formattedDate',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              const Text(
                'GymMuscle',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _feedbackTypes,
                      dropdownColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Feedback',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _feedbackTypes = newValue!;
                        });
                      },
                      items: _feedbackTypesMap.keys.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _destinationTypes,
                      dropdownColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Destinatario',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _destinationTypes = newValue!;
                          if (_destinationTypes != 'Gimnasio') {
                            _gymLocations = null;
                          }
                        });
                      },
                      items: _destinationTypesMap.keys.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_destinationTypes == 'Gimnasio') ...[
                DropdownButtonFormField<String>(
                  value: _gymLocations,
                  dropdownColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Local',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gymLocations = newValue;
                    });
                  },
                  items: _gymLocationsMap.keys.map<DropdownMenuItem<String>>((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Asunto',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                validator: _validateField,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailController,
                maxLines: 5,
                maxLength: 250,
                decoration: InputDecoration(
                  labelText: 'Detalle del feedback',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                validator: _validateField,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickImage(1),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.orange, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _image1 == null
                            ? const Center(child: Text('Imagen 1', style: TextStyle(color: Colors.white)))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.file(_image1!, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickImage(2),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.orange, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _image2 == null
                            ? const Center(child: Text('Imagen 2', style: TextStyle(color: Colors.white)))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.file(_image2!, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed:() async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final userId = _users[_currentUserName!] ?? '';
                      final messageTypeId = _feedbackTypesMap[_feedbackTypes!] ?? '';
                      final recipientTypeId = _destinationTypesMap[_destinationTypes!] ?? '';
                      final gymLocationId = _destinationTypes == 'Gimnasio' ? (_gymLocationsMap[_gymLocations!] ?? '') : '';
                      
                      await _apiService.createFeedback(
                        subject: _subjectController.text,
                        detail: _detailController.text,
                        messageType: messageTypeId,
                        recipientType: recipientTypeId,
                        gymLocation: gymLocationId,
                        image1Url: _image1,
                        image2Url: _image2,
                        timestamp: formattedDate,
                        userId: userId,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text('Enviar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[850],
    );
  }

  String? _validateField(value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
}

