import 'package:flutter/material.dart';

class CommonList extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> path;

  const CommonList({Key? key, required this.path}) : super(key: key);

  @override
  State<CommonList> createState() => _CommonListState();
}

class _CommonListState extends State<CommonList> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.path,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No document history found."));
        }

        final documents = snapshot.data!;

        return ListView.builder(
          itemCount: documents.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final doc = documents[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🟢 Main clickable card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.description, color: Colors.deepPurple),
                    title: Text(
                      doc['document_name']==null? doc['scheme_name'] : doc['document_name'] ?? "unNamed",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      _expandedIndex == index
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    onTap: () {
                      setState(() {
                        _expandedIndex = _expandedIndex == index ? null : index;
                      });
                    },
                  ),
                ),


                if (_expandedIndex == index)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetail("📄 Type", doc['type']),
                        _buildDetail("✅ Eligibility", doc['eligiblity']==null ? doc['eligibility']:doc['eligiblity']),
                        _buildDetail("📂 Documents", doc['documents']),
                        _buildDetail("📝 Application Process", doc['application_process']),
                        _buildDetail("🌐 Website", doc['website']),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetail(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(text: "$title:\n", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value?.toString() ?? "Not Available"),
          ],
        ),
      ),
    );
  }
}
