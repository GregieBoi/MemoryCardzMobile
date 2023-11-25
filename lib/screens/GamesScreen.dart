import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/ReviewsAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

List<dynamic>? reviews;
bool isLoading = true;
List<InkWell> wrap = [];

class GamesScreen extends StatefulWidget {
  @override
  _GamesScreenState createState() => _GamesScreenState();
}


class _GamesScreenState extends State<GamesScreen> {

  List<GameItem> games = [];
  List<InkWell> wrapped = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, List<dynamic>>? args =
      ModalRoute.of(context)?.settings.arguments as Map<String, List<dynamic>>?;
  
    final List<dynamic> reviewss = args?['reviews'] ?? [];
    reviews = reviewss;

    print(reviews);

    fetchGames();
  
  }

  Future<void> fetchGames() async {

    if (mounted) {
      setState(() => isLoading = true);
    }

    wrap = [];

    print(reviews);

    for (var reviewId in reviews!) {
      if (!mounted) {continue;}

      print(reviewId);
      final String id = reviewId;

      ReviewItem cur = await getReviewsAPI.getReview(id);
      print(cur.game);

      GameItem curGame = await SearchGameLocal.getGame(cur.game);

      games.removeWhere((it) => it.id == curGame.id);

      games.add(curGame); 

    }

    
    for (GameItem game in games) {
      print(game.id + 'gameId aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      if (mounted) {
      InkWell cover = InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/game',
          arguments: int.parse(game.igId));
        },
        child: Container(
          height: (MediaQuery.of(context).size.width/5)*1.5,
          width: MediaQuery.of(context).size.width/5,
          margin: EdgeInsets.all(4),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // this allows for the rounded edges. I can't get it the way
            borderRadius: BorderRadius.all(Radius.circular(4))),
          child: game.image != ''
            ? Image.network(
              game.image,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            )
            : Text('Failed to load')

          )
        );
      wrap.add(cover);
      }
    }

    await Future.delayed(const Duration(seconds: 0));
    if (mounted) {
      setState(() => isLoading = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    print(reviews);

    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Games',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: isLoading ? LoadingPage() : myGamesWidget()


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

class myGamesWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.all(20),

      child: SingleChildScrollView(        

        child:

          Wrap(


            children: wrap/*[

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
      )

    );

  }

}