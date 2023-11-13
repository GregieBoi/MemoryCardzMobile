import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}


class _GameScreenState extends State<GameScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Game',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: gameWidget()


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

class gameWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
    
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          Container(

            margin: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.width /2,

            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Container(

                  width: (MediaQuery.of(context).size.width - 60) * (2/3),
                  height: MediaQuery.of(context).size.width /2,

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text('The Legend of Zelda: The Ocarina of Time', style: TextStyle(fontSize: 20, color: fieldColor),),
                      Text('20xx', style: TextStyle(fontSize: 14, color: textColor),),
                      Text('Developed By:', style: TextStyle(fontSize: 14, color: textColor),),
                      Text('Developer', style: TextStyle(fontSize: 14, color: fieldColor, fontWeight: FontWeight.bold),),
                      Text('Published By:', style: TextStyle(fontSize: 14, color: textColor),),
                      Text('Publisher', style: TextStyle(fontSize: 14, color: fieldColor, fontWeight: FontWeight.bold),),

                    ],

                  ),

                  

                ),

                Card(
                  child: SizedBox(
                  width: (MediaQuery.of(context).size.width - 40 ) / 3,
                  child: Center(child: Text('Card1'),),
                  ),
                ),

              ],

            ),

          ),

          Container(

            margin: EdgeInsets.only(left: 20, right: 20),
            height: 105,

            child: SingleChildScrollView(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    'blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ',
                    style: TextStyle(
                      fontSize: 16, 
                      foreground: Paint()..shader = LinearGradient(
                        colors: <Color>[textColor, backColor],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 1000, 130.0)) 
                    ),
                  )

                ],

              )

            )

          ),

          Container(

            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width + 40,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: contColor)
              )

            ),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  'RATINGS',
                  style: TextStyle(
                    color: textColor
                  ),  
                ),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    Icon(
                      Icons.star,
                      color: NESred,
                      size: 10,
                    ),

                    Container(

                      height: 50,
                      width: (MediaQuery.of(context).size.width - 40) * 2/3,
                    
                      child: SfSparkBarChart(

                        data: [0.025,0.025,0.1,0.05,0.05,1,2,3,1,1],
                        color: textColor,

                      ),
                    
                    ),

                    Column(
                      children: [ 
                        Text(
                          '3.9',
                          style: TextStyle(
                            fontSize: 20,
                            color: textColor
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 10,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 10,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 10,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 10,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 10,
                            ),
                            
                          ],
                        )
                      ]
                    )

                  ],

                )

              ],

            ),

          ),

          Container(

            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: textColor)
              )
            ),

            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                Card(
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 40 ) / 3.5,
                    height: (MediaQuery.of(context).size.width - 80 ) / 3.5,
                    decoration: BoxDecoration(
                      color: NESred,
                      borderRadius: BorderRadius.circular(3)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [

                        Icon(
                          Icons.videogame_asset_outlined,
                          color: fieldColor,
                        ),
                        Text(
                          'Players',
                          style: TextStyle(
                            color: fieldColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '100k',
                          style: TextStyle(
                            color: fieldColor,
                          ),
                        )

                      ],

                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pushNamed(context, '/reviews');
                  },
                  child: Card(
                    child: Container(
                    width: (MediaQuery.of(context).size.width - 40 ) / 3.5,
                    height: (MediaQuery.of(context).size.width - 80 ) / 3.5,
                    decoration: BoxDecoration(
                      color: textColor,
                      borderRadius: BorderRadius.circular(3)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [

                          Icon(
                            Icons.text_snippet,
                            color: fieldColor,
                          ),
                          Text(
                            'Reviews',
                            style: TextStyle(
                              color: fieldColor,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '100k',
                            style: TextStyle(
                              color: fieldColor,
                            ),
                          )

                        ],

                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                  width: (MediaQuery.of(context).size.width - 40 ) / 3.5,
                  height: (MediaQuery.of(context).size.width - 80 ) / 3.5,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [

                        Icon(
                          Icons.list,
                          color: fieldColor,
                        ),
                        Text(
                          'Lists',
                          style: TextStyle(
                            color: fieldColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '100k',
                          style: TextStyle(
                            color: fieldColor,
                          ),
                        )

                      ],

                    ),
                  ),
                ),

              ],

            ),

          ),
          
          Container(

            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: textColor)
              )
            ),

            child: Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  'Where to Play:',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Column(

                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [

                    Text(
                      'Playstation 4',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16
                      ),                
                    ),
                    Text(
                      'Xbox Series X',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16
                      ),                
                    ),
                    Text(
                      'Nintendo Switch',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16
                      ),                
                    ),
                    

                  ],

                )

              ],

            ),

          ),
          
          Container(

            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: textColor)
              )
            ),

            child: Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  'Rating:',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Text(
                  'E10+',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),

              ],

            ),

          ),

          Container(

            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: textColor)
              )
            ),

            child: Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  'Genre(s):',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Column(

                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [

                    Text(
                      'Fantasy',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16
                      ),                
                    ),
                    Text(
                      'RPG',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16
                      ),                
                    ),
                    Text(
                      'Strategy',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16
                      ),                
                    ),
                    

                  ],

                )

              ],

            ),

          ),

        ],

      ),
      

    );

  }

}