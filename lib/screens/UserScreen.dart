import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}


class _UserScreenState extends State<UserScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'UserName',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: userWidget()


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

class userWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          GFAvatar(
            shape: GFAvatarShape.circle,
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: NESred)
            ),
            child: Text(
              'Follow',
              style: TextStyle(
                color: NESred,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text(
            'This is my bio',
            style: TextStyle(color: textColor),
          ),
          SizedBox(height: 20,),
          Text(
            'Favorites',
            style: TextStyle(
              fontSize: 20,
              color: textColor
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: (MediaQuery.of(context).size.width/4)*1.25,
            width: (MediaQuery.of(context).size.width),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Card>[
                Card(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.width/4)*1.25,
                      width: MediaQuery.of(context).size.width/5,
                      child: Center(child: Text('Card1'),),
                    ),
                  ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Text(
            'Recent',
            style: TextStyle(
              fontSize: 20,
              color: textColor
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: (MediaQuery.of(context).size.width/4)*1.25,
            width: (MediaQuery.of(context).size.width),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Card>[
                Card(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.width/4)*1.25,
                      width: MediaQuery.of(context).size.width/5,
                      child: Center(child: Text('Card1'),),
                    ),
                  ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
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
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/games');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Games',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/games');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Diary',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/game');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Lists',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/shelf');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Shelf',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/following');
            },
            child: Container(
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
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/follower');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Followers',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
        ],
      )
    );

  }

}