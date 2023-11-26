import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/ListsAPI.dart';
import 'package:mobile_project/screens/ListsScreen.dart';
import 'package:mobile_project/utils/getAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);
String shelfGlob = '';
String userIdGlob = '';
bool isLoading = true;
ListItem list = ListItem(id: '', name: '', games: []);
List<InkWell> listGames = [];

class ShelfScreen extends StatefulWidget {
  @override
  _ShelfScreenState createState() => _ShelfScreenState();
}


class _ShelfScreenState extends State<ShelfScreen> {

  String? shelf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // access the id argument passed from HubScreen
    listAndUser item = ModalRoute.of(context)?.settings.arguments as listAndUser;

    shelf = item.listId;
    userIdGlob = item.userId;
    print(userIdGlob + 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    if(shelf == '') {print('poop');}
    print(shelf! + 'this exist');
    final String id = shelf!;
    shelfGlob = id;
    print(shelfGlob);

    // check if gameId is not null before making the API call
    if (shelf != null) {
      fetchShelfData();
    }
  }

  Future<void> fetchShelfData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    listGames = [];

    print(shelfGlob);

    list = await getListsAPI.getList(shelfGlob);

    List<String> games = list.games;

    for (String game in games) {
      if (!mounted) {continue;}
      GameItem cur = await SearchGameLocal.getGame(game);

      print(cur.id + 'gameId aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      InkWell cover = InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/game',
          arguments: int.parse(cur.igId));
        },
        child: Container(
          height: ((MediaQuery.of(context).size.width - 44) / 4)*1.5,
          width: (MediaQuery.of(context).size.width - 44) / 4,
          margin: EdgeInsets.all(4),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // this allows for the rounded edges. I can't get it the way
            borderRadius: BorderRadius.all(Radius.circular(4))),
          child: cur.image != ''
            ? Image.network(
              cur.image,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            )
            : Text('Failed to load')

          )
        );
      listGames.add(cover);

    }

    if (userIdGlob == GlobalData.userId && mounted) {
      print('user is the sameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

      InkWell edit = InkWell(
        onTap: () {
          
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 4, right: 4, bottom: 10),
          margin: EdgeInsets.only(top: 5),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: textColor,
                width: .25
              )
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ]
          ),
        )
      );

      listGames.add(edit);

      if (list.name != 'Shelf') {

        InkWell delete = InkWell(
          onTap: () {
            showModalBottomSheet<dynamic>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            backgroundColor: backColor,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return deleteListWidget(
                  listId: list.id,
                );
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 4, right: 4, bottom: 10),
            //margin: EdgeInsets.only(top: 0),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: textColor,
                  width: .25
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    color: NESred,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Icon(
                  Icons.delete,
                  color: NESred,
                  size: 16,
                )
              ]
            ),
          )
        );

        listGames.add(delete);

      }

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
            list.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: isLoading ? LoadingPage() : myShelfWidget()


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

      margin: EdgeInsets.all(6),

      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          Wrap(

            children: listGames/*[

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

            ],*/

          )
        ]
      )

    );

  }

}

class deleteListWidget extends StatefulWidget {
  
  final String listId;

  deleteListWidget({
    required this.listId
  });

  @override
  _deleteListState createState() => _deleteListState(listId: listId);
}

class _deleteListState extends State<deleteListWidget> {
  
  final String listId;

  _deleteListState({
    required this.listId
  });

  Widget build(BuildContext context) {

    return SizedBox(
        height: MediaQuery.sizeOf(context).height / 2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Delete List...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          print('delete');
                          await getListsAPI.deleteList(listId);
                          Navigator.of(context)
                              ..pop()
                              ..pop();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                              color: NESred,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.black87),
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  children: [
                    Text(
                      'Are You Sure?',
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ]));
  }

  }