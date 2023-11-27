import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/ReviewsAPI.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/getUserAPI.dart';
import 'package:mobile_project/screens/ListsScreen.dart';
import 'package:mobile_project/screens/HubScreen.dart';


const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

bool isLoading = true;
UserItem user = UserItem(id: '', userName: '', firstName: '', lastName: '', email: '', bio: '', followers: [], following: [], logged: [], reviews: [], lists: []);
String? userIdGlob;
bool isFollowed = false;

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}


class _UserScreenState extends State<UserScreen> {

  List<GameItem> recents = [];
  List<ReviewItem> recentsIds = [];

  String? userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    userId = ModalRoute.of(context)?.settings.arguments as String;
    userIdGlob = userId;

    fetchUserId();
  }

  Future<void> fetchUserId() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    user = await getUserAPI.getUser(userId);
    print(user.bio);
    fetchRecents();

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchRecents() async {
    int logs = user.logged.length;
    int reviews = user.reviews.length;
    List<String> recentLogs = [];
    List<String> recentRevs = [];

    List<GameItem> rec = [];
    List<ReviewItem> recIds = [];

    if (logs >= 4) {
      for (int i = 0; i < 4; i++) {
        recentLogs.add(user.logged[logs - i - 1]);
      }
    } else {
      for (int i = 0; i < logs; i++) {
        recentLogs.add(user.logged[logs - i - 1]);
      }
    }
    if (reviews >= 4) {
      for (int i = 0; i < 4; i++) {
        recentRevs.add(user.reviews[reviews - i - 1]);
      }
    } else {
      for (int i = 0; i < reviews; i++) {
        recentRevs.add(user.reviews[reviews - i - 1]);
      }
    }

    print(recentLogs);
    print(recentRevs);

    List<ReviewItem> revs = [];

    for (var rev in recentRevs) {
      print(rev);

      ReviewItem cur = await getReviewsAPI.getReview(rev);

      revs.add(cur);

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

    setState(() {
      isFollowed = false;
    });

    for (var follower in user.followers) {

      String curFollower = follower as String;

      if (curFollower == GlobalData.userId) {
        setState(() {
          isFollowed = true;
        });
      }

    }

    if (mounted) {
      setState(() {
        recentsIds = revs;
        recents = rec;
      });
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
            user.userName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: isLoading ? LoadingPage() :
          SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              GFAvatar(
                shape: GFAvatarShape.circle,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isFollowed = !isFollowed;
                  });

                  isFollowed ? await getUserAPI.followUser(GlobalData.userId!, user.id) : await getUserAPI.unfollowUser(GlobalData.userId!, user.id);
                  
                },
                child: isFollowed ? 
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: NESred),
                      color: NESred
                    ),
                    child: Text(
                      'Followed',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ) :
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: NESred)
                    ),
                    child: Text(
                      'Follow',
                      style: TextStyle(
                        color: NESred,
                      ),
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
                height: (MediaQuery.of(context).size.width / 4) * 1.25,
                width: (MediaQuery.of(context).size.width),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
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
                        height: (MediaQuery.of(context).size.width / 5),
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
                            if (deleted) {didChangeDependencies();}
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
                          width:
                              (MediaQuery.of(context).size.width - 40) * 2 / 3,
                          child: SfSparkBarChart(
                            data: [
                              0.025,
                              0.025,
                              0.1,
                              0.05,
                              0.05,
                              1,
                              2,
                              3,
                              1,
                              1
                            ],
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
              InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, '/games',
                      arguments: {'reviews': user.reviews});
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: contColor, width: .25))),
                  child: Text(
                    'Games',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, '/diary',
                      arguments: user.reviews);
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: contColor, width: .25))),
                  child: Text(
                    'Diary',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, '/lists', arguments: listsAndUser(lists: user.lists, userId: user.id));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: contColor, width: .25))),
                  child: Text(
                    'Lists',
                    style: TextStyle(fontSize: 16, color: textColor),
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
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: contColor, width: .25))),
                  child: Text(
                    'Shelf',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  UserItem curUser = user;
                  await Navigator.pushNamed(context, '/following',
                      arguments: user.following);
                  user = curUser;
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: contColor, width: .25))),
                  child: Text(
                    'Following',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  UserItem curUser = user;
                  await Navigator.pushNamed(context, '/follower',
                      arguments: user.followers);
                  user = curUser;
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: contColor, width: .25))),
                  child: Text(
                    'Followers',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
              ),
            ],
          ))


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

class userWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          GFAvatar(
            shape: GFAvatarShape.circle,
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: NESred)
            ),
            child: Text(
              'Follow',
              style: TextStyle(
                color: NESred,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text(
            'This is my bio',
            style: TextStyle(color: textColor),
          ),
          SizedBox(height: 20,),
          Text(
            'Favorites',
            style: TextStyle(
              fontSize: 20,
              color: textColor
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: (MediaQuery.of(context).size.width/4)*1.25,
            width: (MediaQuery.of(context).size.width),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Card>[
                Card(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.width/4)*1.25,
                      width: MediaQuery.of(context).size.width/5,
                      child: Center(child: Text('Card1'),),
                    ),
                  ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Text(
            'Recent',
            style: TextStyle(
              fontSize: 20,
              color: textColor
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: (MediaQuery.of(context).size.width/4)*1.25,
            width: (MediaQuery.of(context).size.width),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Card>[
                Card(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.width/4)*1.25,
                      width: MediaQuery.of(context).size.width/5,
                      child: Center(child: Text('Card1'),),
                    ),
                  ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width/5,
                    child: Center(child: Text('Card1'),),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Container(

            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width + 40,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: contColor)
              )

            ),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  'RATINGS',
                  style: TextStyle(
                    color: textColor
                  ),  
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
                      width: (MediaQuery.of(context).size.width - 40) * 2/3,
                    
                      child: SfSparkBarChart(

                        data: [0.025,0.025,0.1,0.05,0.05,1,2,3,1,1],
                        color: textColor,

                      ),
                    
                    ),

                    Column(
                      children: [ 
                        Text(
                          '3.9',
                          style: TextStyle(
                            fontSize: 20,
                            color: textColor
                          ),
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
                      ]
                    )

                  ],

                )

              ],

            ),

          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/games');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Games',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/games');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Diary',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/game');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Lists',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/shelf');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Shelf',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/following');
            },
            child: Container(
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
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/follower');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: contColor)
                )
              ),
              child: Text(
                'Followers',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor
                ),
              ),
            ),
          ),
        ],
      )
    );

  }

}