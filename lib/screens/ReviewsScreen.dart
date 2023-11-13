import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}


class _ReviewsScreenState extends State<ReviewsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Reviews',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: reviewsWidget()


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

class reviewsWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          InkWell(

            onTap: () async {
              Navigator.pushNamed(context, '/review');
            },

            child: Container(

              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: textColor)
                )
              ),

              child: Column(

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Container(
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        Row(
                          children: [
                            Icon(Icons.star, color: NESred, size: 12,),
                            Icon(Icons.star, color: NESred, size: 12,),
                            Icon(Icons.star, color: NESred, size: 12,),
                            Icon(Icons.star, color: NESred, size: 12,),
                          ],
                        ),

                        Text(
                          'UserName',
                          style: TextStyle(
                            color: textColor
                          ),
                        )

                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  Text(
                    'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                    style: TextStyle(
                      color: textColor
                    ),
                  )

                ],

              ),

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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
                  ),
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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
                  ),
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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
                  ),
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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
                  ),
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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
                  ),
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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
                  ),
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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
                  ),
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

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Row(
                        children: [
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                          Icon(Icons.star, color: NESred, size: 12,),
                        ],
                      ),

                      Text(
                        'UserName',
                        style: TextStyle(
                          color: textColor
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text(
                  'blah blah blah blah blah blah blah blah blah blah blah blah blah blah',
                  style: TextStyle(
                    color: textColor
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