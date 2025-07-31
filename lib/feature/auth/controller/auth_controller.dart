import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/Auth_repo.dart';



final authControllerProvider=Provider((ref){
  final authRepository =ref.watch(AuthRepositoryProvider);
  return AuthController(authRepository: authRepository);
});


class AuthController {

  final AuthRepository authRepository;

  AuthController({required this.authRepository});



   signWithPhone(BuildContext context, String phoneNumber) {
    return authRepository.singnInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext
  context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }

}
