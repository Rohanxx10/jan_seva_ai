import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../modal/state_central_scheme_model.dart';

Provider SchemeStateDbProvider=Provider((ref)=>SchemeDatabase());

class SchemeDatabase {

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'schemes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE schemes(
          scheme_name TEXT PRIMARY KEY,
          type TEXT,
          eligibility TEXT,
          documents TEXT,
          application_process TEXT,
          website TEXT
        )
      ''');
      },
    );
  }

  Future<void> addScheme(SchemeModel model) async {
    final db = await database;
    await db.insert(
      'schemes',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isPresent(String schemeName) async {
    final db = await database;
    final result = await db.query(
      'schemes',
      where: 'scheme_name = ?',
      whereArgs: [schemeName],
    );
    return result.isNotEmpty;
  }

  Future<void> deleteScheme(String schemeName) async {
    final db = await database;
    await db.delete(
      'schemes',
      where: 'scheme_name = ?',
      whereArgs: [schemeName],
    );
  }

  Future<List<Map<String, dynamic>>> getAllSchemes() async {
    final db = await database;
    final result = await db.query('schemes');
    return result;
  }
}