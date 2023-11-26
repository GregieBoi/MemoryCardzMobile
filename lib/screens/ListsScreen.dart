import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/HubScreen.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/ListsAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

List<dynamic>? listsIdsGlob = [];
bool isLoading = true;
List<InkWell> column = [];
String userIdGlob = '';

class listAndUser {
  String userId;
  String listId;

  listAndUser ({
    required this.userId,
    required this.listId
  });
}

class ListsScreen extends StatefulWidget {
  @override
  _ListsScreenState createState() => _ListsScreenState();
}


class _ListsScreenState extends State<ListsScreen> {

  List<dynamic>? listsIds;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // access the id argument passed from HubScreen
    listsAndUser item = ModalRoute.of(context)?.settings.arguments as listsAndUser;

    listsIds = item.lists;
    userIdGlob = item.userId;

    print(listsIds);


    //listsIds ??= ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    listsIdsGlob = listsIds;

    print(listsIds);
    print(listsIdsGlob);

    // check if gameId is not null before making the API call
    if (listsIds != null) {
      fetchListData();
    }
  }

  Future<void> fetchListData() async {

    if (mounted) {
      setState(() => isLoading = true);
    }

    column = [];

    for (var listId in listsIdsGlob!) {
      if (!mounted) {continue;}

      final String id = listId;

      ListItem cur = await getListsAPI.getList(id);

      int numGames = cur.games.length;

      if (!mounted || cur.name == 'Shelf' || cur.name == '') {continue;}

      InkWell list = InkWell(

        onTap: () async {
          await Navigator.pushNamed(context, '/shelf', arguments: listAndUser(userId: userIdGlob, listId: cur.id));
          print('butttttttttttttttttttttttttttttttttttttttttttttttttts');
          didChangeDependencies();
          print('buttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
        },

        child: Container(

          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: textColor, width: .25)
            )
          ),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Text(
                cur.name,
                style: TextStyle(
                  color: fieldColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),

              Text(
                '$numGames' + ' Games',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              )

            ],

          ),

        ),

      );
      
      column.add(list);

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
            'Lists',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: isLoading ? LoadingPage() : listsWidget()


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

        children: column/*[

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
          

        ],*/

      ),

    );

  }

}