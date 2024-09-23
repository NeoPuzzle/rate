class FeedbacksGet {
  final String id; 
  final String subject;
  final String description;
  final String timestamp; 
  final String? image1Url;
  final String? image2Url;
  final String? userId;
  final String? userName;
  final String? gymLocation;
  final String? feedbackType;
  final String? destinationType;
  

  FeedbacksGet({
    required this.id,
    required this.subject,
    required this.description,
    required this.timestamp,
    this.image1Url,
    this.image2Url,
    this.userId,
    this.userName,
    this.gymLocation,
    this.feedbackType,
    this.destinationType
  });

  factory FeedbacksGet.fromJson(Map<String, dynamic> json) {
    return FeedbacksGet(
      id: json['id'],
      subject: json['subject'],
      description: json['description'], 
      timestamp: json['date'], 
      image1Url: json['image1Url'],
      image2Url: json['image2Url'],
      userId: json['user']?['name'], 
      userName: json['user']?['name'] ?? '',
      gymLocation: json['local']?['name'], 
      feedbackType: json['type']?['description'],
      destinationType: json['destination']?['description']
    );
  }
}

