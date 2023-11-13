import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class ShelfScreen extends StatefulWidget {
  @override
  _ShelfScreenState createState() => _ShelfScreenState();
}


class _ShelfScreenState extends State<ShelfScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Shelf',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: myShelfWidget()


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

class myShelfWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.all(20),

      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          Wrap(

            children: [

              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),

            ],

          )
        ]
      )

    );

  }

}