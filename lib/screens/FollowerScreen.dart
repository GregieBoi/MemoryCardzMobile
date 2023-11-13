import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class FollowerScreen extends StatefulWidget {
  @override
  _FollowerScreenState createState() => _FollowerScreenState();
}


class _FollowerScreenState extends State<FollowerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Followers',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: myFollowerWidget()


    );
  }
}


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class myFollowerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: contColor)
              )
            ),
            child: Text(
              'Following',
              style: TextStyle(
                fontSize: 16,
                color: textColor
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: contColor)
              )
            ),
            child: Text(
              'Following',
              style: TextStyle(
                fontSize: 16,
                color: textColor
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: contColor)
              )
            ),
            child: Text(
              'Following',
              style: TextStyle(
                fontSize: 16,
                color: textColor
              ),
            ),
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: contColor)
              )
            ),
            child: Text(
              'Following',
              style: TextStyle(
                fontSize: 16,
                color: textColor
              ),
            ),
          ),

        ], 

      )

    );

  }

}