

import 'package:flutter/material.dart';

class SavedScheme extends StatefulWidget{

  static const routeName="/saved-scheme";
  @override
  State<SavedScheme>  createState()=> _SavedScheme();

}

class _SavedScheme extends State<SavedScheme>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Center(child:  Text("saved")),
    );
  }


}