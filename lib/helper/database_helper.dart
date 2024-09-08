import 'dart:io';
import 'package:fullventas_gym_rate/models/feedbackModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'feedbacks.db');
    return await openDatabase(
    path,
    version: 1,
    onCreate:(Database db, int version) async {
      await db.execute(
      '''CREATE TABLE feedbacks(id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT, detail TEXT, messageType TEXT, recipientType TEXT, gymLocation TEXT, image1 TEXT, image2 TEXT, timestamp TEXT)''',
        );
      },
    );
  }

  Future<void> insertFeedback(Feedbacks feedback) async {
    final db = await database;

    final existingFeedbacks = await db.query(
      'feedbacks',
      where: 'timestamp = ?',
      whereArgs: [feedback.timestamp],
    );

    if (existingFeedbacks.isEmpty) {
      await db.insert('feedbacks',
      feedback.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      print('Feed duplicado');
    }
    
  }

  Future<List<Feedbacks>> getFeedbacks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('feedbacks');
    return List.generate(maps.length, (i) {
      return Feedbacks(
        id: maps[i]['id'],
        subject: maps[i]['subject'],
        detail: maps[i]['detail'],
        messageType: maps[i]['messageType'],
        recipientType: maps[i]['recipientType'],
        gymLocation: maps[i]['gymLocation'],
        image1: maps[i]['image1'] != null ? File(maps[i]['image1']) : null,
        image2: maps[i]['image2'] != null ? File(maps[i]['image2']) : null,
        timestamp: maps[i]['timestamp'],
      );
    });
  }
}