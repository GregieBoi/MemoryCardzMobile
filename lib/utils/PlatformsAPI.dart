import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatformsAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';

  List<PlatformItem> body = [];

  Future<void> fetchPlatforms(int? gameId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields platforms.name; where id = $gameId; limit 1;',
    );

    if (response.statusCode == 429) {
      await Future.delayed(const Duration(seconds: 1));
      fetchPlatforms(gameId);
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<PlatformItem> platformItems = [];

      for (var game in data) {
        if (game.containsKey('platforms')) {
          final List<dynamic> platforms = game['platforms'];

          for (var platform in platforms) {
            final platformName = platform['name'];

            if (platformName is String) {
              platformItems.add(PlatformItem(platformName: platformName));
            }
          }
        }
      }

      body = platformItems;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }
}

class PlatformItem {
  final String platformName;

  PlatformItem({
    required this.platformName,
  });
}
