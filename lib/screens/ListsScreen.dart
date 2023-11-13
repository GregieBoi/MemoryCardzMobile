import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class ListsScreen extends StatefulWidget {
  @override
  _ListsScreenState createState() => _ListsScreenState();
}


class _ListsScreenState extends State<ListsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Lists',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: listsWidget()


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

class listsWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          InkWell(

            onTap: () async {
              Navigator.pushNamed(context, '/shelf');
            },

            child: Container(

              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: textColor)
                )
              ),

              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Text(
                    'Name of List',
                    style: TextStyle(
                      color: fieldColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    '# ' + 'Games',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  )

                ],

              ),

            ),

          )
          

        ],

      ),

    );

  }

}