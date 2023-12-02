import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/getUserAPI.dart';
import 'package:mobile_project/utils/getAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

List<dynamic>? friendIdsGlob;
bool isLoading = true;
List<InkWell> column = [];

class FollowerScreen extends StatefulWidget {
  @override
  _FollowerScreenState createState() => _FollowerScreenState();
}


class _FollowerScreenState extends State<FollowerScreen> {

  List<dynamic>? friendIds;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // access the id argument passed from HubScreen
    friendIds ??= ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    friendIdsGlob = friendIds;

    print(friendIds);
    print(friendIdsGlob);

    // check if gameId is not null before making the API call
    if (friendIds != null) {
      fetchFriendData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchFriendData() async {

    if (mounted) {
      setState(() => isLoading = true);
    }

    column = [];

    for (var friendId in friendIdsGlob!) {
      if (!mounted) {continue;}

      final String id = friendId;

      if (GlobalData.userId == id) {continue;}

      UserItem cur = await getUserAPI.getUser(id);

      if (!mounted) {continue;}

      InkWell friend = InkWell(

        onTap: () async {
          Navigator.pushNamed(context, '/user', arguments: cur.id);
        },

        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: contColor, width: .25)
            )
          ),
          child: Text(
            cur.userName,
            style: TextStyle(
              fontSize: 16,
              color: textColor
            ),
          ),
        )

      );

      column.add(friend);

    }

    if (mounted) {
      setState(() => isLoading = false);
    }

  }

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

        body: isLoading ? LoadingPage() : myFollowerWidget()


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

        children: column /*[

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

        ], */

      )

    );

  }

}