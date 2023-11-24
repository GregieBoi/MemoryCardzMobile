import 'package:flutter/material.dart';
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

    if (mounted) {
      setState(() {
        gamesList = api.gamesList;
        images = api2.body;
        //companyNames = api3.body;
        developerNames = api3.body;
        platformNames = api4.body;
        ageRatingNames = api5.body;
        genreNames = api6.body;
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
          }

        }
        if (_ageRatings.isNotEmpty) {
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
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
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
                      child: SfSparkBarChart(
                        data: [0.025, 0.025, 0.1, 0.05, 0.05, 1, 2, 3, 1, 1],
                        color: textColor,
                      ),
                    ),
                    Column(children: [
                      Text(
                        '3.9',
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
            decoration: BoxDecoration(border: Border(top: BorderSide(color: textColor))),
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
                    Navigator.pushNamed(context, '/reviews', arguments: gameIdGlob);
                  },
                  child: Card(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 3.5,
                      height: (MediaQuery.of(context).size.width - 80) / 3.5,
                      decoration: BoxDecoration(color: textColor, borderRadius: BorderRadius.circular(3)),
                      padding: EdgeInsets.all(10),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.text_snippet,
                            color: fieldColor,
                          ),
                          Text(
                            'Reviews',
                            style: TextStyle(color: fieldColor, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '100k',
                            style: TextStyle(
                              color: fieldColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
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
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: textColor)),
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
                        fontSize: 14,
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
              border: Border(top: BorderSide(color: textColor)),
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
              border: Border(top: BorderSide(color: textColor)),
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
