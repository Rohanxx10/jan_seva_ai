import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/database_repository.dart';



final dbControllerProvider = Provider<DbController>((ref) {
  final dbHelper = ref.watch(DbHelperProvider);
  return DbController(dbHelper: dbHelper);
});

class DbController {
  final DbHelper dbHelper;

  DbController({required this.dbHelper});

  Future<bool> add(
      {
    required String document_name,
    required String type,
    required String eligiblity,
    required String documents,
    required String application_process,
    required String website,
    int is_saved = 0,
  }
  ) async {
    try {
      return await dbHelper.add(
        document_name: document_name,
        type: type,
        eligiblity: eligiblity,
        documents: documents,
        application_process: application_process,
        website: website,
        is_saved: is_saved,
      );
    } catch (e) {
      debugPrint('Error adding data: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllDocumentNames() async {
    final data = await dbHelper.getAllNotes();
    return data; // Return full note info
  }


  Future<bool> saved(String documentName)async{
    return await dbHelper.saved(documentName);
  }

  Future<List<Map<String, dynamic>>> getSaved() async {
    final data = await dbHelper.getAllNotes();
    return data; // Return full note info
  }


  Future<List<Map<String, dynamic>>> getSchemesByType(String type) {
    return dbHelper.getSchemesByType(type);
  }

  Future<bool> isPresent(String keyword) {
    return dbHelper.isPresent(keyword);
  }
}
