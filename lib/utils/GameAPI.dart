import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';
  final String coversUrl = 'https://api.igdb.com/v4/covers';
  final String ageRatingsUrl = 'https://api.igdb.com/v4/age_ratings';

  List<GameItem> body = [];

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields name, cover, summary, age_ratings; search "Resident Evil"; limit 10;',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<GameItem> gameItems = [];

      for (var game in data) {
        final title = game['name'];
        final coverId = game['cover'];
        final summary = game['summary'];
        final ageRatings = game['age_ratings'];

        if (title is String && coverId is int && ageRatings is List && ageRatings.isNotEmpty) {
          final ageRatingId = ageRatings[0];
          final coverImageUrl = await fetchCoverImage(coverId);
          final ratingCoverUrl = await fetchAgeRatingCover(ageRatingId);
          gameItems.add(
              GameItem(title: title, coverImageUrl: coverImageUrl, summary: summary, ratingCoverUrl: ratingCoverUrl));
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

  // GET AGE RATING COVER
  Future<String> fetchAgeRatingCover(int ageRatingId) async {
    final response = await http.post(
      Uri.parse(ageRatingsUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields rating; where id = $ageRatingId;',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data[0]['rating'] is String) {
        return 'https:${data[0]['rating']}';
      }
    }
    return ''; // Return an empty string if rating cover URL is not found.
  }
}

class GameItem {
  final String title;
  final String coverImageUrl;
  final String summary;
  final String ratingCoverUrl;

  GameItem({
    required this.title,
    required this.coverImageUrl,
    required this.summary,
    required this.ratingCoverUrl,
  });
}
