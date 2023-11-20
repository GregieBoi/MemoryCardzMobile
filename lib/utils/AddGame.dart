import 'package:mobile_project/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AddGameAPI {

  static Future<String> addGame(String title, String developer, String category, String release, String igId) async {

    print(release);
    String payload = '{"title":"' + title.trim() + '","developer":"' + developer.trim() + '","category":"' + category.trim() + '","releaseDate":"' + release + '","igdbId":"' + igId.trim() + '"}';
    print(payload);
    String gameId = '';
    var jsonObject;

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/addGame';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      //print("the jsonObject is:" + jsonObject);
      gameId = jsonObject["gameId"];
      return gameId;
    }
    catch (e) {
      return gameId;
    }

  }

  static Future<String> searchId(String id) async {

    String payload = '{"search":"' + id.trim() + '"}';
    String gameId = '';
    var jsonObject;

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchGameIgdbId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      //print("the jsonObject is:" + jsonObject);
      gameId = jsonObject["gameId"];
      return gameId;
    }
    catch (e) {
      return gameId;
    }

  }

}