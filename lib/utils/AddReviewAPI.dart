import 'package:mobile_project/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AddReviewAPI {

  static Future<String> createReview(String userId, String gameId) async {

    print(gameId);

    String payload = '{"userId":"' + userId.trim() + '","gameId":"' + gameId.trim() + '","createDate":"' + ' ' + '"}';
    String reviewId = '';
    var jsonObject;
    print(payload);

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/addReview';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      //print("the jsonObject is:" + jsonObject);
      reviewId = jsonObject["reviewId"];
      return reviewId;
    }
    catch (e) {
      return reviewId;
    }

  }

  static updateReview(String userId, String reviewId, String editDate, double stars, String textComment, bool isLog, String gameId) async {

    int rating = (stars*2).toInt();

    String payload = '{"userId":"' + userId.trim() + '","reviewId":"' + reviewId.trim() + '","gameId":"' + gameId.trim() + '","editDate":"' + editDate.trim() + '","rating": $rating ,"textComment":"' + textComment.trim() + '","isLog": $isLog}';
    reviewId = '';
    var jsonObject;

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/updateReviewInfo';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      //print("the jsonObject is:" + jsonObject);
      reviewId = jsonObject["reviewId"];
      return reviewId;
    }
    catch (e) {
      return reviewId;
    }

  }

}