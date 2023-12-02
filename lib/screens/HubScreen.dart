import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/ListsScreen.dart';
import 'package:mobile_project/utils/ReviewsAPI.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/faveGamesAPI.dart';
//import 'package:mobile_project/screens/GameScreen.dart';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:badges/badges.dart' as badges;
//import 'package:mobile_project/utils/GameAPI.dart';
import 'package:mobile_project/utils/CoverAPI.dart';
import 'package:mobile_project/utils/NameAPI.dart';
import 'package:mobile_project/utils/AddReviewAPI.dart';
import 'package:mobile_project/utils/AddGame.dart';
import 'package:intl/intl.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/getUserAPI.dart';
import 'package:mobile_project/utils/getGlobalsAPI.dart';
import 'dart:math';
import 'package:mobile_project/utils/emailAPI.dart';
import 'package:flutter/services.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);
int _selectedIndex = 0;
bool isLoading = true;
var user = UserItem(
    id: '',
    userName: '',
    firstName: '',
    lastName: '',
    email: '',
    bio: '',
    followers: [''],
    following: [''],
    logged: [''],
    reviews: [''],
    lists: [],
    favorites: [],
    spread: [0,0,0,0,0,0,0,0,0,0]);
List<String> profilePics = [
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/marioprofile-275x275.png',
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/luigiprofile-275x275.png',
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/yoshiprofile-275x275.png',
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/peachprofile-275x275.png',
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/toadprofile-275x275.png',
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/warioprofile-275x275.png',
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/waluigiprofile-275x275.png',
  'https://mariopartylegacy.com/wp-content/uploads/2011/08/dkprofile-275x275.png'
];

//List<ReviewItem> recentsIds = [];
//List<GameItem> recents = [];

class HubScreen extends StatefulWidget {
  @override
  _HubScreenState createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  //_selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    GamesWidget(),
    SearchWidget(),
    AddWidget(),
    AccountWidget()
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        showModalBottomSheet<dynamic>(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: backColor,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AddWidget();
            });
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: GFAppBar(
        leading: Transform.rotate(
          angle: 180 * pi / 180,
          child: IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'MEMORYCARDS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        unselectedItemColor: fieldColor,
        selectedItemColor: NESred,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset_outlined),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Game',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
              backgroundColor: NESred),
        ],
      ),
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

class GamesWidget extends StatefulWidget {
  @override
  _GamesWidgetState createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  List<gameCover> popularGames = [];
  List<reviewCover> friendGames = [];

  @override
  void initState() {
    super.initState();
    fetchGameData();
  }

  Future<void> fetchGameData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    List<gameCover> popCov = await getGlobalsAPI.getPopular();
    List<reviewCover> revCov = await getGlobalsAPI.getFriendReviews(GlobalData.userId!);

    if (mounted) {
      setState(() {
        popularGames = popCov;

        friendGames = revCov;
      }); 
    }

