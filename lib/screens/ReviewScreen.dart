import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}


class _ReviewScreenState extends State<ReviewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Review',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: reviewWidget()


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

class reviewWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Container(

            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.width/2,


            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                
                Container(

                  width: (MediaQuery.of(context).size.width - 60) * (2/3),

                child: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, '/user');  
                      },

                      child: Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    Text(
                      'Title ' + '20xx',
                      style: TextStyle(
                        color: fieldColor,
                        fontSize: 20
                      ),
                    ),

                    Row(
                      children: [
                        Icon(Icons.star, color: NESred, size: 12,),
                        Icon(Icons.star, color: NESred, size: 12,),
                        Icon(Icons.star, color: NESred, size: 12,),
                        Icon(Icons.star, color: NESred, size: 12,),
                      ],
                    ),

                    Text(
                      'Played Month X, 20XX',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      )
                    )

                  ],

                ),
                ),

                Card(
                  child: SizedBox(
                  width: (MediaQuery.of(context).size.width - 40 ) / 4,
                  child: Center(child: Text('Card1'),),
                  ),
                ),

              ],

            ),

          ),

          Container(

            padding: EdgeInsets.only(left: 20, right: 20,),

            child: Text(
              'This is my awesome review of this game',
              style: TextStyle(
                color: fieldColor
              ),
            )

          ),

          Container(

            padding: EdgeInsets.all(20),

            child: Row(

              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                Icon(
                  Icons.favorite_outline,
                  size: 24,
                  color: textColor,
                ),

                SizedBox(width: 10,),

                Text(
                  'LIKE?',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14
                  ),
                ),

                SizedBox(width: 10,),

                Text(
                  'Likes ' + '100',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14
                  ),
                )

              ],

            ),

          )

        ],

      ),

    );

  }

}