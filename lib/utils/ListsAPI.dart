import 'package:mobile_project/utils/getAPI.dart';
import 'dart:convert';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/addGame.dart';

class getListsAPI {

  static Future<ListItem> getList(String id) async {

    String payload = '{"listId":"' + id.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchListId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      String id = jsonObject['id'];

      print('iddddddddddddddddd');

      List<String> games = [];
      if (jsonObject['gameList'] != null) {
        List<dynamic> gameList = jsonObject['gameList'];
        games = gameList.map((dynamic item) => item.toString()).toList();
      }

      print('gammmmmmmmmmmmmmmmmmeeeeeeeeeeeeeeeeeeeesssssssss');

      String name = jsonObject['name'];

      return ListItem(id: id, name: name, games: games);
    }
    catch (e) {
      return ListItem(id: '', name: '', games: []);
    }

  }

  static Future<void> addToList(String id, String gameIgId, String title, String release) async {

    String gameId = await AddGameAPI.searchId(gameIgId);
    if (gameId == '') {
      gameId = await AddGameAPI.addGame(title, release, gameIgId);
    }

    String payload = '{"listId":"' + id.trim() + '", "gameId":"' + gameId.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/listAddGame';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('add to list failed');
      return;
    }

  }

  static Future<String> createList(String userId, String name) async {

    String payload = '{"userId":"' + userId.trim() + '", "listName":"' + name.trim() + '"}';
    var jsonObject;
    String listId = '';

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/addList';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      if(jsonObject['listId'] != null) {
        listId = jsonObject['listId'];
      }

      return listId;

    }
    catch (e) {
      print('create list failed');
      return '';
    }

  }

  static Future<void> deleteList(String id) async {

    String payload = '{"listId":"' + id.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/deleteListId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('delete list failed');
      return;
    }

  }  

  static Future<void> deleteListGame(String id, String gameId) async {

    String payload = '{"listId":"' + id.trim() + '", "gameId":"' + gameId.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/listDeleteGame';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('add to list failed');
      return;
    }

  }

  static Future<void> updateListName(String id, String newName) async {

    String payload = '{"listId":"' + id.trim() + '", "listName":"' + newName.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/updateListName';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('update name failed');
      return;
    }

  }

}

class ListItem {
  final String id;
  final String name;
  final List<String> games;

  ListItem ({
    required this.id,
    required this.name,
    required this.games
  });
}