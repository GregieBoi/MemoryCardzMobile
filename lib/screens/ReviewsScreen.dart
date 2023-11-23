import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/ReviewsAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

int? gameIdGlob;
bool isLoading = true;
List<ReviewItem> reviews = [];

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int? gameId; // variable to store gameID

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // access the id argument passed from HubScreen
    gameId ??= ModalRoute.of(context)?.settings.arguments as int?;
    gameIdGlob = gameId;
    fetchReviewsData();

    print('the game in ReviewsScreen is:::::::::::::::::::::::::::::: $gameId');
  }

  Future<void> fetchReviewsData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    reviews = await getReviewsAPI.getReviews('$gameIdGlob');

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
            'Reviews',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: isLoading ? LoadingPage() : reviewsWidget());
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

class reviewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/review');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: textColor, width: .25), )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              if(((jndex + 1) != (review.rating ~/ 2 + review.rating % 2)) || (review.rating % 2 == 0)) {
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
                        Text(
                          review.user,
                          style: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    review.text,
                    style: TextStyle(color: textColor),
                  )
                ],
              ),
            ),
          );
        },
        /*
        children: [
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, '/review');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: textColor))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                          ],
                        ),
                        Text(
                          'UserName',
                          style: TextStyle(color: textColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'blah blah blah',
                    style: TextStyle(color: textColor),
                  )
                ],
              ),
            ),
          ),
        ],*/
      ),
    );
  }
}
