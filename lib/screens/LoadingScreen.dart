import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_project/screens/DiaryScreen.dart';

class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      color: backColor,
      child: const Center(
        child: CircularProgressIndicator(
          color: NESred,
        ),
      )

    );

  }


}