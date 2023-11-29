import 'package:mobile_project/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_project/utils/AddGame.dart';

List<int> spread = [0,0,0,0,0,0,0,0,0,0];

class SearchGameLocal {

  static Future<GameItem> getGame(String id) async {

    String payload = '{"gameId":"' + id.trim() + '"}';
    var jsonObject;

    print('\mthis is the gameId: ' + id + '\n');

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchGameId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      if (jsonObject['error'] != null) {print('aaaaaaaaaaaaaaaaaaaaaaa'); return GameItem(id: '', title: '', dev: '', genre: '', release: '', reviews: List.empty(), image: '', igId: '', spread: spread);}
      //print("the jsonObject is:" + jsonObject);

      String id = jsonObject['id'];
      print('id is :::::::::::::::::::::::::::::::::::::::::::::::::' + id);
      String title = jsonObject['title'];
      print('title is :::::::::::::::::::::::::::::::::::::::::::::::::' + title);
      String dev = jsonObject['developer'];
      print('dev is :::::::::::::::::::::::::::::::::::::::::::::::::' + dev);
      String genre = jsonObject['category'];
      print('genre is :::::::::::::::::::::::::::::::::::::::::::::::::' + genre);
      String release = jsonObject['release'];
      print('release is :::::::::::::::::::::::::::::::::::::::::::::::::' + release);
      List<dynamic> reviews = [];
      if (jsonObject['reviews'] != null) {
        reviews = jsonObject['reviews'];
      }

      print('reviews is :::::::::::::::::::::::::::::::::::::::::::::::::');
      print(reviews);
      String image = jsonObject['image'];
      String igId = jsonObject['igdbId'];

      int one = 0; int two = 0; int three = 0; int four = 0; int five = 0;
      int six = 0; int seven = 0; int eight = 0; int nine = 0; int ten = 0;

      if(jsonObject['oneStar'] != null) {one = jsonObject['oneStar'];}
      if(jsonObject['twoStars'] != null) {two = jsonObject['twoStars'];}
      if(jsonObject['threeStars'] != null) {three = jsonObject['threeStars'];}
      if(jsonObject['fourStars'] != null) {four = jsonObject['fourStars'];}
      if(jsonObject['fiveStars'] != null) {five = jsonObject['fiveStars'];}
      if(jsonObject['sixStars'] != null) {six = jsonObject['sixStars'];}
      if(jsonObject['sevenStars'] != null) {seven = jsonObject['sevenStars'];}
      if(jsonObject['eightStars'] != null) {eight = jsonObject['eightStars'];}
      if(jsonObject['nineStars'] != null) {nine = jsonObject['nineStars'];}
      if(jsonObject['tenStars'] != null) {print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');ten = jsonObject['tenStars'];}

      spread = [one,two,three,four,five,six,seven,eight,nine,ten];
      print(spread);

      return GameItem(id: id, title: title, dev: dev, genre: genre, release: release, reviews: reviews, image: image, igId: igId, spread: spread);
    }
    catch (e) {
      print('i got here somehow!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      return GameItem(id: '', title: '', dev: '', genre: '', release: '', reviews: List.empty(), image: '', igId: '', spread: spread);
    }

  }


}

class GameItem {

  final String id;
  final String title;
  final String dev;
  final String genre;
  final String release;
  final List<dynamic> reviews;
  final String image;
  final String igId;
  final List<int> spread;

  GameItem ({

    required this.id,
    required this.title,
    required this.dev,
    required this.genre,
    required this.release,
    required this.reviews,
    required this.image,
    required this.igId,
    required this.spread

  });

}