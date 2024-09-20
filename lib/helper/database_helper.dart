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
      '''CREATE TABLE feedbacks(id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT, detail TEXT, messageType TEXT, recipientType TEXT, gymLocation TEXT, image1 TEXT, image2 TEXT, timestamp TEXT, 
          user_id INTEGER,
          FOREIGN KEY(user_id) REFERENCES users(id))''',
        );
      await db.execute(
        '''CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT
          )''',
        );
      },
    );
  }

  // Future<void> insertFeedback(Feedbacks feedback) async {
  //   final db = await database;

  //   final existingFeedbacks = await db.query(
  //     'feedbacks',
  //     where: 'timestamp = ?',
  //     whereArgs: [feedback.timestamp],
  //   );

  //   if (existingFeedbacks.isEmpty) {
  //     await db.insert('feedbacks',
  //     feedback.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   } else {
  //     print('Feed duplicado');
  //   }
    
  // }

  Future<void> insertUser(String name, String email) async {
  final db = await database;

  await db.insert(
    'users',
    {'name': name, 'email': email},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
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
        image1Url: maps[i]['image1'] != null ? File(maps[i]['image1']) : null,
        image2Url: maps[i]['image2'] != null ? File(maps[i]['image2']) : null,
        timestamp: maps[i]['timestamp'],
        userId: maps[i]['user_id'],
      );
    });
  }

  Future<String?> getUserNameById(int? userId) async {
  final dbHelper = DatabaseHelper();
  final db = await dbHelper.database;

  final List<Map<String, dynamic>> result = await db.query(
    'users',
    columns: ['name'], 
    where: 'id = ?', 
    whereArgs: [userId],
  );

  if (result.isNotEmpty) {
    return result.first['name'] as String?;
  }
  
  return null;
}
}