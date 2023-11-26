import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/utils/ReviewsAPI.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:intl/intl.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

bool isLoading = true;
List<dynamic>? userReviewsGlobal = [];
List<ReviewItem> reviews = [];
List<GameItem> gameIgdbIds = [];
List<String> releaseDates = [];
List<String> editDates = [];
int length = 0;

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Extract reviews from the arguments
    final List<dynamic>? reviews =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>?;

    userReviewsGlobal = reviews;

    // Find the length of userReviewsGlobal
    if (userReviewsGlobal != null) {
      length = userReviewsGlobal!.length;
    } else {
      length = 0;
    }

    fetchReviewsData();

    print('the reviews in DiaryScreen are::::::::::::::: $userReviewsGlobal');
  }

  Future<void> fetchReviewsData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    // Initialize the reviews list with empty ReviewItems
    reviews = List.generate(
        length,
        (index) => ReviewItem(
            id: '0',
            user: '0',
            userId: '0',
            text: '0',
            rating: 0,
            game: '0',
            isLog: false,
            likedBy: [],
            editDate: '0'));

    // Initialize the reviews list with empty ReviewItems
    gameIgdbIds = List.generate(
        length,
        (index) => GameItem(
            id: '0',
            title: '0',
            dev: '0',
            genre: '0',
            release: '0',
            reviews: [],
            image: '0',
            igId: '0'));

    // each index in reviews represents a different review
    for (int i = 0; i < length; i++) {
      reviews[i] = await getReviewsAPI.getReview('${userReviewsGlobal?[i]}');
      //print('the review is::::::::: ${reviews[i].text}');
    }

    //print('the review for latest one is: ${reviews[length - 1].text}');
    //print('the game id is: ${reviews[length - 1].game}');

    // each index in gameIgdbIds represents a different game for that review
    for (int i = 0; i < length; i++) {
      gameIgdbIds[i] = await SearchGameLocal.getGame('${reviews[i].game}');
    }

    // game release date calculation
    releaseDates = [];

    for (int i = 0; i < length; i++) {
      String releaseDate = gameIgdbIds[i].release;

      List<String> dateParts = releaseDate.split(', ');

      releaseDates.add(dateParts.length == 2 ? dateParts[1] : '');
    }

    // review date calculation
    editDates = [];

    for (int i = 0; i < length; i++) {
      String editDateString = reviews[i].editDate;

      DateTime dateTime = DateFormat('MMMM dd, yyyy').parse(editDateString);
      String formattedDate = DateFormat('MM/dd/yy').format(dateTime);

      editDates.add(formattedDate);
    }

    await Future.delayed(const Duration(seconds: 0));
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
            'Diary',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: isLoading ? LoadingPage() : 
          Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          final theIgdb = gameIgdbIds[index];
          final theRelease = releaseDates[index];
          final theEditDate = editDates[index];
          return InkWell(
            onTap: () async {
              bool deleted = false;
              deleted = await Navigator.pushNamed(context, '/review', arguments: {
                'reviewId': review.id,
                'gameId': int.parse(theIgdb.igId),
              }) as bool;
              if (deleted) {didChangeDependencies();}
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: textColor, width: .25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: textColor)),
                    child: Text(
                      theEditDate,
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                  ),
                  Container(
                  width: MediaQuery.sizeOf(context).width * .65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Text(
                            theIgdb.title + ' ',
                            style: TextStyle(
                              fontSize: 12,
                              color: fieldColor,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            theRelease,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 10,
                            ),
                          )
                        ]
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              width: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: review.rating ~/ 2 + review.rating % 2,
                                itemBuilder: (context, jndex) {
                                  if (((jndex + 1) !=
                                          (review.rating ~/ 2 +
                                              review.rating % 2)) ||
                                      (review.rating % 2 == 0)) {
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
                      ),
                    ],
                  ),),/*
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: review.rating ~/ 2 + review.rating % 2,
                            itemBuilder: (context, jndex) {
                              if (((jndex + 1) !=
                                      (review.rating ~/ 2 +
                                          review.rating % 2)) ||
                                  (review.rating % 2 == 0)) {
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Added: Review date
                  Text(
                    'Review Date: ${theEditDate}',
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Added: Game name
                  Text(
                    'Game Name: ${theIgdb.title}',
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Added: Game release year
                  Text(
                    'Release Year: ${theRelease}',
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    ));
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

/*
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/review');
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: textColor))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: textColor)),
                    child: Text(
                      '11/12/23: ',
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resident Evil 2 ' + '(20XX)',
                        style: TextStyle(
                          fontSize: 12,
                          color: fieldColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star,
                            color: NESred,
                            size: 12,
                          ),
                          Icon(
                            Icons.star,
                            color: NESred,
                            size: 12,
                          ),
                          Icon(
                            Icons.star,
                            color: NESred,
                            size: 12,
                          ),
                          Icon(
                            Icons.star,
                            color: NESred,
                            size: 12,
                          ),
                          Icon(
                            Icons.star,
                            color: NESred,
                            size: 12,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
      ],
    ));
  }*/

class diaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          final theIgdb = gameIgdbIds[index];
          final theRelease = releaseDates[index];
          final theEditDate = editDates[index];
          return InkWell(
            onTap: () async {
              await Navigator.pushNamed(context, '/review', arguments: {
                'reviewId': review.id,
                'gameId': int.parse(theIgdb.igId),
              }) as bool;
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: textColor, width: .25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: textColor)),
                    child: Text(
                      theEditDate,
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                  ),
                  Container(
                  width: MediaQuery.sizeOf(context).width * .65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          Text(
                            theIgdb.title + ' ',
                            style: TextStyle(
                              fontSize: 12,
                              color: fieldColor,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            theRelease,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 10,
                            ),
                          )
                        ]
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              width: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: review.rating ~/ 2 + review.rating % 2,
                                itemBuilder: (context, jndex) {
                                  if (((jndex + 1) !=
                                          (review.rating ~/ 2 +
                                              review.rating % 2)) ||
                                      (review.rating % 2 == 0)) {
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
                      ),
                    ],
                  ),),/*
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: review.rating ~/ 2 + review.rating % 2,
                            itemBuilder: (context, jndex) {
                              if (((jndex + 1) !=
                                      (review.rating ~/ 2 +
                                          review.rating % 2)) ||
                                  (review.rating % 2 == 0)) {
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Added: Review date
                  Text(
                    'Review Date: ${theEditDate}',
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Added: Game name
                  Text(
                    'Game Name: ${theIgdb.title}',
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Added: Game release year
                  Text(
                    'Release Year: ${theRelease}',
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
