import 'package:mobile_project/utils/getAPI.dart';
import 'dart:convert';

class getUserAPI {

  static Future<UserItem> getUser(userId) async {

    String payload = '{"userId":"' + userId.trim() + '"}';
    var jsonObject;

    try {
      String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/searchUserId';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);
      
      String id = jsonObject['id'];
      String userName = jsonObject['username'];
      String firstName = jsonObject['firstName'];
      String lastName = jsonObject['lastName'];
      String email = jsonObject['email'];
      String bio = jsonObject['bio'];
      List<dynamic> followers = [];
      if (jsonObject['followers'] != null) {
        print(jsonObject['followers']);
        followers = jsonObject['followers'];
      }
      List<dynamic> following = [];
      if (jsonObject['following'] != null) {
        print(jsonObject['following']);
        following = jsonObject['following'];
      }
      List<dynamic> logged = [];
      if (jsonObject['logged'] != null) {
        print(jsonObject['logged']);
        logged = jsonObject['logged'];
      }

      List<String> reviews = [];
      if (jsonObject['reviewed'] != null) {
        print(jsonObject['reviewed']);
        reviews = jsonObject['reviewed'];
      }

      return UserItem(id: id, userName: userName, firstName: firstName, lastName: lastName, email: email, bio: bio, followers: followers, following: following, logged: logged, reviews: reviews);
    }
    catch (e) {
      print('I suckkkkkkkkk');
      return UserItem(id: '', userName: '', firstName: '', lastName: '', email: '', bio: '', followers: [''], following: [''], logged: [''], reviews: ['']);
    }

  }

}

class UserItem {

  final String id;
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final String bio;
  final List<dynamic> following;
  final List<dynamic> followers;
  final List<dynamic> logged;
  final List<String> reviews;

  UserItem  ({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.logged,
    required this.reviews
  });

}