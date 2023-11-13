import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}


class _DiaryScreenState extends State<DiaryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Diary',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: diaryWidget()


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

class diaryWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          InkWell(

            onTap: () {
              Navigator.pushNamed(context, '/review');
            },

              child: Container(

                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: textColor)
                  )
                ),
                
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [

                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: textColor
                        )
                      ),
                      child: Text(
                        '11/12/23: ',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16
                        ),
                      ),
                    ),

                    SizedBox(width: 10,),

                    Column(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Resident Evil 2 ' + '(20XX)',
                          style: TextStyle(
                            fontSize: 12,
                            color: fieldColor,
                          ),
                        ),

                        Row(

                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [

                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 12,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 12,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 12,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 12,
                            ),
                            Icon(
                              Icons.star,
                              color: NESred,
                              size: 12,
                            ),

                          ],

                        )

                      ],

                    )

                  ],

                ),

              )

          ),

          

        ],

      )

    );

  }

}