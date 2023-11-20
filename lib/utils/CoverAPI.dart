import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoverAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';
  final String coversUrl = 'https://api.igdb.com/v4/covers';

  List<GameItem> body = [];

  Future<void> fetchData(int? gameId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields cover; where id = $gameId; limit 1;',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<GameItem> gameItems = [];

      for (var game in data) {
        final coverId = game['cover'];

        if (coverId is int) {
          final coverImageUrl = await fetchCoverImage(coverId);
          gameItems.add(GameItem(coverImageUrl: coverImageUrl));
        }
      }

      body = gameItems;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // GET COVER IMAGE
  Future<String> fetchCoverImage(int coverId) async {
    final response = await http.post(
      Uri.parse(coversUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields url; where id = $coverId;',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data[0]['url'] is String) {
        return 'https:${data[0]['url']}';
      }
    }
    return ''; // Return an empty string if cover image URL is not found.
  }
}

class GameItem {
  final String coverImageUrl;

  GameItem({
    required this.coverImageUrl,
  });
}
