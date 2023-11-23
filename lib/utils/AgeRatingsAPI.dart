import 'dart:convert';
import 'package:http/http.dart' as http;

class AgeRatingsAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';

  List<AgeRatingItem> body = [];

  Future<void> fetchAgeRatings(int? gameId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields age_ratings.rating; where id = $gameId; limit 1;',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<AgeRatingItem> ageRatingItems = [];

      for (var game in data) {
        if (game.containsKey('age_ratings')) {
          final List<dynamic> ageRatings = game['age_ratings'];

          for (var ageRating in ageRatings) {
            final rating = ageRating['rating'];

            if (rating is int) {
              ageRatingItems.add(AgeRatingItem(rating: rating));
            }
          }
        }
      }

      body = ageRatingItems;
    } else {
      body = [AgeRatingItem(rating: 0)];
    }
  }
}

class AgeRatingItem {
  final int rating;

  AgeRatingItem({
    required this.rating,
  });
}