    /*
    final api = CoverAPI();
    await api.fetchData(343);
    if (mounted) {
      setState(() {
        popularGames = api.body;
        // might need to fetch friend games similarly and update the friendGames list.
        // example here, duplicate the popularGames for friendGames.
        friendGames = List.from(popularGames);
      });
    } else {
      return;
    }*/

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:0),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Popular',
                style: TextStyle(
                    color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            isLoading ? Container(
              height: 180,
              padding: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 150,
                    width: 120,
                    child: LoadingPage(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 150,
                    width: 120,
                    child: LoadingPage(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 150,
                    width: 120,
                    child: LoadingPage(),
                  )
                ],
              )
              ): 
              Container(
              height: 180,
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularGames.length,
                itemBuilder: (context, index) {
                  final game = popularGames[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/game', arguments: int.parse(game.igdbId));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4)
                      ),
                      clipBehavior: Clip.antiAlias,
                      height: 150,
                      width: 120,
                      child: isLoading
                          ? LoadingPage()
                          : game.image.isNotEmpty
                              ? Image.network(game.image,
                                  height: 170, width: 120, fit: BoxFit.fill)
                              : Container(),
                      //SizedBox(height: 5),
                      //Text(game.title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                    )
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'From Friends',
                style: TextStyle(
                    color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            isLoading ? Container(
              height: 180,
              padding: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 150,
                    width: 120,
                    child: LoadingPage(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 150,
                    width: 120,
                    child: LoadingPage(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 150,
                    width: 120,
                    child: LoadingPage(),
                  )
                ],
              )
              ): 
              Container(
              height: 180,
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: friendGames.length,
                itemBuilder: (context, index) {
                  final game = friendGames[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/review', arguments: {
                                'reviewId': game.reviewId,
                                'gameId': int.parse(game.igdbId)
                              });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4)
                      ),
                      clipBehavior: Clip.antiAlias,
                      height: 150,
                      width: 120,
                      child: isLoading
                          ? LoadingPage()
                          : game.image.isNotEmpty
                              ? Image.network(game.image,
                                  height: 170, width: 120, fit: BoxFit.fill)
                              : Container(),
                      //SizedBox(height: 5),
                      //Text(game.title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                    )
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<String> results = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16),
        child: SearchAnchor(
            viewBackgroundColor: contColor,
            dividerColor: Colors.black87,
            viewConstraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 16),
            isFullScreen: false,
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                backgroundColor: MaterialStateProperty.all(contColor),
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) async {
              _searchingWithQuery = controller.text;
              await Future.delayed(const Duration(seconds: 1));
              final List<NameItem> results =
                  (await NameAPI.fetchData(_searchingWithQuery!)).toList();

              if (_searchingWithQuery != controller.text) {
                return _lastOptions;
              }

              _lastOptions =
                  List<ListTile>.generate(results.length, (int index) {
                final NameItem item = results[index];
                return ListTile(
                    title: Text(item.title + ' ' + item.year),
                    onTap: () {
                      Navigator.pushNamed(context, '/game', arguments: item.id);
                      print(GlobalData.userId);
                    });
              });

              return _lastOptions;
            }));
  }
}

class AddWidget extends StatefulWidget {
  @override
  _AddWidgetState createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  List<String> results = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Add a Game',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: fieldColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Text(
                  'Cancel',
                  style: TextStyle(color: backColor, fontSize: 16),
                )
              ],
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(16),
              child: SearchAnchor(
                  viewBackgroundColor: contColor,
                  dividerColor: Colors.black87,
                  viewConstraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 16),
                  isFullScreen: false,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      backgroundColor: MaterialStateProperty.all(contColor),
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder: (BuildContext context,
                      SearchController controller) async {
                    _searchingWithQuery = controller.text;
                    final List<NameItem> results =
                        (await NameAPI.fetchData(_searchingWithQuery!))
                            .toList();

                    if (_searchingWithQuery != controller.text) {
                      return _lastOptions;
                    }

                    _lastOptions =
                        List<ListTile>.generate(results.length, (int index) {
                      final NameItem item = results[index];
                      return ListTile(
                          title: Text(item.title + ' ' + item.year),
                          onTap: () {
                            showModalBottomSheet<dynamic>(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: backColor,
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return ReviewWidget(
                                      id: item.id,
                                      title: item.title,
                                      release: item.release,
                                      year: item.year,
                                      route: '/hub');
                                });
                          });
                    });

                    return _lastOptions;
                  }))
        ],
      ),
    );
  }
}

class ReviewWidget extends StatefulWidget {
  ReviewWidget(
      {required this.id,
      required this.title,
      required this.release,
      required this.year,
      required this.route});
  final int id;
  final String title;
  final String release;
  final String year;
  final String route;

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState(
      id: id, title: title, release: release, year: year, route: route);
}

class _ReviewWidgetState extends State<ReviewWidget> {
  _ReviewWidgetState(
      {required this.id,
      required this.title,
      required this.release,
      required this.year,
      required this.route});
  final int id;
  final String title;
  final String release;
  final String year;
  final String route;

  String date = DateFormat('yMMMMd').format(DateTime.now());
  bool isLog = true;
  double _rating = 0;
  String userId = GlobalData.userId!;

  TextEditingController reviewController = TextEditingController();
  String reviewText = '';

