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

      List<dynamic> reviews = [];
      if (jsonObject['reviewed'] != null) {
        print(jsonObject['reviewed']);
        reviews = jsonObject['reviewed'];
      }
      List<dynamic> lists = [];
      if (jsonObject['lists'] != null) {
        print(jsonObject['lists']);
        lists = jsonObject['lists'];
      }
      List<dynamic> favorites = [];
      if (jsonObject['favorites'] != null) {
        favorites = jsonObject['favorites'];
      }

      return UserItem(id: id, userName: userName, firstName: firstName, lastName: lastName, email: email, bio: bio, followers: followers, following: following, logged: logged, reviews: reviews, lists: lists, favorites: favorites);
    }
    catch (e) {
      print('I suckkkkkkkkk');
      return UserItem(id: '', userName: '', firstName: '', lastName: '', email: '', bio: '', followers: [''], following: [''], logged: [], reviews: [], lists: [], favorites: []);
    }

  }

  static Future<void> followUser(String id, String userId) async {

    String payload = '{"userId":"' + id.trim() + '", "followId":"' + userId.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/followUser';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('follow failed');
      return;
    }

  }

  static Future<void> unfollowUser(String id, String userId) async {

    String payload = '{"userId":"' + id.trim() + '", "followId":"' + userId.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/unfollowUser';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('unfollow failed');
      return;
    }

  }

  static Future<void> updateUser(String id, String firstName, String lastName, String username, String password, String email, String bio) async {

    String payload = '{"userId":"' + id.trim() + '", "firstName":"' + firstName.trim() + '", "lastName":"' + lastName.trim() + '", "username":"' + username.trim() + '", "password":"' + password.trim() + '", "email":"' + email.trim() + '", "bio":"' + bio.trim() + '"}';
    var jsonObject;

    try {
      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/updateUserInfo';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }
    catch (e) {
      print('updateUser failed');
      return;
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
  final List<dynamic> reviews;
  final List<dynamic> lists;
  final List<dynamic> favorites;

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
    required this.reviews,
    required this.lists,
    required this.favorites
  });

}