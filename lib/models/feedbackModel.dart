import 'dart:io';

class Feedbacks {
  final int? id;
  final String subject;
  final String detail;
  final String messageType;
  final String recipientType;
  final String? gymLocation;
  final File? image1;
  final File? image2;
  final String timestamp;
  final int? userId;


  Feedbacks({
    this.id,
    required this.subject,
    required this.detail,
    required this.messageType,
    required this.recipientType,
    this.gymLocation,
    this.image1,
    this.image2,
    required this.timestamp,
    this.userId,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'subject': subject,
      'detail': detail,
      'messageType': messageType,
      'recipientType': recipientType,
      'gymLocation': gymLocation,
      'image1': image1?.path,
      'image2': image2?.path,
      'timestamp': timestamp,
      'user_id': userId,
    };
  }

  factory Feedbacks.fromMap(Map<String, dynamic> map) {
    return Feedbacks(
      id: map['id'],
      subject: map['subject'],
      detail: map['detail'],
      messageType: map['messageType'],
      recipientType: map['recipientType'],
      gymLocation: map['gymLocation'],
      image1: map['image1'] != null ? File(map['image1']) : null,
      image2: map['image2'] != null ? File(map['image2']) : null,
      timestamp: map['timestamp'],
    );
  }
}