  double roundRating(double rating) {
    if (rating == 0) {
      return rating;
    } else if (rating <= .5) {
      return 0.5;
    } else if (rating <= 1) {
      return 1;
    } else if (rating <= 1.5) {
      return 1.5;
    } else if (rating <= 2) {
      return 2;
    } else if (rating <= 2.5) {
      return 2.5;
    } else if (rating <= 3) {
      return 3;
    } else if (rating <= 3.5) {
      return 3.5;
    } else if (rating <= 4) {
      return 4;
    } else if (rating <= 4.5) {
      return 4.5;
    } else {
      return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(release);

    return SizedBox(
        height: MediaQuery.of(context).size.height - 32,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 20, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('I Played...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          _rating = roundRating(_rating);
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
                          print(gameId);
                          String reviewId = await AddReviewAPI.createReview(
                              GlobalData.userId!, gameId);
                          print('\n\n\n\nthis is my reviewID!!!!!!!!!' +
                              reviewId);
                          await AddReviewAPI.updateReview(
                              GlobalData.userId!,
                              reviewId,
                              date,
                              _rating,
                              reviewController.text,
                              isLog,
                              gameId);
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName(route));
                        },
                        child: const Text(
                          'Save',
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
                      title + ' ' + year,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(date,
                        style: const TextStyle(color: textColor, fontSize: 14))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black87, width: .25))),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Rated',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GFRating(
                          color: GFColors.SUCCESS,
                          borderColor: GFColors.SUCCESS,
                          allowHalfRating: true,
                          defaultIcon: const Icon(Icons.star_outline_rounded,
                              color: NESred, size: GFSize.LARGE),
                          halfFilledIcon: const Icon(Icons.star_half_rounded,
                              color: NESred, size: GFSize.LARGE),
                          filledIcon: const Icon(
                            Icons.star_rounded,
                            color: NESred,
                            size: GFSize.LARGE,
                          ),
                          size: GFSize.LARGE,
                          value: _rating,
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                              print(_rating);
                            });
                          },
                        ),
                      ],
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
                    controller: reviewController,
                    maxLines: null,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        floatingLabelStyle:
                            TextStyle(color: Colors.transparent),
                        labelText: 'Add Review...',
                        labelStyle: TextStyle(color: textColor, fontSize: 14),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ))
            ]));
  }
}

class ActivityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('BUTTS4');
  }
}

class listsAndUser {
  List<dynamic> lists;
  String userId;

  listsAndUser ({
    required this.lists,
    required this.userId
  });
}

class AccountWidget extends StatefulWidget {
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  List<GameItem> recents = [];
  List<ReviewItem> recentsIds = [];

  List<GameItem> favorites = [];

  String profilePic = profilePics[0];

