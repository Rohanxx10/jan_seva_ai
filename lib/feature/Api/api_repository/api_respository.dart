
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:java_seva_ai/home.dart';
import 'package:path/path.dart';

import '../../../modal/scheme_model.dart';
import '../../auth/screen/state.dart';


final ApiRespositoryProvider = Provider<ApiRepository>((ref) => ApiRepository());


class ApiRepository {




  Future<Scheme?> callApiWithUserQuery({
    required String query,
    required WidgetRef ref,
    required BuildContext context
  }) async {
    final state = ref.watch(selectedStateProvider); // e.g., "Delhi"
    final url = Uri.parse("https://rohan3348.pythonanywhere.com/get-scheme-info");

    final headers = {
      "Content-Type": "application/json",
    };

    final body = json.encode({
      "state": state,
      "text": query,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Scheme.fromJson(jsonData);
      } else {
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
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "something wrong try again");
      return null;
    }
  }



}
