import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../modal/scheme_model.dart';
import '../../Api/controller/api_controller.dart';

final schemeResultProvider = StateProvider<Scheme?>((ref) => null);


class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final FlutterTts tts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();

  bool _speechInitialized = false;
  bool _ttsInitialized = false;

  Future<bool> initialize() async {
    if (!_speechInitialized) {
      _speechInitialized = await speech.initialize(
        onStatus: (status) => debugPrint("Speech status: $status"),
        onError: (error) => debugPrint("Speech error: ${error.errorMsg}"),
      );
    }
    if (!_ttsInitialized) {
      await tts.setLanguage("hi-IN");
      await tts.setSpeechRate(0.45);
      await tts.awaitSpeakCompletion(true);
      _ttsInitialized = true;
    }
    return _speechInitialized && _ttsInitialized;
  }

  Future<void> handleMicPress({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: "Mic permission denied");
      return;
    }

    final initialized = await initialize();
    if (!initialized) {
      Fluttertoast.showToast(msg: "Speech or TTS not initialized properly");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: VoiceBottomSheet(tts: tts, speech: speech, ref: ref),
      ),
    );
  }
}

class VoiceBottomSheet extends ConsumerStatefulWidget {
  final FlutterTts tts;
  final stt.SpeechToText speech;
  final WidgetRef ref;

  const VoiceBottomSheet({
    Key? key,
    required this.tts,
    required this.speech,
    required this.ref,
  }) : super(key: key);

  @override
  ConsumerState<VoiceBottomSheet> createState() => _VoiceBottomSheetState();
}

class _VoiceBottomSheetState extends ConsumerState<VoiceBottomSheet> {
  String status = "Initializing...";
  String userQuery = "";
  bool _isLoading = false;
  bool _noInputHandled = false;

  @override
  void initState() {
    super.initState();
    widget.tts.setCompletionHandler(() {
      if (!mounted) return;
      setState(() => status = "Listening...");
      _startListening();
    });

    _startInteraction();
  }

  Future<void> _startInteraction() async {
    setState(() {
      status = "Saying hello...";
      userQuery = "";
      _isLoading = false;
    });

    await widget.tts.stop();
    await widget.speech.stop();

    // Greet the user
    await widget.tts.speak("नमस्कार! मैं आपकी क्या सहायता कर सकती हूँ?");

    // Add a delay to give user time to hear and think
    await Future.delayed(const Duration(seconds: 2));

    // Start listening after the greeting
    _startListening();
  }


  Future<void> _startListening() async {
    if (!widget.speech.isAvailable) {
      Fluttertoast.showToast(msg: "Speech not available");
      if (mounted) Navigator.pop(context);
      return;
    }

    _noInputHandled = false;

    await widget.speech.listen(

      onResult: (val) {
        if (!mounted) return;
        setState(() {
          userQuery = val.recognizedWords;
        });
      },
      listenMode: stt.ListenMode.dictation,
      listenFor: const Duration(seconds: 30), // total max speech duration
      pauseFor: const Duration(seconds: 8),
      partialResults: true,
    );

    widget.speech.statusListener = (statusVal) {
      debugPrint("[Speech Status]: $statusVal");
      if (statusVal == "done" || statusVal == "notListening") {
        if (_noInputHandled) return;
        _noInputHandled = true;
        _handleSpeechComplete();
      }
    };
  }


  void _handleSpeechComplete() {
    setState(() {
      status = "Processing...";
      _isLoading = true;
    });

    if (userQuery.trim().isEmpty) {
      Fluttertoast.showToast(msg: "No input received.");
      setState(() {
        _isLoading = false;
        status = "No input received.";
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } else {
      _callApiWithUserQuery(userQuery);
    }
  }

  Future<void> _callApiWithUserQuery(String query) async {
    final api = ref.read(ApiControllerProvider);
    final result = await api.callApiWithUserQuery(query: query, ref: ref,context: context);

    if (result != null) {
      ref.read(schemeResultProvider.notifier).state = result;
    } else {
      Fluttertoast.showToast(msg: "No matching scheme found.");
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    widget.tts.stop();
    widget.speech.stop();
    widget.speech.statusListener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic, size: 50, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              status,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              userQuery.isNotEmpty ? userQuery : "Listening for input...",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
