import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fullventas_gym_rate/api/api.service.dart';
import 'package:fullventas_gym_rate/models/feedbackGetModel.dart';
import 'package:fullventas_gym_rate/pages/feedback_create_screen.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreen();
}

class _FeedbackListScreen extends State<FeedbackListScreen> {
  final List<FeedbacksGet> _feedbacks = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFeedback();
  }

  Future<void> _fetchFeedback() async {
    setState(() {
    _isLoading = true;
  });
  try {
    List<FeedbacksGet> feedbacks = await _apiService.fetchFeedback();
    setState(() {
        _feedbacks.clear();
        _feedbacks.addAll(feedbacks);
      });
  } catch (e) {
    print('Error fetching feedback: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _showFeedbackDetails(FeedbacksGet feedback) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text(formatTimestamp(feedback.timestamp), style: const TextStyle(color: Colors.black54, fontSize: 12)),
              Text(feedback.userName?? 'No User', style: const TextStyle(color: Colors.black54, fontSize: 12)),
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
                  Text(feedback.description, style: const TextStyle(color: Colors.black54),),
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
                          _buildImageWithShimmer(feedback.image1Url!),
                        if (feedback.image2Url != null)
                          _buildImageWithShimmer(feedback.image2Url!),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(feedback.destinationType ?? 'Desconocido',style: const TextStyle(fontWeight: FontWeight.bold),),
                  if(feedback.destinationType == 'Gimnasio' && feedback.gymLocation != null) ...[
                    RichText(text: TextSpan(
                      text: '${feedback.destinationType}: ', style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold), children: [
                        TextSpan(text:'${feedback.gymLocation}', style: const TextStyle(color: Colors.black54, fontSize: 14) )
                        ]
                      )
                    )
                  ] else if(feedback.destinationType == 'Aplicacion') ...[
                    RichText(text: TextSpan(
                      text: "Para: ", style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16), children: [
                        TextSpan(text: '${feedback.destinationType} ', style: const TextStyle(color: Colors.black54, fontSize: 14))])
                        )
                  ]                 
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
            TextButton(onPressed: () async{
              bool? confirm = await dialogConfirmation(context) ;
              if (confirm == true) {
              try {
                      await _apiService.deleteFeedback(feedback.id);
                      Navigator.of(context).pop();
                      setState(() {
                        _feedbacks.remove(feedback);
                      });
                    } catch (e) {
                      print('Error deleting feedback: $e');
                    }
              }
            },
            child: const Text('Eliminar')
            )
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
        child: _isLoading ? const Center(child: CircularProgressIndicator())
        : Column(
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
                        feedback.feedbackType == 'Reconocimiento'
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
                            feedback.description,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
                          ),
                          if(feedback.destinationType == 'Gimnasio' && feedback.gymLocation != null) ...[
                            Text(
                              'Ubicacion: ${feedback.gymLocation}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(formatTimestamp(feedback.timestamp))
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
                    builder: (context) => const FeedbackCreateScreen(),
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

  Widget _buildImageWithShimmer(String imageUrl) {
  return FutureBuilder(
    future: Future.wait([
      precacheImage(NetworkImage(imageUrl), context),
      Future.delayed(const Duration(milliseconds: 0)),
    ]),
     builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        );
      } else {
        return Shimmer.fromColors( 
        baseColor: Colors.red[300]!, 
        highlightColor: Colors.red[100]!,
        child: Container(
          width: double.infinity,
          height: 200,
          color: Colors.white,),
          );
        }
      }
    );
  }
}


Future<bool?> dialogConfirmation(BuildContext context) {
    return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirma..', style: TextStyle(color: Colors.grey, fontSize: 16),),
                  content: const Text("Estas seguro que desea eliminar este feedback?"),
                  actions: <Widget> [
                    TextButton(onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                    ),
                    TextButton(onPressed: () => Navigator.of(context).pop(true), 
                    child: const Text('Eliminar'))
                  ],
                );
              }
            );
  }

String formatTimestamp(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}