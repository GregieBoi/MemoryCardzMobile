import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/AddGame.dart';
import 'dart:convert';

class faveGamesAPI {

  static Future<void> addFavorite(String userId, String gameIgId, String title, String release) async {

    String gameId = await AddGameAPI.searchId(gameIgId);
    if (gameId == '') {
      gameId = await AddGameAPI.addGame(title, release, gameIgId);
    }

    String payload = '{"userId":"' + userId.trim() + '", "gameId":"' + gameId.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/addFavorite';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('add favorite failed');
      return;
    }

  }

  static Future<void> deleteFavorite(String userId, String gameId) async {

    String payload = '{"userId":"' + userId.trim() + '", "gameId":"' + gameId.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/deleteFavorite';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('delete favorite failed');
      return;
    }

  }

}