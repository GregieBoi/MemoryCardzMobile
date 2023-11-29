import 'package:mobile_project/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_project/utils/getRestOfGame.dart';

class AddGameAPI {

  static Future<String> addGame(String title, String release, String igId) async {

    RestItem rest = await RestAPI.fetchData(igId);
    
    /*print(release);
    developer = developer.replaceAll('"', "'");
    category = category.replaceAll('"', "'");
    List<String> split = developer.split('"');
    print('the split is....................................');
    print(split);
    print(developer);
    print(category);
    print(ageRating);
    print(image);
    description = '';*/
    if (title.length > 45) {title = '';}

    String payload = '{"title":"' + title.trim() + '","developer":"' + rest.dev + '","category":"' + rest.genre + '","releaseDate":"' + release + '","igdbId":"' + igId.trim() + '","description":"' + '' + '","ageRating":"' + rest.ageRating + '","image":"' + rest.image + '"}';
    print(payload);
    String gameId = '';
    var jsonObject;
    print(rest.ageRating);

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

    String payload = '{"igdbId":"' + id.trim() + '"}';
    String game = '';
    String gameId = '';
    var jsonObject;
    var gameObject;
    print(payload);

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchGameIdIgdbId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      //print("the jsonObject is:" + jsonObject);
      gameObject = jsonObject["game"];
      gameId = gameObject["_id"];
      return gameId;
    }
    catch (e) {
      return gameId;
    }

  }

}