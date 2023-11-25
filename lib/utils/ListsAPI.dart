import 'package:mobile_project/utils/getAPI.dart';
import 'dart:convert';
import 'package:mobile_project/utils/SearchGameLocal.dart';

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