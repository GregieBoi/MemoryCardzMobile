import 'package:mobile_project/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_project/utils/AddGame.dart';

class SearchGameLocal {

  static Future<GameItem> getGame(String id) async {

    String payload = '{"gameId":"' + id.trim() + '"}';
    var jsonObject;

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchGameId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      if (jsonObject['error'] != null) {print('aaaaaaaaaaaaaaaaaaaaaaa'); return GameItem(id: '', title: '', dev: '', genre: '', release: '', reviews: List.empty(), image: '', igId: '');}
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

      return GameItem(id: id, title: title, dev: dev, genre: genre, release: release, reviews: reviews, image: image, igId: igId);
    }
    catch (e) {
      print('i got here somehow!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      return GameItem(id: '', title: '', dev: '', genre: '', release: '', reviews: List.empty(), image: '', igId: '');
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

  GameItem ({

    required this.id,
    required this.title,
    required this.dev,
    required this.genre,
    required this.release,
    required this.reviews,
    required this.image,
    required this.igId

  });

}