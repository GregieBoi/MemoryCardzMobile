import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/utils/ReviewsAPI.dart';
import 'package:mobile_project/utils/CoverAPI.dart';
import 'package:mobile_project/utils/GamePageAPI.dart';
import 'package:intl/intl.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/LikeAPI.dart';
import 'package:mobile_project/utils/getAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

bool isLoading = true;
String gameTitle = '';
String gameDate = '';
String gameCoverImage = '';
String? reviewIdGlob;
int? gameIdIgdbGlob;
String likeArraySize = '';
String viewingUserId = GlobalData.userId!;

ReviewItem oneReview = ReviewItem(
    id: '0',
    user: '0',
    userId: '0',
    rating: 0,
    text: '0',
    game: '0',
    isLog: true,
    likedBy: []);

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Map<String, dynamic>> gamesList = [];
  List<CoverItem> images = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Receive arguments
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Access reviewId and gameId
    final String reviewId = args?['reviewId'] ?? '';
    reviewIdGlob = reviewId;
    final int gameIdIgdb = args?['gameId'] ?? '';
    gameIdIgdbGlob = gameIdIgdb;

    fetchReviewsData();

    print('the review id in ReviewScreen is:::::::::::::::::::::: $reviewId');
  }

  Future<void> fetchReviewsData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    oneReview = await getReviewsAPI.getReview('$reviewIdGlob');
    final api = GamePageAPI();
    final api2 = CoverAPI();

    print('the game id for igdb is $gameIdIgdbGlob');
    await api.getGames(gameIdIgdbGlob);
    await api2.fetchData(gameIdIgdbGlob);

    print('the user is ${oneReview.userId}');
    print('the array is ${oneReview.likedBy}');
    likeArraySize = (oneReview.likedBy.length)?.toString() ?? '0';

    if (mounted) {
      setState(() {
        gamesList = api.gamesList;
        images = api2.body;
      });
    }
    await Future.delayed(const Duration(seconds: 0));
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var game in gamesList) {
      gameTitle = '';
      gameCoverImage = '';
      gameDate = '';

      print('Name: ${game['name']}');
      gameTitle = game['name'];

      gameCoverImage = images[0].coverImageUrl;
      print('Cover Image ID: $gameCoverImage');

      int date = game['first_release_date'];
      String year;
      if (date == null) {
        year = '';
      } else {
        var milleseconds = DateTime.fromMillisecondsSinceEpoch(date * 1000);
        var dateFormatted = DateFormat('y').format(milleseconds);
        year = dateFormatted;
      }
      gameDate = year;
    }

    return Scaffold(
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Review',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: isLoading ? LoadingPage() : ReviewWidget(review: oneReview));
  }
}

/*
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

class reviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: (MediaQuery.of(context).size.width - 60) * (2 / 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(context, '/user');
                          },
                          child: Text(
                            oneReview.user,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          gameTitle + ' (' + gameDate + ')',
                          style: TextStyle(color: fieldColor, fontSize: 20),
                        ),
                        /*
                        Text(
                          gameDate,
                          style: TextStyle(color: fieldColor, fontSize: 12),
                        ),
                        */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              width: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: int.parse(oneReview.rating) ~/ 2 +
                                    int.parse(oneReview.rating) % 2,
                                itemBuilder: (context, jndex) {
                                  if (((jndex + 1) !=
                                          (int.parse(oneReview.rating) ~/ 2 +
                                              int.parse(oneReview.rating) %
                                                  2)) ||
                                      (int.parse(oneReview.rating) % 2 == 0)) {
                                    return const Icon(
                                      Icons.star,
                                      color: NESred,
                                      size: 16,
                                    );
                                  }
                                  return const Icon(
                                    Icons.star_half,
                                    color: NESred,
                                    size: 16,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Text('edit or create date',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ))
                      ],
                    )),
                Card(
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) / 4,
                    child: Center(
                      child: gameCoverImage.isNotEmpty
                          ? Image.network(
                              gameCoverImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Text('No cover Image'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                oneReview.text,
                style: TextStyle(color: fieldColor),
              )),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.favorite_outline,
                  size: 24,
                  color: textColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'LIKE?',
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Likes ' + '100',
                  style: TextStyle(color: textColor, fontSize: 14),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
*/
class ReviewWidget extends StatefulWidget {
  final ReviewItem review;

  const ReviewWidget({Key? key, required this.review}) : super(key: key);

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  bool isLiked = false;
  // if viewingUserId exists in the review's liked_by array, then set to false

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 60) * (2 / 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context, '/user');
                        },
                        child: Text(
                          widget.review.user,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        gameTitle + ' (' + gameDate + ')',
                        style: TextStyle(color: fieldColor, fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                            width: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (widget.review.rating) ~/ 2 +
                                  (widget.review.rating) % 2,
                              itemBuilder: (context, index) {
                                if (((index + 1) !=
                                        ((widget.review.rating) ~/ 2 +
                                            (widget.review.rating) % 2)) ||
                                    ((widget.review.rating) % 2 == 0)) {
                                  return const Icon(
                                    Icons.star,
                                    color: NESred,
                                    size: 16,
                                  );
                                }
                                return const Icon(
                                  Icons.star_half,
                                  color: NESred,
                                  size: 16,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'edit or create date',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) / 4,
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, '/game',
                            arguments: int.tryParse(oneReview.game));
                      },
                      child: Center(
                        child: gameCoverImage.isNotEmpty
                            ? Image.network(
                                gameCoverImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Text('No cover Image'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Text(
              widget.review.text,
              style: TextStyle(color: fieldColor),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    size: 24,
                    color: textColor,
                  ),
                  onPressed: () async {
                    setState(() {
                      isLiked = !isLiked;
                    });

                    LikeAPI.handleLike(viewingUserId, reviewIdGlob!, isLiked);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'LIKE?',
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Likes: ' +
                      likeArraySize, // Replace with the actual number of likes
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
