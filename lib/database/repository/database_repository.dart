import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';



final DbHelperProvider = Provider((ref) => DbHelper());

class DbHelper {
  static const String tableName = 'schemes';

  static const String columnId = 'id';
  static const String columnDocumentName = 'document_name';
  static const String columnType = 'type';
  static const String columnEligibility = 'eligiblity';
  static const String columnDocuments = 'documents';
  static const String columnApplicationProcess = 'application_process';
  static const String columnWebsite = 'website';
  static const String columnIsSaved = 'is_saved';

  Database? _db;

  Future<Database> getDb() async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'scheme.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDocumentName TEXT,
            $columnType TEXT,
            $columnEligibility TEXT,
            $columnDocuments TEXT,
            $columnApplicationProcess TEXT,
            $columnWebsite TEXT,
            $columnIsSaved INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    try {
      final db = await getDb();
      return await db.query(tableName, orderBy: '$columnId DESC');
    } catch (e) {
      debugPrint('DB error getAllNotes: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSaved() async {
    try {
      final db = await getDb();
      return await db.query(tableName, orderBy: '$columnId DESC',where: "$columnIsSaved=?",whereArgs: [1]);
    } catch (e) {
      debugPrint('DB error getAllNotes: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSchemesByType(String type) async {
    try {
      final db = await getDb();
      return await db.query(
        tableName,
        where: '$columnType = ?',
        whereArgs: [type],
        orderBy: '$columnId DESC',
      );
    } catch (e) {
      debugPrint('DB error getSchemesByType: $e');
      return [];
    }
  }

  Future<bool> add({
    required String document_name,
    required String type,
    required String eligiblity,
    required String documents,
    required String application_process,
    required String website,
    int is_saved = 0,
  }) async {
    try {
      final db = await getDb();
      await db.insert(tableName, {
        columnDocumentName: document_name,
        columnType: type,
        columnEligibility: eligiblity,
        columnDocuments: documents,
        columnApplicationProcess: application_process,
        columnWebsite: website,
        columnIsSaved: is_saved,
      });
      return true;
    } catch (e) {
      debugPrint('❌ DB Insert Error: $e');
      return false;
    }
  }

  Future<bool> saved(String documentName)async{
    
    try{
      final db=await getDb();
      final result=await db.update(tableName, {
        columnIsSaved:1
      },where: "$columnDocumentName=?",whereArgs: [documentName]);

      return result>0;

    }catch(e){
      debugPrint('DB error saved: $e');
      return false;
    }

  }
  

  Future<bool> isPresent(String keyword) async {
    try {
      final db = await getDb();
      final result = await db.query(
        tableName,
        where: '$columnDocumentName = ?',
        whereArgs: [keyword],
      );
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('DB error isPresent: $e');
      return false;
    }
  }


}
