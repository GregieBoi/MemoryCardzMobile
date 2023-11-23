import 'dart:convert';
import 'package:http/http.dart' as http;

class GenreAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';

  List<GenreItem> body = [];

  Future<void> fetchGenres(int? gameId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields genres.name; where id = $gameId; limit 1;',
    );

    if (response.statusCode == 429) {
      await Future.delayed(const Duration(seconds: 1));
      fetchGenres(gameId);
      return;
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<GenreItem> genreItems = [];

      for (var game in data) {
        if (game.containsKey('genres')) {
          final List<dynamic> genres = game['genres'];

          for (var genre in genres) {
            final genreName = genre['name'];

            if (genreName is String) {
              genreItems.add(GenreItem(genreName: genreName));
            }
          }
        }
      }

      body = genreItems;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }
}

class GenreItem {
  final String genreName;

  GenreItem({
    required this.genreName,
  });
}
