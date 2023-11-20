import 'package:http/http.dart' as http;
import 'dart:convert';

class CardsData {
  static Future<String> getJson(String url, String outgoing) async {
    String ret = "";

    try {
      final Uri apiUrl = Uri.parse(url); // Convert the URL string to a Uri
      http.Response response = await http.post(
        apiUrl,
        body: utf8.encode(outgoing),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        encoding: Encoding.getByName("utf-8"),
      );

      // debugging stuff
      if (response.statusCode == 200) {
        // The response is successful (status code 200 OK)
        ret = response.body;
        //print("successful response wat?");
      } else {
        // Handle the case when the response is not successful
        print('HTTP Request Error: ${response.statusCode}');
        // You can also add additional error handling logic here.
      }
      //

      //ret = response.body;
    } catch (e) {
      print(e.toString());
    }

    print(ret);
    return ret;
  }
}

class GlobalData {
  static String? userId;
  static String? firstName;
  static String? lastName;
  static String? username;
  static String? password;
}