  String average = 'N/A';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchUserId();
  }

  Future<void> fetchUserId() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    UserItem curUser = await getUserAPI.getUser(GlobalData.userId);

    if (mounted) {
      setState(() {
        user = curUser;
      });
    }

    String decider = user.id[user.id.length -1];

    if (decider == 'a' || decider == 'b' || decider == 'c' || decider == 'd') {
      profilePic = profilePics[0];
    }
    else if (decider == 'e' || decider == 'f' || decider == 'g' || decider == 'h') {
      profilePic = profilePics[1];
    }
    else if (decider == 'i' || decider == 'j' || decider == 'k' || decider == 'l') {
      profilePic = profilePics[2];
    }
    else if (decider == 'm' || decider == 'n' || decider == 'o' || decider == 'p') {
      profilePic = profilePics[3];
    }
    else if (decider == 'q' || decider == 'r' || decider == 's' || decider == 't') {
      profilePic = profilePics[4];
    }
    else if (decider == 'u' || decider == 'v' || decider == 'w' || decider == 'x') {
      profilePic = profilePics[5];
    }
    else if (decider == 'y' || decider == 'z') {
      profilePic = profilePics[6];
    }
    else {
      profilePic = profilePics[7];
    }

    print(user.bio);

    fetchFavorites();

    fetchRecents();

    user.spread.removeAt(0);

    int sum = 0;
    int total = 0;
    for(int i = 0; i < 10; i++) {
      int cur = user.spread[i];
      sum += cur * (i + 1);
      total += cur;
    }
    if (sum != 0) {  
      double avg = (sum/total) / 2;
      average = avg.toStringAsFixed(1);
    }

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchFavorites() async {

    List<GameItem> faves = [];

    print('\nyoooooooooooooooooooooooooooooooooooooooo\n');

    print(user.favorites);

    for (var fav in user.favorites) {

      print('\nuhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\n' + fav);

      String curId = fav as String;

      GameItem cur = await SearchGameLocal.getGame(curId);

      if(cur.id != '') {
        faves.add(cur);
      }
    }



    if (mounted) {
      setState(() {
        favorites = faves;
      });
    }
  }

  Future<void> fetchRecents() async {
    int logs = user.logged.length;
    int reviews = user.reviews.length;
    List<String> recentLogs = [];
    List<String> recentRevs = [];

    List<GameItem> rec = [];
    List<ReviewItem> recIds = [];

    if (reviews >= 4) {
      for (int i = 0; i < 4; i++) {
        recentRevs.add(user.reviews[reviews - i - 1]);
      }
    } else {
      for (int i = 0; i < reviews; i++) {
        recentRevs.add(user.reviews[reviews - i - 1]);
      }
    }

    Iterable<dynamic> blah = user.reviews.reversed;

    print(recentRevs);

    List<ReviewItem> revs = [];

    for (var rev in blah) {
      print(rev);

      if (revs.length >= 4) break;

      String curRev = rev as String;

      ReviewItem cur = await getReviewsAPI.getReview(curRev);

      if(cur.game == '') {continue;}

      revs.add(cur);

      print('I am hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

      print(cur.game);
      
      GameItem curGame = await SearchGameLocal.getGame(cur.game);

      rec.add(curGame);
    }

    print(revs);

    List<ReviewItem> lgs = [];

    for (var lg in recentLogs) {
      //lgs.add(await getReviewsAPI.getReview(lg));
    }

    for (int i = 0; i < logs + reviews; i++) {
      if (i == 0) {
        //var curRevTime = DateFormat('yMMMMd').parse(revs[i].date).millisecondsSinceEpoch;
        //var curLogTime = DateFormat('yMMMMd').parse(lgs[i].date).millisecondsSinceEpoch;

        //if (curRevTime < curLogTime)
      }
    }

    recentsIds = revs;

    if (mounted) {
      setState(() {
        recentsIds = revs;
        recents = rec;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingPage()
        : SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              badges.Badge(
                onTap: () async {
                  bool? updated = false;
                  updated = await showModalBottomSheet<bool>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: backColor,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SettingsWidget();
                      });
                    if(updated!) {didChangeDependencies();}
                },
                badgeContent: Icon(
                  Icons.settings_outlined,
                  color: Colors.black87,
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.transparent),
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: fieldColor),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    profilePic,
                    height: 60,
                    width: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                user.bio,
                style: TextStyle(color: textColor),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Favorites',
                style: TextStyle(fontSize: 20, color: textColor),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: ((MediaQuery.of(context).size.width - 44) / 4) * 1.5,
                width: (MediaQuery.of(context).size.width),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 6, right: 6),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: ((context, index) {
                      bool noFav = true;
                      GameItem curGame = GameItem(id: '', title: '', dev: '', genre: '', release: '', reviews: List.empty(), image: '', igId: '', spread: spread);;
                      String cover = '';
                      String gameId = '';
                      String localId = '';
                      if (index <= favorites.length - 1) {
                        curGame = favorites[index];
                        cover = curGame.image;
                        gameId = curGame.igId;
                        localId = curGame.id;
                        noFav = false;
                      }

                      return noFav ? 
                        InkWell(
                          onTap: () async {
                            print('\nadddddddddddddddddddddddddddddddddddddd\n');
                            bool? add = false;
                            add = await showModalBottomSheet<bool>(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              backgroundColor: backColor,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AddFavoriteWidget(gameId: '', title: '', replace: false);
                              }
                            );
                            if (add!) {
                              didChangeDependencies();
                            }
                          },
                          child: Container(
                              height:
                                  ((MediaQuery.of(context).size.width - 44) / 4) * 1.3,
                              width: (MediaQuery.of(context).size.width - 44) / 4,
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  // this allows for the rounded edges. I can't get it the way
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  color: fieldColor,
                                  ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: textColor,
                                    ),
                                    Text(
                                      'Add Favorite',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                        ) :
                        InkWell(
                          onTap: () async {
                            await Navigator.pushNamed(context, '/game', arguments: int.parse(gameId));
                          },
                          onLongPress: () async {
                            bool? changed = false;
                            changed = await showModalBottomSheet<bool>(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              backgroundColor: backColor,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return editFavoriteGame(gameId: localId, title: curGame.title);
                              }
                            );
                            if (changed!) {
                              didChangeDependencies();
                            }
                          },
                          child: Container(
                              height:
                                  ((MediaQuery.of(context).size.width - 44) / 4) * 1.3,
                              width: (MediaQuery.of(context).size.width - 44) / 4,
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  // this allows for the rounded edges. I can't get it the way
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: cover != ''
                                  ? Image.network(
                                      cover,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : Text('Failed to load')
                            )
                        );
                    }
                  )
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Recent',
                style: TextStyle(fontSize: 20, color: textColor),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: ((MediaQuery.of(context).size.width - 44) / 4) * 1.5,
                width: (MediaQuery.of(context).size.width),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 6, right: 6),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recents.length,
                    itemBuilder: ((context, index) {
                      final curRev = recentsIds[index];
                      final curGame = recents[index];
                      final cover = curGame.image;
                      final String gameId = curGame.igId;
                      final revId = curRev.id;

                      return InkWell(
                          onTap: () async {
                            bool deleted = false;
                            deleted = await Navigator.pushNamed(context, '/review', arguments: {
                              'reviewId': revId,
                              'gameId': int.parse(gameId)
                            }) as bool;
                            if (deleted) {print('ahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');didChangeDependencies();}
                          },
                          child: Container(
                              height:
                                  ((MediaQuery.of(context).size.width - 44) / 4) * 1.3,
                              width: (MediaQuery.of(context).size.width - 44) / 4,
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  // this allows for the rounded edges. I can't get it the way
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: cover != ''
                                  ? Image.network(
                                      cover,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : Text('Failed to load')));
                    })),
                /*scrollDirection: Axis.horizontal,
            children: <Card>[
              Card(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width / 4) * 1.25,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
            ],
          ),*/
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width + 40,
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: contColor, width: .25))),
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
                          child: average == 'N/A' ? 
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
                              data: user.spread,
                              color: textColor,
                              axisLineColor: textColor,
                              axisLineWidth: .25,
                          ),
                        ),
                        Column(children: [
                          Text(
                            average,
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
              InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, '/games',
                      arguments: {'reviews': user.reviews});
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Games',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
              ),
              InkWell(
                onTap: () async {
                  bool? deleted = false;
                  deleted = await Navigator.pushNamed(context, '/diary',
                      arguments: user.reviews) as bool;
                  if (deleted) {print('heyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');didChangeDependencies();}
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diary',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, '/lists', arguments: listsAndUser(lists: user.lists, userId: user.id));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lists',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
              ),
              InkWell(
                onTap: () async {
                  print(user.lists[0]);
                  final String shelf = user.lists[0];
                  print('butts');
                  print(shelf);
                  Navigator.pushNamed(context, '/shelf', arguments: listAndUser(listId: shelf, userId: user.id));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shelf',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, '/following',
                      arguments: user.following);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Following',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, '/follower',
                      arguments: user.followers);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Followers',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
              ),
            ],
          ));
  }
}


