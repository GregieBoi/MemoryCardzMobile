import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoverAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';
  final String coversUrl = 'https://api.igdb.com/v4/covers';

  List<CoverItem> body = [];

  Future<void> fetchData(int? gameId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields cover; where id = $gameId; limit 1;',
    );

    if (response.statusCode == 429) {
      await Future.delayed(const Duration(seconds: 1));
      fetchData(gameId);
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<CoverItem> gameItems = [];

      for (var game in data) {
        final coverId = game['cover'];

        if (coverId is int) {
          final coverImageUrl = await fetchCoverImage(coverId);
          gameItems.add(CoverItem(coverImageUrl: coverImageUrl));
        }
      }

      body = gameItems;
    } else {
      body = [CoverItem(coverImageUrl: '')];
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
        //print("the url is:::::::::::::::::::::::::::::::::::::::::::::: 'https:${data[0]['url']}'");
        //print("data is ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ${data[0]}");
        String url = 'https:${data[0]['url']}';
        final splitted = url.split('thumb');
        final image = splitted[0] + 'cover_big' + splitted[1];
        return image;
      }
    }
    return ''; // Return an empty string if cover image URL is not found.
  }
}

class CoverItem {
  final String coverImageUrl;

  CoverItem({
    required this.coverImageUrl,
  });
}
