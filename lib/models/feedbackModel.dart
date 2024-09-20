import 'dart:io';

class Feedbacks {
  final int? id;
  final String subject;
  final String detail;
  final String messageType;
  final String recipientType;
  final String? gymLocation;
  final File? image1Url;
  final File? image2Url;
  final String timestamp;
  final String? userId;


  Feedbacks({
    this.id,
    required this.subject,
    required this.detail,
    required this.messageType,
    required this.recipientType,
    this.gymLocation,
    this.image1Url,
    this.image2Url,
    required this.timestamp,
    this.userId,
  });

factory Feedbacks.fromJson(Map<String, dynamic> json) {
    return Feedbacks(
      subject: json['subject'],
      detail: json['detail'],
      messageType: json['messageType'],
      recipientType: json['recipientType'],
      gymLocation: json['gymLocation'],
      image1Url: json['image1Url'],
      image2Url: json['image2Url'],
      timestamp: json['timestamp'],
      userId: json['userId'],
    );
  }
}