import 'dart:convert';
import 'package:http/http.dart' as http;

class LikeAPI {
  static Future<void> handleLike(
      String userId, String reviewId, bool isAdding) async {
    try {
      // Replace the URL with your actual server URL
      var url = Uri.parse(
          'https://cop4331-25-c433f0fd0594.herokuapp.com/api/${isAdding ? 'addLike' : 'deleteLike'}');

      // Prepare the request body
      var requestBody = {
        'userId': userId,
        'reviewId': reviewId,
      };

      // Send the POST request
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 429) {
        await Future.delayed(const Duration(seconds: 1));
        handleLike(userId, reviewId, isAdding);
      }

      // Check the response status
      if (response.statusCode == 200) {
        // Request was successful
        if (isAdding) {
          print('Like added successfully to review ${reviewId} from ${userId}');
        } else {
          print('Like deleted successfully to review $reviewId from ${userId}');
        }
      } else {
        print(response.statusCode);
        print(
            'Failed to ${isAdding ? 'add' : 'delete'} like. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error ${isAdding ? 'adding' : 'deleting'} like: $e');
    }
  }
}
