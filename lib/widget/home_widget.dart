

import 'package:flutter/cupertino.dart';

import 'package:java_seva_ai/feature/image_slider/ui/image_slider.dart';

import '../feature/card/card_widget.dart';

class HomeWidget extends StatefulWidget{

  @override
  State<HomeWidget> createState()=> _HomeWidget();

}

class _HomeWidget extends State<HomeWidget>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(),
             const SizedBox(height: 20,),
              HomeCardWidget(),
            SizedBox(height: 30)
          ],
        ),

      ),
    );
  }


}