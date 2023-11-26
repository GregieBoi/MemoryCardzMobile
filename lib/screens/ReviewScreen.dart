import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/utils/ReviewsAPI.dart';
import 'package:mobile_project/utils/CoverAPI.dart';
import 'package:mobile_project/utils/GamePageAPI.dart';
import 'package:intl/intl.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/LikeAPI.dart';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/AddReviewAPI.dart';

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
int likeArraySize = 0;
String viewingUserId = GlobalData.userId!;
bool isLiked = false;
List<InkWell> edits = [];
InkWell edit = InkWell();
InkWell delete = InkWell();
bool? edited = false;

ReviewItem oneReview = ReviewItem(
    id: '0',
    user: '0',
    userId: '0',
    rating: 0,
    text: '0',
    game: '0',
    isLog: true,
    likedBy: [],
    editDate: '0');

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => new _ReviewScreenState();
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

    List<String> likedBy = oneReview.likedBy; 

    print('the game id for igdb is $gameIdIgdbGlob');
    await api.getGames(gameIdIgdbGlob);
    await api2.fetchData(gameIdIgdbGlob);

    print('the user is ${oneReview.userId}');
    print('the array is ${oneReview.likedBy}');
    likeArraySize = (oneReview.likedBy.length);

    isLiked = false;

    for (int i = 0; i < likeArraySize; i++) {
      if (oneReview.likedBy[i] == viewingUserId) {
        print('this user already liked this review!!!!!!!!!!!!!!!!');
        isLiked = true;
      }
    }

    if (mounted) {
      setState(() {
        gamesList = api.gamesList;
        images = api2.body;
      });
    }

    edit = InkWell(child: Container(height: 0),);
    delete = InkWell(child: Container(height: 0),);

    if (GlobalData.userId == oneReview.userId && mounted) {

      print(GlobalData.userId! +'is'+ oneReview.user);

      edit = InkWell(
        onTap: () async {
          bool? edit = false;
          edit = await showModalBottomSheet<bool>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            backgroundColor: backColor,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return editReviewWidget(
                  id: gameIdIgdbGlob!,
                  title: gameTitle,
                  release: gameDate,
                  year: '',
                  route: '/hub',
                  reviewId: oneReview.id,
                  text: oneReview.text,
                  rating: oneReview.rating,
                );
            });
          if (edit!) {edited = edit; didChangeDependencies();}
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          width: MediaQuery.sizeOf(context).width,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: textColor, width: .25)
            )
          ),

          child: Text(
            'Edit Review',
            style: TextStyle(
              color: textColor,
              fontSize: 16
            ),
          ),
        ),
      );

      edits.add(edit);
      
      delete = InkWell(
        onTap: () async {
          showModalBottomSheet<dynamic>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            backgroundColor: backColor,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return deleteReviewWidget(
                  reviewId: oneReview.id,
                );
            });
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          width: MediaQuery.sizeOf(context).width,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: textColor, width: .25)
            )
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delete Review',
                style: TextStyle(
                  color: NESred,
                  fontSize: 16,
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
        ),
      );

      edits.add(delete);

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white
          ),
          onPressed: (() => Navigator.of(context).pop(edited)),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'Review',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isLoading ? LoadingPage() : ReviewWidget(review: oneReview),
    );
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.width / 1.75,
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
                        oneReview.editDate,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      // this allows for the rounded edges. I can't get it the way
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 60 ) / 2.5, // (MediaQuery.of(context).size.width - 44) / 4,
                    height: 160, //((MediaQuery.of(context).size.width - 44) / 4) * 1.5,
                    child: InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, '/game',
                            arguments: gameIdIgdbGlob);
                      },
                      child: Center(
                        child: gameCoverImage.isNotEmpty
                            ? Image.network(
                                gameCoverImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Text('Failed to Load'),
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
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    size: 24,
                    color: isLiked ? NESred : textColor,
                  ),
                  onPressed: () async {
                    setState(() {
                      isLiked = !isLiked;
                    });

                    if (isLiked == false) likeArraySize -= 1;
                    if (isLiked == true) likeArraySize += 1;

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
                      likeArraySize
                          .toString(), // Replace with the actual number of likes
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              ],
            ),
          ),
          edit,
          delete
        ],
      ),
    );
  }
}

class editReviewWidget extends StatefulWidget {
  editReviewWidget(
      {required this.id,
      required this.title,
      required this.release,
      required this.year,
      required this.route,
      required this.rating,
      required this.text,
      required this.reviewId
    });
  final int id;
  final String title;
  final String release;
  final String year;
  final String route;
  final int rating;
  final String text;
  final String reviewId;

  @override
  _editReviewWidgetState createState() => _editReviewWidgetState(
      id: id, title: title, release: release, year: year, route: route, rating: rating, text: text, reviewId: reviewId);
}

class _editReviewWidgetState extends State<editReviewWidget> {
  _editReviewWidgetState(
      {required this.id,
      required this.title,
      required this.release,
      required this.year,
      required this.route,
      required this.rating,
      required this.text,
      required this.reviewId
    });
  final int id;
  final String title;
  final String release;
  final String year;
  final String route;
  final int rating;
  final String text;
  final String reviewId;

  String date = DateFormat('yMMMMd').format(DateTime.now());
  bool isLog = true;
  double _rating = 0;
  String userId = GlobalData.userId!;

  TextEditingController reviewController = TextEditingController();
  String reviewText = '';

  double roundRating(double rating) {
    if (rating <= 0) {
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    _rating = rating.toDouble() / 2 - .01;
    print(_rating);
    reviewController.text = text;

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
                    left: 5, right: 5, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Update...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          _rating = roundRating(_rating);
                          print(release);
                          String gameId = oneReview.game;//await AddGameAPI.searchId('$id');
                          if (gameId == '') {
                            gameId =
                                await '';// AddGameAPI.addGame(title, release, '$id');
                          }
                          print('saved ' + '$_rating' + ' rating of ' + title);
                          if (reviewController.text != '') {
                            isLog = false;
                          }
                          print(id);
                          await AddReviewAPI.updateReview(
                              GlobalData.userId!,
                              reviewId,
                              date,
                              _rating,
                              reviewController.text,
                              isLog);
                          Navigator.of(context)
                              ..pop(true);
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
                        labelText: 'Edit Review...',
                        labelStyle: TextStyle(color: textColor, fontSize: 14),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ))
            ]));
  }
}

class deleteReviewWidget extends StatefulWidget {
  
  final String reviewId;

  deleteReviewWidget({
    required this.reviewId
  });

  @override
  _deleteReviewState createState() => _deleteReviewState(reviewId: reviewId);
}

class _deleteReviewState extends State<deleteReviewWidget> {
  
  final String reviewId;

  _deleteReviewState({
    required this.reviewId
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
                    const Text('Delete Review...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          await getReviewsAPI.deleteReview(reviewId);
                          Navigator.of(context)
                              ..pop()
                              ..pop(true);
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