String updatedBio = '';
bool? somethingUpdated = false;

class SettingsWidget extends StatelessWidget {

  //bool? somethingUpdated = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 32,
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('Cancel',
                            style: TextStyle(color: backColor, fontSize: 16)),
                      ),
                      Text('Settings',
                          style: TextStyle(color: fieldColor, fontSize: 20)),
                      GestureDetector(
                        onTap: () async {
                          bool updated = somethingUpdated!;
                          if(!updated) {print('\nnotUpdated\n');}
                          if (updated) {
                            print('\nupdated\n');
                            await getUserAPI.updateUser(user.id, user.firstName, user.lastName, user.userName, GlobalData.password!, user.email, updatedBio);
                          }
                          Navigator.pop(context, somethingUpdated);
                        },
                        child: Text('  Done',
                            style: TextStyle(
                                color: NESred,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: textColor, width: .25))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Signed in as ',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      Text(
                        GlobalData.username!,
                        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    emailAPI.verifyReset(user.email);
                    showModalBottomSheet<dynamic>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: backColor,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return verifyWidget(email: user.email);
                    }
                  );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reset Password',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context)
                      ..pop(somethingUpdated)
                      ..pop();
                  },
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign Out',
                          style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Transform.rotate(
                          angle: 180 * pi / 180,
                          child: Icon(
                            Icons.logout,
                            color: NESred,
                          )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: textColor, width: .25))),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                /*Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: textColor, width: .25))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: textColor,
                      )
                    ],
                  ),
                ),*/
                InkWell(
                  onTap: () async {
                    String? newBio = user.bio;
                    newBio = await showModalBottomSheet<String>(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: backColor,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return editBio();
                    });
                    print(newBio);
                    if (newBio != user.bio) {updatedBio = newBio!; somethingUpdated = true;}
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bio',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: textColor,
                        )
                      ],
                    ),
                  ),
                ),
                /*Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: .25))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Icons',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: fieldColor),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: fieldColor),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: fieldColor),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: fieldColor),
                            ),
                          ],
                        ),
                      ],
                    )),*/
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: textColor, width: .25))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delete Account',
                        style: TextStyle(
                            color: NESred,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: NESred,
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}

