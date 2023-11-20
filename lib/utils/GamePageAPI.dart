import 'dart:convert';
import 'package:http/http.dart' as http;

class GamePageAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  List<Map<String, dynamic>> gamesList = [];

  Future<List<Map<String, dynamic>>> getGames(int? gameId) async {
    // Define the request headers
    Map<String, String> headers = {
      'Client-ID': apiKey,
      'Authorization': authKey,
    };

    // Define the query parameters
    String query =
        'fields name, cover.image_id, first_release_date, involved_companies.company.name, summary, platforms.name, age_ratings.rating, genres.name; where id = $gameId; limit 1;';

    // Perform the request to get games data
    http.Response gamesResponse = await http.post(
      Uri.parse('https://api.igdb.com/v4/games'),
      headers: headers,
      body: query,
    );

    if (gamesResponse.statusCode == 200) {
      List<dynamic> gamesData = json.decode(gamesResponse.body);

      for (var gameData in gamesData) {
        Map<String, dynamic> game = {
          'name': gameData['name'],
          'summary': gameData['summary'],
          'first_release_date': gameData['first_release_date'],
          /*
          'cover': gameData['cover'] != null
              ? getCoverImage(gameData['cover']['id'].toString())
              : null,
          */
          /*
          'involvedCompanies': await getInvolvedCompanies(
              gameData['involved_companies'], gameId),
          */
          /*
          'platforms': await getPlatforms(gameData['platforms']),
          */
          /*
          'ageRating': await getAgeRatings(gameData['age_ratings']),
          */
          'genres': await getGenres(gameData['genres']),
        };

        gamesList.add(game);
      }
    }

    return gamesList;
  }

  Future<List<String>> getGenres(List<dynamic> genreIds) async {
    List<String> genres = [];

    for (var genreId in genreIds) {
      // Perform the request to get genre data
      http.Response genreResponse = await http.get(
        Uri.parse('https://api.igdb.com/v4/genres/$genreId'),
        headers: {'Client-ID': apiKey, 'Authorization': authKey},
      );

      if (genreResponse.statusCode == 200) {
        Map<String, dynamic> genreData = json.decode(genreResponse.body);
        genres.add(genreData['name']);
      }
    }

    return genres;
  }
}
