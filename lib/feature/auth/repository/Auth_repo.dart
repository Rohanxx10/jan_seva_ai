


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:java_seva_ai/feature/auth/screen/otp_screen.dart';
import 'package:java_seva_ai/home.dart';

import '../../../widget/utils.dart';
import '../screen/state.dart';


Provider AuthRepositoryProvider=Provider((ref)=>AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance));


class AuthRepository{

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth,required this.firestore});

   singnInWithPhone (BuildContext context,String phoneNumber)async{

    try{
     return await auth.verifyPhoneNumber(phoneNumber: phoneNumber,
          verificationCompleted:(PhoneAuthCredential credential) async{
            await auth.signInWithCredential(credential);
          }
          , verificationFailed: (e){
            throw Exception(e.message!);
          }, codeSent: ((String verificationId,int? resendToken)async{

            Navigator.pushNamed(context, OtpScreen.routeName,arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verification){

          });
    }on FirebaseAuthException catch(e){
      showSnackBar(context: context, content: e.message!);
    }

  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  })async{
    try{
      PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(context
          , StateSelectionPage.routeName,(route)=>false);

    } on FirebaseAuthException catch(e){
      showSnackBar(context: context, content: e.message!);
    }
  }





}