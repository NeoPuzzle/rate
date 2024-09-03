import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFitCV'),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                },              
              )
            )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF49C6E5),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Reconocimiento y Sugerencias'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecognitionSuggestionsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Pantalla Principal')),
    );
  }
}

class RecognitionSuggestionsScreen extends StatefulWidget {
  const RecognitionSuggestionsScreen({super.key});

  @override
  State<RecognitionSuggestionsScreen> createState() => _RecognitionSuggestionsScreenState();
}

class _RecognitionSuggestionsScreenState extends State<RecognitionSuggestionsScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  String _messageType = 'Reconocimiento';
  String _recipientType = 'Aplicación';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento y Sugerencias'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${DateTime.now().toLocal()}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                  child: Container(
                    height: 100,
                    color:const Color(0xFF8BD7D2),
                    child: const Center(child: Text('Imagen 1')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 100,
                    color: const Color(0xFF8BD7D2),
                    child: const Center(child: Text('Imagen 2')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción del botón de enviar
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
