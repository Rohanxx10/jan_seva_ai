import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../modal/state_central_scheme_model.dart';
import 'dbms_repo.dart'; // Assuming SchemeStateDbProvider is defined here

final schemeRepoStateCentralProvider = Provider<SchemeRepo>((ref) => SchemeRepo());

class SchemeRepo {
  Future<void> syncSchemesFromFirestoreState(String state, WidgetRef ref) async {
    try {
      final db = ref.watch(SchemeStateDbProvider);

      // Fetch all documents from Firestore under: State/{state}/Schemes
      final querySnapshot = await FirebaseFirestore.instance
          .collection('State')
          .doc(state)
          .collection('Schemes')
          .get();

      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxx");

      // Ensure rawSchemes is correctly typed.
      // Assuming getAllSchemes returns List<Map<String, dynamic>>
      final List<Map<String, dynamic>> rawSchemes = await db.getAllSchemes();

      final localSchemes = rawSchemes.map((e) {
        // Explicitly cast 'e' to Map<String, dynamic> if it's not already.
        // This makes sure SchemeModel.fromMap receives the expected type.
        return SchemeModel.fromMap(e);
      }).toList();

      final Set<String> localNames = localSchemes
          .map((e) => e.schemeName.trim())
          .where((name) => name.isNotEmpty)
          .toSet();

      final Set<String> firestoreNames = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        print(data);

        final scheme = SchemeModel(
          schemeName: (data['scheme_name'] ?? '').toString().trim(),
          type: (data['type'] ?? '').toString(),
          eligibility: (data['eligibility'] ?? '').toString(),
          documentsRequired: (data['documents'] ?? '').toString(),
          applicationProcess: (data['application_process'] ?? '').toString(),
          officialWebsite: (data['website'] ?? '').toString(),
        );

        firestoreNames.add(scheme.schemeName);

        final exists = await db.isPresent(scheme.schemeName);

        if (!exists) {
          await db.addScheme(scheme);
          print("xxxxxxxxxxx");
        }
        final l=await db.getAllSchemes();
        print(l);

      }


      // Delete local schemes that no longer exist in Firestore
      for (var local in localNames) {
        if (!firestoreNames.contains(local)) {
          await db.deleteScheme(local);
        }
      }

      print("✅ Sync complete.");
    } catch (e) {
      print("❌ Sync error: $e");
    }
  }
}