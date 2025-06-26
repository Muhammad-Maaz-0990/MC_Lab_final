import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'event_model.dart';
import 'registration_model.dart';

class DBHelper {
  static Database? _db;
  static const String eventTable = 'events';
  static const String registrationTable = 'registrations';

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'event_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $eventTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            date TEXT,
            time TEXT,
            venue TEXT,
            description TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $registrationTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT,
            email TEXT,
            eventId INTEGER,
            FOREIGN KEY(eventId) REFERENCES $eventTable(id)
          )
        ''');
      },
    );
  }

  static Future<int> insertEvent(Event event) async {
    final dbClient = await db;
    return await dbClient.insert(eventTable, event.toMap());
  }

  static Future<List<Event>> getEvents() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(eventTable, orderBy: 'date ASC');
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  static Future<int> updateEvent(Event event) async {
    final dbClient = await db;
    return await dbClient.update(eventTable, event.toMap(), where: 'id = ?', whereArgs: [event.id]);
  }

  static Future<int> deleteEvent(int id) async {
    final dbClient = await db;
    return await dbClient.delete(eventTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> insertRegistration(Registration reg) async {
    final dbClient = await db;
    return await dbClient.insert(registrationTable, reg.toMap());
  }

  static Future<List<Registration>> getRegistrationsForEvent(int eventId) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      registrationTable,
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    return List.generate(maps.length, (i) => Registration.fromMap(maps[i]));
  }

  static Future<List<Event>> getEventsDescending() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(eventTable, orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }

  static Future<List<Event>> searchEventsByDate(String date) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      eventTable,
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Event.fromMap(maps[i]));
  }
} 