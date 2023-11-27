import 'package:mobile_project/utils/ReviewsAPI.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/getAPI.dart';
import 'dart:convert';

class getGlobalsAPI {

  static Future<List<gameCover>> getPopular() async {

    String payload = '{}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/latestReviews';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      List<dynamic> popularIds = [];
      if (jsonObject['popular'] != null) {
        popularIds = jsonObject['popular'];
      }

      List<gameCover> popular = [];
      List<String> gameIds = [];

      for (var id in popularIds) {

        if (gameIds.contains(id)) {continue;}

        gameIds.add(id);

        GameItem cur = await SearchGameLocal.getGame(id);

        if(cur.id == '') {continue;}

        gameCover curCover = gameCover(image: cur.image, igdbId: cur.igId);

        popular.add(curCover);
      }

      return popular;

    } catch (e) {
      print('getPopular failed');
      return List<gameCover>.empty(); 
    }

  }

  static Future<List<reviewCover>> getFriendReviews(String userId) async {

    String payload = '{"userId":"' + userId.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/latestFollowingReviews';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      List<dynamic> reviewIds = [];
      if (jsonObject['reviews'] != null) {
        reviewIds = jsonObject['reviews'];
      }

      List<reviewCover> friendReviews = [];

      print('\nIm here\n');

      for (var id in reviewIds) {

        print('\nIm here\n');

        print('\nIm fetching this review ' + id + '\n');

        ReviewItem cur = await getReviewsAPI.getReview(id);

        GameItem curGame = await SearchGameLocal.getGame(cur.game);

        reviewCover curCover = reviewCover(image: curGame.image, reviewId: cur.id, igdbId: curGame.igId);

        friendReviews.add(curCover);
      }

      return friendReviews;

    } catch (e) {
      print('getFriend failed');
      return List<reviewCover>.empty(); 
    }

  }

}

class gameCover {

  final String image;
  final String igdbId;

  gameCover({
    required this.image,
    required this.igdbId
  });

}

class reviewCover {

  final String image;
  final String reviewId;
  final String igdbId;

  reviewCover({
    required this.image,
    required this.reviewId,
    required this.igdbId
  });

}