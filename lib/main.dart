import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:java_seva_ai/feature/auth/screen/login_screen.dart';
import 'package:java_seva_ai/home.dart';
import 'package:java_seva_ai/router.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child:SchemeApp()));
}

class SchemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) => generateRoute(settings),
      home:StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges()
          , builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
    }
            if(snapshot.data!=null) return Home();
            return LoginPage();

    }),
    );
  }
}


