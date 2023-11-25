import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/ListsAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);
String shelfGlob = '';
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
    shelf ??= ModalRoute.of(context)?.settings.arguments as String?;
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
          height: (MediaQuery.of(context).size.width/5)*1.5,
          width: MediaQuery.of(context).size.width/5,
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

      margin: EdgeInsets.all(20),

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