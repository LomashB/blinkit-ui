import 'dart:async';

import 'package:blinkit/domain/const/appcolors.dart';
import 'package:blinkit/repository/screens/login/loginscreen.dart';
import 'package:blinkit/repository/widgets/uihelper.dart';
import 'package:flutter/material.dart';

class spalshscreen extends StatefulWidget {
  @override
  State<spalshscreen> createState() => _spalshscreenState();
}

class _spalshscreenState extends State<spalshscreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)  => LoginScreen()));
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldbackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomImage(img: "image 1 (1).png")
          ],
        ),
      )
    );
  }
}
