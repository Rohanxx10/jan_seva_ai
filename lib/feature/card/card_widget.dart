import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../database/controller/database_controller.dart';
import '../../modal/scheme_model.dart';
import '../mic/repository/mic_service.dart';

class HomeCardWidget extends ConsumerStatefulWidget {
  const HomeCardWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeCardWidget> createState() => _HomeCardWidgetState();
}

class _HomeCardWidgetState extends ConsumerState<HomeCardWidget> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;


  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void add_Scheme(Scheme scheme)async{
    final db = ref.read(dbControllerProvider);
    final isAlreadySaved = await db.isPresent(scheme.schemeName!);

    if (!isAlreadySaved ) {
      final success = await db.add(
        document_name: scheme.schemeName!,
        type: scheme.type!,
        eligiblity: listToString(scheme.eligibility!),
        documents: listToString(scheme.documentsRequired!),
        application_process: listToString(scheme.applicationProcess!),
        website: scheme.officialWebsite!,
        is_saved: 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? "Scheme Saved!" : "Failed to Save Scheme")),
      );
    }
  }

  saved_scheme(String documentName){

      final db = ref.read(dbControllerProvider);
      db.saved(documentName);
  }


  Future<void> speakSchemeDetails(Scheme scheme) async {
    if (scheme.schemeName == null) return;

    final text = StringBuffer();
    text.writeln("Scheme Name: ${scheme.schemeName}");
    text.writeln("Type: ${scheme.type}");
    text.writeln("Eligibility: ${scheme.eligibility?.join(', ')}");
    text.writeln("Documents Required: ${scheme.documentsRequired?.join(', ')}");
    text.writeln("Application Process: ${scheme.applicationProcess?.join(', ')}");
    text.writeln("Website: ${scheme.officialWebsite}");

    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1);

    setState(() => isSpeaking = true);
    await flutterTts.speak(text.toString());
    setState(() => isSpeaking = false);
    await flutterTts.stop();
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    setState(() => isSpeaking = false);
  }

  String listToString(List<String> schemeList) {
    return schemeList.join(', ');

  }



  @override
  Widget build(BuildContext context) {
    final scheme = ref.watch(schemeResultProvider);
    final widthScreen = MediaQuery.of(context).size.width;



    if (scheme == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/namaste.png'),
            const SizedBox(height: 20),
            const Text(
              "Namaste",
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            )
          ],
        ),
      );
    }
    else{
      add_Scheme(scheme);
    }


    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                Text(
                  "🇮🇳 KnowYourScheme",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Empowering Citizens. One Scheme at a Time.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Scheme Details Card
          Container(
            width: widthScreen * 0.95,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheme.schemeName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    rowData("📄 Type", scheme.type),
                    rowData("✅ Eligibility", scheme.eligibility?.join('\n')),
                    rowData("📋 Documents", scheme.documentsRequired?.join('\n')),
                    rowData("📝 Application Process", scheme.applicationProcess?.join('\n')),
                    rowData("🌐 Website", scheme.officialWebsite),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: scheme.schemeName != null
                              ? () => speakSchemeDetails(scheme)
                              : null,
                          icon: const Icon(Icons.volume_up, color: Colors.white),
                          label: Text(isSpeaking ? "Speaking..." : "Tap to Listen"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSpeaking ? Colors.orange : Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: isSpeaking ? stopSpeaking : null,
                          icon: const Icon(Icons.stop_circle),
                          label: const Text("Stop"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                        const Spacer(),

                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          tooltip: "Save this Scheme",
                          focusColor: Colors.orangeAccent,
                          onPressed: ()async=>scheme!=null ? saved_scheme(scheme.schemeName!):(){

                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          TextButton.icon(
            onPressed: () {
              // TODO: Navigate to Explore Screen
            },
            icon: const Icon(Icons.explore, color: Colors.deepPurple),
            label: const Text(
              "Explore More Schemes",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowData(String title, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }
}
