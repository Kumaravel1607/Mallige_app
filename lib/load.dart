import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mallige/Constant/color.dart';
import 'package:mallige/Home.dart';

class Load extends StatefulWidget {
  Load({Key? key}) : super(key: key);

  @override
  State<Load> createState() => _LoadState();
}

class _LoadState extends State<Load> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: green,
            // valueColor: AlwaysStoppedAnimation(Colors.blue),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}
