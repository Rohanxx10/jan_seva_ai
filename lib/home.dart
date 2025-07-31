import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:java_seva_ai/feature/card/card_widget.dart';
import 'package:java_seva_ai/feature/mic/repository/mic_service.dart';
import 'package:java_seva_ai/widget/home_widget.dart';

import 'feature/Api/controller/api_controller.dart';
import 'feature/History/history.dart';
import 'feature/auth/screen/state.dart';




class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  static const routeName = "/home";

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
     HomeWidget(),
    DocumentHistoryList(),

  ];

  @override
  void initState() {
    super.initState();

  }



  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Image.asset(
              "assets/images/jansevaAi.png",
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 8),
            const Text(
              "JanSeva Ai",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, StateSelectionPage.routeName);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  ref.watch(selectedStateProvider) ?? "Select",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            VoiceService().handleMicPress(context: context, ref: ref);
          },
          backgroundColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(Icons.mic, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        child: BottomAppBar(
          color: Colors.orangeAccent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildNavItem(Icons.home, "Home", 0),
                  ],
                ),
                Row(
                  children: [
                    _buildNavItem(Icons.miscellaneous_services, "History", 1),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: isSelected ? Colors.black : Colors.white),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: isSelected ? Colors.black : Colors.white),
          ),
        ],
      ),
    );
  }
}
