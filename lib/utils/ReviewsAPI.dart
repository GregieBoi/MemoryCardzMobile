import 'package:mobile_project/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_project/utils/AddGame.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/getUserAPI.dart';

class getReviewsAPI {
  static Future<List<ReviewItem>> getReviews(String id) async {
    String gameId = '';
    List<ReviewItem> reviewList = [];

    gameId = await AddGameAPI.searchId(id);

    if (gameId != '') {
      GameItem game = await SearchGameLocal.getGame(gameId);

      List<dynamic> reviews = game.reviews;

      for (var review in reviews) {
        ReviewItem cur = await getReviewsAPI.getReview(review);

        /*if (cur.isLog == true) {
          continue;
        }*/

        print(cur.userId + ' this is the user id!!!!!!!!!!!!!!!!!!!!!!!!!!!');

        UserItem userItem = await getUserAPI.getUser(cur.userId);
        cur.user = userItem.userName;

        reviewList.add(cur);
      }

      return reviewList;
    }

    return List.empty();
  }

  static Future<ReviewItem> getReview(String id) async {
    String payload = '{"reviewId":"' + id.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchReviewId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      //print("the jsonObject is:" + jsonObject);

      String id = jsonObject['id'];
      print('id aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      String userId = jsonObject['userId'];
      print('userid aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      int rating = jsonObject['rating'];
      print('rating aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      String text = jsonObject['text'];
      print('text aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      String gameId = jsonObject['gameId'];
      print('gameid aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      bool isLog = jsonObject['isLog'];
      print('isLog aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      List<String> likedBy;
      if (jsonObject.containsKey('likedBy')) {
        List<dynamic> likedByList = jsonObject['likedBy'];
        likedBy = likedByList.map((dynamic item) => item.toString()).toList();
      } else {
        likedBy = [];
      }
      print('likedBy aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      String editDate = jsonObject['editDate'];
      print('editDate aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

      String user = '';

      if (isLog == false || isLog == true) {
        UserItem userItem2 = await getUserAPI.getUser(userId);
        user = userItem2.userName;
        print('user aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      }

      print('I suckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
      //String date = jsonObject['edit_date'];

      print('is logggggggggggggggggggggggggggggggggggggggggggggggggg');

      return ReviewItem(
          id: id,
          user: user,
          userId: userId,
          text: text,
          rating: rating,
          game: gameId,
          isLog: isLog,
          likedBy: likedBy,
          editDate: editDate);
    } catch (e) {
      return ReviewItem(
          id: '',
          user: '',
          userId: '',
          text: '',
          rating: 0,
          game: '',
          isLog: true,
          likedBy: [''],
          editDate: '');
    }
  }

  static Future<void> deleteReview(String id) async {

    String payload = '{"reviewId":"' + id.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/deleteReviewId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;
    } catch (e) {
      print('delete Review failed');
      return; 
    }

  }
}

class ReviewItem {
  final String id;
  String user;
  final String userId;
  final int rating;
  String text;
  final String game;
  final bool isLog;
  final List<String> likedBy;
  final String editDate;

  ReviewItem(
      {required this.id,
      required this.user,
      required this.userId,
      required this.text,
      required this.rating,
      required this.game,
      required this.isLog,
      required this.likedBy,
      required this.editDate});
}
