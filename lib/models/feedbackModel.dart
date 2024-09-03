import 'dart:io';

class Feedbacks {
  final String subject;
  final String detail;
  final String messageType;
  final String recipientType;
  final File? image1;
  final File? image2;
  final String timestamp;


  Feedbacks({
    required this.subject,
    required this.detail,
    required this.messageType,
    required this.recipientType,
    this.image1,
    this.image2,
    required this.timestamp,
  });
}