class editBio extends StatefulWidget {

    @override
    _editBioState createState() => _editBioState();

  }

  class _editBioState extends State<editBio> {

    TextEditingController bioController = TextEditingController();

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();

      bioController.text = user.bio;
    }

    @override
    Widget build(BuildContext context) {

      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 2 / 3,
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
                        onPressed: () => Navigator.pop(context, user.bio),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Edit Bio...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          print('delete');
                          //await getListsAPI.updateListName(list.id, listNameController.text);
                          Navigator.of(context)
                              ..pop(bioController.text);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: NESred,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black87, width: .25))),
                child: TextField(
                  controller: bioController,
                  maxLines: null,
                  style: const TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    floatingLabelStyle:
                      TextStyle(color: Colors.transparent),
                    labelText: 'Edit Bio...',
                    labelStyle: TextStyle(color: textColor, fontSize: 16),
                    border:
                      OutlineInputBorder(borderSide: BorderSide.none)),
                )),
                
                

            ]));

    }

  }

class AddFavoriteWidget extends StatefulWidget {

  final String gameId;
  final String title;
  final bool replace;

  AddFavoriteWidget ({
    required this.gameId,
    required this.title,
    required this.replace
  });

  @override
  _AddFavoriteWidgetState createState() => _AddFavoriteWidgetState(gameId: gameId, title: title, replace: replace);
}

class _AddFavoriteWidgetState extends State<AddFavoriteWidget> {

  final String gameId;
  final String title;
  final bool replace;

  _AddFavoriteWidgetState ({
    required this.gameId,
    required this.title,
    required this.replace
  });

  List<String> results = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),

                replace ? const Text(
                  'Replace Favorite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fieldColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ) :
                const Text(
                  'Add a Favorite',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fieldColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
                const Text(
                  'Cancel',
                  style: TextStyle(color: backColor, fontSize: 16),
                )
              ],
            ),
          ),
          replace ? 
          Container(
            decoration: const BoxDecoration(color: Colors.black87),
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ) : 
          Container(height: 0),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(16),
              child: SearchAnchor(
                  viewBackgroundColor: contColor,
                  dividerColor: Colors.black87,
                  viewConstraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 16),
                  isFullScreen: false,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      backgroundColor: MaterialStateProperty.all(contColor),
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder: (BuildContext context,
                      SearchController controller) async {
                    _searchingWithQuery = controller.text;
                    final List<NameItem> results =
                        (await NameAPI.fetchData(_searchingWithQuery!))
                            .toList();

                    if (_searchingWithQuery != controller.text) {
                      return _lastOptions;
                    }

                    _lastOptions =
                        List<ListTile>.generate(results.length, (int index) {
                      final NameItem item = results[index];
                      return ListTile(
                          title: Text(item.title + ' ' + item.year),
                          onTap: () async {
                            if (replace) {await faveGamesAPI.deleteFavorite(user.id, gameId);} 
                            String igId = item.id.toString();
                            // deleting await may keep from having the double tap issue staying
                            await faveGamesAPI.addFavorite(user.id, igId, item.title, item.release);
                            if (replace) {
                              Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pop(true);
                            }
                            else {
                              Navigator.of(context)
                                ..pop()
                                ..pop(true);
                            }
                          });
                    });

                    return _lastOptions;
                  }))
        ],
      ),
    );
  }
}

class editFavoriteGame extends StatefulWidget {

    final String gameId;
    final String title;

    editFavoriteGame ({required this.gameId, required this.title});

