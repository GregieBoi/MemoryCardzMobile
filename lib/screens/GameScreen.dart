import 'package:flutter/material.dart';
import 'package:mobile_project/utils/AddGame.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/getUserAPI.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/utils/GamePageAPI.dart';
import 'package:intl/intl.dart';
import 'package:mobile_project/utils/CoverAPI.dart';
import 'package:mobile_project/utils/CompanyAPI.dart';
import 'package:mobile_project/utils/CompanyAPIDeveloper.dart';
import 'package:mobile_project/utils/PlatformsAPI.dart';
import 'package:mobile_project/utils/AgeRatingsAPI.dart';
import 'package:mobile_project/utils/GenreAPI.dart';
import 'package:mobile_project/screens/HubScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'dart:convert';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/getUserAPI.dart';
import 'package:mobile_project/utils/ListsAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

String gameTitle = '';
String gameDescription = '';
String gameCoverImage = '';
String gameDate = '';
int? gameIdGlob;
//List<String> gameCompanyNames = [];
List<String> gameDeveloperNames = [];
List<String> gamePlatforms = [];
List<int> gameAgeRatings = [];
List<String> gameGenres = [];
bool isLoading = true;
String ageRating = '';
List<int> ratingSpread = [0,0,0,0,0,0,0,0,0,0];
String ratingAverage = 'N/A';
String numReviews = '0';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Map<String, dynamic>> gamesList = [];
  List<CoverItem> images = [];
  //List<CompanyItem> companyNames = [];
  List<DeveloperItem> developerNames = [];
  List<PlatformItem> platformNames = [];
  List<AgeRatingItem> ageRatingNames = [];
  List<GenreItem> genreNames = [];
  static final List<String> ageRatingsLookup = ['3+', '7+', '12+', '16+', '18+', 'RP', 'EC', 'E', 'E10+', 'T', 'M', 'AO'];

  int? gameId; // variable to store gameID

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // access the id argument passed from HubScreen
    gameId ??= ModalRoute.of(context)?.settings.arguments as int?;
    gameIdGlob = gameId;

    // check if gameId is not null before making the API call
    if (gameId != null) {
      fetchGameData();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGameData();
  }

  Future<void> fetchGameData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    final api = GamePageAPI();
    final api2 = CoverAPI();
    final api3 = CompanyAPIDeveloper();
    final api4 = PlatformsAPI();
    final api5 = AgeRatingsAPI();
    final api6 = GenreAPI();

    // Use the stored gameId
    await api.getGames(gameId);
    await api2.fetchData(gameId);
    await api3.fetchDevelopers(gameId);
    await api4.fetchPlatforms(gameId);
    await api5.fetchAgeRatings(gameId);
    await api6.fetchGenres(gameId);

    String localId = await AddGameAPI.searchId('$gameIdGlob');
    GameItem local = GameItem(id: '', title: '', dev: '', genre: '', release: '', reviews: List.empty(), image: '', igId: '', spread: [0,0,0,0,0,0,0,0,0,0]);
    if (localId != '') {
      local = await SearchGameLocal.getGame(localId);
    }
    String average = 'N/A';
    int sum = 0;
    int total = 0;
    for(int i = 0; i < 10; i++) {
      int cur = local.spread[i];
      sum += cur * (i + 1);
      total += cur;
    }
    if (sum != 0) {  
      double avg = (sum/total) / 2;
      average = avg.toStringAsFixed(1);
    }
    int numReviewsLocal = local.reviews.length;

    if (mounted) {
      setState(() {
        gamesList = api.gamesList;
        images = api2.body;
        //companyNames = api3.body;
        developerNames = api3.body;
        platformNames = api4.body;
        ageRatingNames = api5.body;
        genreNames = api6.body;
        ratingSpread = local.spread;
        ratingAverage = average;
        numReviews = '$numReviewsLocal';
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var game in gamesList) {
      // resets all data to prevent confliting information
      gameTitle = '';
      gameDescription = '';
      gameCoverImage = '';
      gameDate = '';
      //gameCompanyNames = [];
      gameDeveloperNames = [];
      gamePlatforms = [];
      gameAgeRatings = [];
      gameGenres = [];

      print('---------------------------------------------------------------');
      //////////////////////////////////////////////////////////////////////////
      print('this game id is currently:$gameId');
      //////////////////////////////////////////////////////////////////////////
      print('Name: ${game['name']}');
      gameTitle = game['name'];
      //////////////////////////////////////////////////////////////////////////
      print('Summary: ${game['summary']}');
      gameDescription = game['summary'];
      //////////////////////////////////////////////////////////////////////////
      int date = game['first_release_date'];
      String year;
      if (date == null) {
        year = '';
      } else {
        var milleseconds = DateTime.fromMillisecondsSinceEpoch(date * 1000);
        var dateFormatted = DateFormat('MMMM d, y').format(milleseconds);
        year = dateFormatted;
      }
      gameDate = year;
      print('First release date: $gameDate');
      //////////////////////////////////////////////////////////////////////////
      gameCoverImage = images[0].coverImageUrl;
      print('Cover Image ID: $gameCoverImage');
      //////////////////////////////////////////////////////////////////////////
      for (int i = 0; i < developerNames.length; i++) {
        String companyName = developerNames[i].developerName;

        // Check if the companyName is not already in gameCompanyNames
        if (!gameDeveloperNames.contains(companyName)) {
          gameDeveloperNames.add(companyName);
        }
      }

      for (int i = 0; i < developerNames.length; i++) {
        print('Involved Company ${i + 1}: ${gameDeveloperNames[i]}');
      }
      //////////////////////////////////////////////////////////////////////////
      for (int i = 0; i < platformNames.length; i++) {
        String platformName = platformNames[i].platformName;

        // Check if the platformName is not already in gamePlatformNames
        if (!gamePlatforms.contains(platformName)) {
          gamePlatforms.add(platformName);
        }
      }

      for (int i = 0; i < gamePlatforms.length; i++) {
        print('Platform ${i + 1}: ${gamePlatforms[i]}');
      }
      //////////////////////////////////////////////////////////////////////////
      for (int i = 0; i < ageRatingNames.length; i++) {
        int rating = ageRatingNames[i].rating;

        // Check if the rating is not already in gameAgeRatings
        if (!gameAgeRatings.contains(rating)) {
          gameAgeRatings.add(rating);
        }
      }

      for (int i = 0; i < gameAgeRatings.length; i++) {
        print('Age Rating ${i + 1}: ${gameAgeRatings[i]}');
      }

      if (gameAgeRatings.isNotEmpty) {
        List<int> _ageRatings = [];
        for (var rating in gameAgeRatings) {
          
          if (rating > 0 && rating < 13) {
            _ageRatings.add(rating);

            if(rating > 5 && rating < 13) {
              ageRating = ageRatingsLookup[rating - 1];
              break;
            }
          }

        }
        if (_ageRatings.isNotEmpty && ageRating == '') {
          int whatRating = _ageRatings.length;
          ageRating = ageRatingsLookup[_ageRatings[whatRating-1]-1];
        }
      }
      
      //////////////////////////////////////////////////////////////////////////
      for (int i = 0; i < genreNames.length; i++) {
        String genreName = genreNames[i].genreName;

        // Check if the genreName is not already in gameGenreNames
        if (!gameGenres.contains(genreName)) {
          gameGenres.add(genreName);
        }
      }

      for (int i = 0; i < gameGenres.length; i++) {
        print('Genre ${i + 1}: ${gameGenres[i]}');
      }
      //////////////////////////////////////////////////////////////////////////
      print('---------------------------------------------------------------');
    }

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
        body: isLoading ? LoadingPage() : gameWidget());
  }
}

