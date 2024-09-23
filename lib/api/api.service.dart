import 'dart:convert';
import 'dart:io';
import 'package:fullventas_gym_rate/models/feedbackGetModel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // final String baseUrl = "http://10.0.2.2:3000";
  final String baseUrl = "https://feedback-aro1.onrender.com";

  Future<List< dynamic>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      throw e;
    }
  }

  Future<List< dynamic>> fetchLocal() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/local'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load local');
      }
    } catch (e) {
      print('Error fetching local: $e');
      throw e;
    }
  }

  Future<List< dynamic>> fetchTypeDestination() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/destination-type'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load destination-type');
      }
    } catch (e) {
      print('Error fetching destination-type: $e');
      throw e;
    }
  }

  Future<List< dynamic>> fetchTypeFeedback() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/feedback-type'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load feedback-type');
      }
    } catch (e) {
      print('Error fetching feedback-type: $e');
      throw e;
    }
  }

  Future<List<FeedbacksGet>> fetchFeedback() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/feedbacks'),
    );
    
    if (response.statusCode == 200) {
      List<dynamic> feedbackList = jsonDecode(response.body);
      return feedbackList.map((feedback) => FeedbacksGet.fromJson(feedback)).toList().cast<FeedbacksGet>();
    } else {
      throw Exception('Failed to load feedback');
    }
  } catch (e) {
    print('Error fetching feedback: $e');
    throw e;
  }
}

Future<void> deleteFeedback(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/feedbacks/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete feedback');
    }
  }


  Future<void> createFeedback({
    required String subject,
    required String detail,
    required String messageType,
    required String recipientType,
    String? gymLocation,
    File? image1Url,
    File? image2Url,
    required String timestamp,
    String? userId,
  }) async {
    var uri = Uri.parse('$baseUrl/feedbacks');
    var request = http.MultipartRequest('POST', uri);

    request.fields['subject'] = subject;
    request.fields['description'] = detail;
    request.fields['typeId'] = messageType;
    request.fields['destinationId'] = recipientType;
    if (gymLocation != null) request.fields['localId'] = gymLocation;
    request.fields['date'] = timestamp;
    if (userId != null) request.fields['userId'] = userId.toString();

    if (image1Url != null) {
        request.files.add(await http.MultipartFile.fromPath('files', image1Url.path));
    }

    if (image2Url != null) {
        request.files.add(await http.MultipartFile.fromPath('files', image2Url.path));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        print('Feedback enviado exitosamente');
      } else {
        print('Error al enviar feedback: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al enviar feedback: $e');
    }
  }

  
}