

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:java_seva_ai/feature/History/saved_scheme.dart';
import 'package:java_seva_ai/feature/auth/screen/login_screen.dart';
import 'package:java_seva_ai/home.dart';
import 'package:java_seva_ai/widget/error.dart';

import 'feature/auth/screen/otp_screen.dart';
import 'feature/auth/screen/state.dart';


Route<dynamic> generateRoute(RouteSettings settings){

  switch (settings.name){
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (context)=>LoginPage());

    case OtpScreen.routeName:
      final verificationId=settings.arguments as String;
      return MaterialPageRoute(builder: (context)=>OtpScreen(verificationId:verificationId ,));

    case Home.routeName:
      return MaterialPageRoute(builder: (context)=>Home());

    case StateSelectionPage.routeName:
      return MaterialPageRoute(builder: (context)=>StateSelectionPage());

    case SavedScheme.routeName:
      return MaterialPageRoute(builder: (context)=>SavedScheme());

    default:
      return MaterialPageRoute(builder: (context)=>const Scaffold(
        body: ErrorScreen(error: 'this page doesn\'t exist'),
      ));

  }

}