//////////////////////////////////////////////////

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

//////////////////////////////////////////////////

class gameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 75) * (2 / 3),
                  height: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gameTitle,
                        style: TextStyle(fontSize: 20, color: fieldColor),
                      ),
                      Text(
                        gameDate,
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Developers:',
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: gameDeveloperNames.map((companyName) {
                          return Text(
                            companyName,
                            style: TextStyle(
                              fontSize: 14,
                              color: fieldColor,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 160,
                  width: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      // this allows for the rounded edges. I can't get it the way
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: gameCoverImage.isNotEmpty
                      ? Image.network(
                          gameCoverImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Text('No cover Image'),
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
                    gameDescription,
                    style: TextStyle(
                        fontSize: 16,
                        foreground: Paint()
                          ..shader = LinearGradient(
                                  colors: <Color>[textColor, backColor],
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter)
                              .createShader(Rect.fromLTWH(0.0, 0.0, 1000, 130.0))),
                  )
                ],
              ))),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width + 40,
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor, width: .25))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RATINGS',
                  style: TextStyle(color: textColor),
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
                      width: (MediaQuery.of(context).size.width - 40) * 2 / 3,
                      child: ratingAverage == 'N/A' ?
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                              color: textColor,
                              width: .25
                            )
                          )
                          ),
                        ): 
                        SfSparkBarChart(
                          data: ratingSpread,
                          color: textColor,
                          axisLineColor: textColor,
                          axisLineWidth: .25,
                        ),
                    ),
                    Column(children: [
                      Text(
                        '$ratingAverage',
                        style: TextStyle(fontSize: 20, color: textColor),
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
                    ])
                  ],
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: textColor, width: .25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    showModalBottomSheet<dynamic>(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: backColor,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return ReviewWidget(
                              id: gameIdGlob!,
                              title: gameTitle,
                              release: gameDate,
                              year: '',
                              route: '/game');
                        });
                  },
                  child: Card(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 3.5,
                      height: (MediaQuery.of(context).size.width - 80) / 3.5,
                      decoration: BoxDecoration(color: NESred, borderRadius: BorderRadius.circular(3)),
                      padding: EdgeInsets.all(10),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.videogame_asset_outlined,
                            color: fieldColor,
                          ),
                          Text(
                            'Play',
                            style: TextStyle(color: fieldColor, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'review',
                            style: TextStyle(
                              color: fieldColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String curTitle = gameTitle;
                    int curIgId = gameIdGlob!;
                    await Navigator.pushNamed(context, '/reviews', arguments: gameIdGlob);
                    gameTitle = curTitle;
                    gameIdGlob = curIgId;
                  },
                  child: Card(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 3.5,
                      height: (MediaQuery.of(context).size.width - 80) / 3.5,
                      decoration: BoxDecoration(color: textColor, borderRadius: BorderRadius.circular(3)),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.text_snippet,
                            color: fieldColor,
                          ),
                          const Text(
                            'Reviews',
                            style: TextStyle(color: fieldColor, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            numReviews,
                            style: const TextStyle(
                              color: fieldColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet<dynamic>(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: backColor,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return addToListWidget(
                              game: gameIdGlob!,
                              user: GlobalData.userId!
                          );
                        });
                  },
                  child: Card(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 3.5,
                      height: (MediaQuery.of(context).size.width - 80) / 3.5,
                      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.all(10),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.list,
                            color: fieldColor,
                          ),
                          Text(
                            'List',
                            style: TextStyle(color: fieldColor, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Add to List',
                            style: TextStyle(
                              color: fieldColor,
                            ),
                          )
                        ],
                      ),
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
              border: Border(top: BorderSide(color: textColor, width: .25)),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: gamePlatforms.map((platform) {
                    return Text(
                      platform,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: textColor, width: .25)),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:
                    [ (ageRating == '') ? const Text(
                      'unavailable',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ) :
                    Text(
                      ageRating,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    )]
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: textColor, width: .25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Genres:',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: gameGenres.map((genres) {
                    //gameGenres
                    return Text(
                      genres,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class addToListWidget extends StatefulWidget {

  addToListWidget({
    required this.game,
    required this.user
  });

  final int game;
  final String user;

  @override
  _addToListState createState() => _addToListState(game: game, user: user);

}

UserItem _user = UserItem(id: '', userName: '', firstName: '', lastName: '', email: '', bio: '', followers: [], following: [], logged: [], reviews: [], lists: [], favorites: [], spread: []);
String? _gameId;
List<InkWell> column = [];

class _addToListState extends State<addToListWidget> {

  _addToListState({
    required this.game,
    required this.user
  });

  final int game;
  final String user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchListData();
    
  }

  Future<void> fetchListData() async {

    if (mounted) {
      setState(() => isLoading = true);
    }

    column = [];

    _user = await getUserAPI.getUser(user);

    List<dynamic> lists = _user.lists;

    for (var listId in lists) {
      if (!mounted) {continue;}

      final String id = listId;

      ListItem cur = await getListsAPI.getList(id);

      int numGames = cur.games.length;

      if (!mounted) {continue;}

      InkWell list = InkWell(

        onTap: () async {
          await getListsAPI.addToList(id, '$gameIdGlob', gameTitle, gameDate);
          Navigator.pop(context);
        },

        child: Container(

          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black87, width: .25)
            )
          ),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Container(
                width: MediaQuery.sizeOf(context).width / 1.75,
                child: Text(
                  cur.name,
                  style: TextStyle(
                    color: fieldColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
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

    InkWell createList = InkWell(

      onTap: () async {
        showModalBottomSheet<dynamic>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: backColor,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
          return createListWidget();
          }
        );
      },

      child: Container(

        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black87, width: .25)
          )
        ),

        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Container(
              width: MediaQuery.sizeOf(context).width / 1.75,
              child: Text(
                'Create New List',
                style: TextStyle(
                  color: fieldColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            Text(
              '+',
              style: TextStyle(
                color: NESred,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            )

          ],

        ),

      ),

    );

    column.add(createList);

    }

    if (mounted) {
      setState(() => isLoading = false);
    }

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: MediaQuery.of(context).size.height - 32,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Add to List...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {
                      /*_rating = roundRating(_rating);
                      print(release);
                      String gameId = await AddGameAPI.searchId('$id');
                      if (gameId == '') {
                        gameId = await AddGameAPI.addGame(title, release, '$id');
                      }
                      print('saved ' + '$_rating' + ' rating of ' + title);
                      if (reviewController.text != '') {
                        isLog = false;
                      }
                      print(id);
                      String reviewId = await AddReviewAPI.createReview(GlobalData.userId!, gameId);
                      print('\n\n\n\nthis is my reviewID!!!!!!!!!' + reviewId);
                      await AddReviewAPI.updateReview(
                          GlobalData.userId!, reviewId, date, _rating, reviewController.text, isLog);
                      Navigator.of(context).popUntil(ModalRoute.withName(route));*/
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: backColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                  gameTitle,
                  style: const TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

          isLoading ? Column(children: [SizedBox(height: 50,), LoadingPage()]) : 
          Container(
            height: MediaQuery.sizeOf(context).height -160,
            child: SingleChildScrollView(  
              scrollDirection: Axis.vertical,
              child: Column(
                children: column,
              )
            )
          )
          
        ]
      )
    );

  }

}

class createListWidget extends StatefulWidget {

  @override
  _createListState createState() => _createListState();

}

class _createListState extends State<createListWidget> {

  TextEditingController listNameController = TextEditingController();
  String listNameText = '';

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: MediaQuery.of(context).size.height - 32,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Create List to Add...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () async {
                      String newListId = await getListsAPI.createList(GlobalData.userId!, listNameController.text);
                      await getListsAPI.addToList(newListId, '$gameIdGlob', gameTitle, gameTitle);
                      print('created and added to new list');
                      Navigator.of(context).popUntil(ModalRoute.withName('/game'));
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
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
                  gameTitle,
                  style: const TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.only(
              top: 10, left: 20, right: 20, bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black87, width: .25))),
            child: TextField(
              controller: listNameController,
              maxLines: null,
              style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                floatingLabelStyle:
                  TextStyle(color: Colors.transparent),
                labelText: 'List Title...',
                labelStyle: TextStyle(color: textColor, fontSize: 16),
                border:
                  OutlineInputBorder(borderSide: BorderSide.none)),
            ))
          
        ]
      )
    );

  }

}


