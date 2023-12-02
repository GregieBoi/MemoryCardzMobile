import 'package:mobile_project/utils/getAPI.dart';
import 'dart:convert';
import 'dart:math';

String verificationToken = '';

class emailAPI {

  static Future<void> verify(String email) async {

    verificationToken = (100000 + Random().nextDouble() * 900000).toStringAsFixed(0);

    String payload = '{"verificationToken":"' + verificationToken.trim() + '", "email":"' + email.trim() + '"}';
    var jsonObject;

    try {

      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/emailVerify';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }

    catch (e) {

      print('email verification failed');
      return;

    }

  }

  static Future<void> verifyReset(String email) async {

    verificationToken = (100000 + Random().nextDouble() * 900000).toStringAsFixed(0);

    String payload = '{"verificationToken":"' + verificationToken.trim() + '", "email":"' + email.trim() + '"}';
    var jsonObject;

    try {

      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/emailReset';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }

    catch (e) {

      print('email verification failed');
      return;

    }

  }

  static Future<void> changePassword(String email, String newPassword) async {

    String payload = '{"email":"' + email.trim() + '", "newPassword":"' + newPassword.trim() + '"}';
    var jsonObject;

    try {

      String url =
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/changePassword';
      String ret = await CardsData.getJson(url, payload);
      print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

      jsonObject = json.decode(ret);

      return;

    }

    catch (e) {

      print('email verification failed');
      return;

    }

  }

}