import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import '../../../home.dart';


final selectedStateProvider = StateProvider<String?>((ref) => null);

class StateSelectionPage extends ConsumerWidget {
  const StateSelectionPage({super.key});


  static const routeName="/state-selection";

  final List<Map<String, dynamic>> states = const [
    {'name': 'Maharashtra', 'local': 'महाराष्ट्र', 'color': Colors.orange},
    {'name': 'Uttar Pradesh', 'local': 'उत्तर प्रदेश', 'color': Colors.red},
    {'name': 'Bihar', 'local': 'बिहार', 'color': Colors.green},
    {'name': 'Tamil Nadu', 'local': 'தமிழ்நாடு', 'color': Colors.purple},
    {'name': 'West Bengal', 'local': 'পশ্চিমবঙ্গ', 'color': Colors.blue},
    {'name': 'Rajasthan', 'local': 'राजस्थान', 'color': Colors.teal},
    {'name': 'Karnataka', 'local': 'ಕರ್ನಾಟಕ', 'color': Colors.indigo},
    {'name': 'Gujarat', 'local': 'ગુજરાત', 'color': Colors.amber},
    {'name': 'Kerala', 'local': 'കേരളം', 'color': Colors.pink},
    {'name': 'Punjab', 'local': 'ਪੰਜਾਬ', 'color': Colors.brown},
    {'name': 'Delhi', 'local': 'दिल्ली', 'color': Colors.deepPurple},
    {'name': 'Assam', 'local': 'অসম', 'color': Colors.cyan},
  ];

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      body: CustomPaint(
        painter: TriangleBackgroundPainter(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'अपना राज्य चुनें / Select Your State',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: states.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final state = states[index];
                      return InkWell(
                        onTap: () {
                          ref.read(selectedStateProvider.notifier).update((_) => state['name']);

                          Navigator.pushNamed(context,Home.routeName);
                        },
                        child: Card(
                          color: state['color'],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              state['local'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TriangleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final triangleColors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.purple.shade100,
      Colors.orange.shade100,
    ];
    final rand = Random();

    for (int i = 0; i < 25; i++) {
      final path = Path();
      double x = rand.nextDouble() * size.width;
      double y = rand.nextDouble() * size.height;

      path.moveTo(x, y);
      path.lineTo(x + rand.nextDouble() * 50, y + rand.nextDouble() * 50);
      path.lineTo(x - rand.nextDouble() * 50, y + rand.nextDouble() * 50);
      path.close();

      paint.color = triangleColors[rand.nextInt(triangleColors.length)].withOpacity(1);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