    @override
    _editFavoriteState createState() => _editFavoriteState(gameId: gameId, title: title);

  }

  class _editFavoriteState extends State<editFavoriteGame> {

    String gameId;
    String title;

    _editFavoriteState({required this.gameId, required this.title});

    @override
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
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Edit Favorite...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const Text(
                      'Delete',
                      style: TextStyle(
                          color: backColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
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
                      title,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  bool? edited = false;
                  edited = await showModalBottomSheet<bool>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: backColor,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return AddFavoriteWidget(gameId: gameId, title: title, replace: true);
                  });
                  //if (edited!) {didChangeDependencies();}
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Replace',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ]
                  ),
                )
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: backColor,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return deleteFavoriteGame(gameId: gameId, title: title);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
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
              )
            ]));

    }

  }

class deleteFavoriteGame extends StatefulWidget {

    final String gameId;
    final String title;

    deleteFavoriteGame ({required this.gameId, required this.title});

    @override
    _deleteFavoriteState createState() => _deleteFavoriteState(gameId: gameId, title: title);

  }

class _deleteFavoriteState extends State<deleteFavoriteGame> {

    String gameId;
    String title;

    _deleteFavoriteState({required this.gameId, required this.title});

    @override
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
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Delete...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          print('delete');
                          await faveGamesAPI.deleteFavorite(user.id, gameId);
                          Navigator.of(context)
                              ..pop()
                              ..pop(true);
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
                      'Delete ' + title + ' from ' + 'favorites' + '?',
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

  class verifyWidget extends StatefulWidget {

  final String email;

  verifyWidget({
    required this.email
  });

  _verifyState createState() => _verifyState(email: email);

}

class _verifyState extends State<verifyWidget> {

  final String email;

  _verifyState({
    required this.email
  });

  String obscuredEmail = '';
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String obscured = '';
    bool skip = false;
    bool at = false;

    for (int i = 0; i < email.length; i++) {

      if (skip) {skip = false; continue;}

      String cur = email[i];

      if (i == 0) {
        obscured = cur;
      }
      else if (cur == '@') {
        obscured = obscured.substring(0,i-1) + email[i-1] + cur + email[i+1];
        at = true;
        skip = true;
      }
      else if (cur == '.' && at) {
        obscured = obscured.substring(0,i-1) + email.substring(email.length-5, email.length);
        break;
      }
      else {
        obscured = obscured + '*';
      }

    }

    if(mounted) {
      setState(() {
        obscuredEmail = obscured;
      });
    }

  }

  String pin1 = '';
  String pin2 = '';
  String pin3 = '';
  String pin4 = '';
  String pin5 = '';
  String pin6 = '';
  String message = '';

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context)
                      ..pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Verify Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: fieldColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    if (pin1+pin2+pin3+pin4+pin5+pin6 == verificationToken) {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: backColor,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return passwordWidget(email: email);
                        }
                      );
                    }
                    else {
                      setState(() {
                        message = 'Incorrect Code';
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                  )
                )
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
                  'Verification code sent to ' + obscuredEmail,
                  style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Form(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin1 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin2 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin3 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin4 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin5 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin6 = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              message,
              style: const TextStyle(
                color: NESred,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        ]
      ),
    );

  }

}

class passwordWidget extends StatefulWidget {

  final String email;

  passwordWidget({
    required this.email
  });

  _passwordState createState() => _passwordState(email: email);

}

class _passwordState extends State<passwordWidget> {

  final String email;

  _passwordState({
    required this.email
  });

  String message = '';
  RegExp passExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context)
                      ..pop()
                      ..pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Enter New Password...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: fieldColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    bool complex = passExp.hasMatch(passwordController.text);
                    if (complex) {
                      emailAPI.changePassword(email, passwordController.text);
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }
                    else {
                      setState(() {
                        message = 'Password must be at least 8 characters long, contain upper and lower case characters, a number, and special character';
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                  )
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: textColor, width: .25)
              )
            ),
            child: TextField(
              controller: passwordController,
              maxLines: 1,
              obscureText: true,
              style: const TextStyle(
                color: textColor,
                fontSize: 16
              ),
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.transparent),
                labelText: 'New Password...',
                labelStyle: TextStyle(color: textColor, fontSize: 16),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              message,
              style: TextStyle(
                color: NESred,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        ]
      )
    );

  }

}