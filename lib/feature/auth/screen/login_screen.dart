import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:java_seva_ai/feature/auth/controller/auth_controller.dart';
import '../../../widget/utils.dart';



class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const routeName = "/login-screen";

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController phoneController = TextEditingController();


  Future<void> sendPhoneNumber() async {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isNotEmpty) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Sending OTP...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      try {
        // Await Firebase Auth operation
        await Future.delayed(const Duration(seconds: 2)); // for visual feedback (optional)
        await ref.read(authControllerProvider).signWithPhone(
          context,
          '+91$phoneNumber',
        );


      } catch (e) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          showSnackBar(context: context, content: 'Error: $e');
        }
      }
    } else {
      showSnackBar(context: context, content: 'Fill all required fields');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;



    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 90,
            right: 90,
            child: Image.asset(
              'assets/images/jansevaAi.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
          CustomPaint(
            size: size,
            painter: TrianglePainter(),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "JanSeva.Ai",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: size.width * .8,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Phone number",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.deepOrangeAccent),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                        prefixText: "+91 ",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: sendPhoneNumber,
                    child: const Text("Get OTP", style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  Text("use  phone 1234567899 otp 123456 for testing", style: TextStyle(fontSize: 16, color: Colors.black))

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final saffronPaint = Paint()..color = const Color(0xFFFF9933).withOpacity(0.6);
    final whitePaint = Paint()..color = Colors.white.withOpacity(0.3);
    final greenPaint = Paint()..color = const Color(0xFF138808).withOpacity(0.5);

    final path1 = Path()
      ..moveTo(0, size.height * 0.25)
      ..lineTo(size.width * 0.6, 0)
      ..lineTo(0, 0)
      ..close();

    final path2 = Path()
      ..moveTo(size.width * 0.6, size.height * 0.4)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..close();

    final path3 = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(size.width, size.height * 0.7)
      ..close();

    final path4 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * 0.8, size.height * 0.1)
      ..lineTo(size.width, size.height * 0.2)
      ..close();

    final path5 = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.3, size.height)
      ..lineTo(0, size.height * 0.8)
      ..close();

    final path6 = Path()
      ..moveTo(size.width * 0.4, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.4)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.6)
      ..close();

    canvas.drawPath(path1, saffronPaint);
    canvas.drawPath(path2, whitePaint);
    canvas.drawPath(path3, greenPaint);
    canvas.drawPath(path4, saffronPaint);
    canvas.drawPath(path5, greenPaint);
    canvas.drawPath(path6, whitePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
