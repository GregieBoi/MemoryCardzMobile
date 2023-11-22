import 'dart:convert';
import 'package:mobile_project/utils/getAPI.dart';

class UserAPI {

  static Future<UserItem> getUser(id) async {

    String payload = '{"userId":"' + id.trim() + '"}';
    var jsonObject;

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchUserId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      //print("the jsonObject is:" + jsonObject);
      print('im herrrrrrrrrrrrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

      String firstName = jsonObject['firstName'];

      print('im herrrrrrrrrrrrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

      return UserItem(firstName: firstName);
    }
    catch (e) {
      return UserItem(firstName: '');
    }

  }

}

class UserItem {

  final String firstName;

  UserItem ({
    required this.firstName
  });

}