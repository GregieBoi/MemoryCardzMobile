import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/getUserApi.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

List<dynamic>? friendIdsGlob;
bool isLoading = true;
List<InkWell> column = [];

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}


class _FollowingScreenState extends State<FollowingScreen> {

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

  Future<void> fetchFriendData() async {

    if (mounted) {
      setState(() => isLoading = true);
    }

    column = [];

    for (var friendId in friendIdsGlob!) {
      if (!mounted) {continue;}

      final String id = friendId;

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
            'Following',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: isLoading ? LoadingPage() : myFollowingWidget()


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

class myFollowingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,

        children: column/*[

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