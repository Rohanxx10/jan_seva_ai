import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:java_seva_ai/feature/History/saved_scheme.dart';
import 'package:java_seva_ai/widget/list.dart';
import '../../database/controller/database_controller.dart';
import '../../modal/state_central_scheme_model.dart';
import 'dbms_state/repository/dbms_repo.dart';
import 'dbms_state/repository/update_local_db.dart';

final selectedSectionProvider = StateProvider<int>((ref) => 0);
// 0 = Document History, 1 = Saved, 2 = State, 3 = Central




class DocumentHistoryList extends ConsumerWidget {
  const DocumentHistoryList({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedSection = ref.watch(selectedSectionProvider);
    final dbController = ref.watch(dbControllerProvider);
    final dbState=ref.watch(SchemeStateDbProvider);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                sectionHeader("Quick Access"),
                const SizedBox(height: 8),

                // 🔸 Saved Schemes Card
                Row(
                  children: [
                    Flexible(
                      flex: 2, // 2 parts of the total 3
                      child: Card(
                        color: Colors.orangeAccent,
                        elevation: 4,
                        shadowColor: Colors.orangeAccent.withOpacity(0.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: const Icon(Icons.bookmark, color: Colors.white),
                          title: const Text("Saved Schemes"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            ref.read(selectedSectionProvider.notifier).state = 1;
                          },
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 1,
                      child: Card(
                        color: Colors.lightBlueAccent,
                        elevation: 4,
                        shadowColor: Colors.orangeAccent.withOpacity(0.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          // dense: true, // reduces vertical height
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                          leading: const Icon(Icons.history, size: 30, color: Colors.white),
                          title: const Text(
                            "Recent",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            ref.read(selectedSectionProvider.notifier).state = 0;
                          },
                        ),
                      ),
                    ),

                  ],
                ),


                SizedBox(height: 10),

                // 🔸 State and Central Schemes Row
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 3,
                        color: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: const Icon(Icons.location_city, color: Colors.green),
                          title: const Text("State", style: TextStyle(fontSize: 14)),
                          onTap: () {
                            ref.read(selectedSectionProvider.notifier).state = 2;
                            ref.watch(schemeRepoStateCentralProvider).syncSchemesFromFirestoreState("UttarPradesh", ref);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        elevation: 3,
                        color: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: const Icon(Icons.flag, color: Colors.red),
                          title: const Text("Central", style: TextStyle(fontSize: 14)),
                          onTap: () async{

                            ref.read(selectedSectionProvider.notifier).state = 3;
                            // SchemeModel newScheme = SchemeModel(
                            //   schemeName: "Kanya Sumangala Yojana",
                            //   type: "State",
                            //   eligibility: "Girl child born in Uttar Pradesh after April 2019",
                            //   documentsRequired: "Birth certificate, Aadhaar, Income proof",
                            //   applicationProcess: "Online via UP government portal",
                            //   officialWebsite: "http://mksy.up.gov.in",
                            // );

                            // await uploadSchemeToStateCollection("Uttar Pradesh", newScheme);

                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔸 Dynamic Section Header
                sectionHeader(
                  selectedSection == 1
                      ? "Saved Schemes"
                      : selectedSection == 2
                      ? "State Schemes"
                      : selectedSection == 3
                      ? "Central Schemes"
                      : "Document History",
                ),
              ],
            ),
          ),

          // 🔄 Dynamic Content Based on Selected Section
          Expanded(
            child: Builder(
              builder: (context) {
                if (selectedSection == 1) {
                  return CommonList(path: dbController.getSaved());
                } else if (selectedSection == 2) {
                  return CommonList(path: dbState.getAllSchemes());
                } else if (selectedSection == 3) {
                  return const Center(child: Text("Central Schemes UI here"));
                }

                // 🔁 Default: Document History
                return CommonList(path: dbController.getAllDocumentNames());

              },
            ),
          ),
        ],
      ),
    );
  }

 Future<void> uploadSchemeToStateCollection(String stateName, SchemeModel scheme) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('Central');


      await collectionRef.add(scheme.toMap());

      print("Scheme uploaded successfully to $stateName collection.");
    } catch (e) {
      print("Error uploading scheme: $e");
    }
  }


  Widget sectionHeader(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 6),
        const Expanded(
          child: Divider(thickness: 1, color: Colors.grey),
        ),
      ],
    );
  }
}
