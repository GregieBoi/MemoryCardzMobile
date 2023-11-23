import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_project/utils/CoverAPI.dart';
import 'package:mobile_project/utils/CompanyAPIDeveloper.dart';

class RestAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';
  static final List<String> ratings = ['3+', '7+', '12+', '16+', '18+', 'RP', 'EC', 'E', 'E10+', 'T', 'M', 'AO']; 

  List<RestItem> body = [];

  static Future<RestItem> fetchData(String? gameId) async {
    final response = await http.post(
      Uri.parse('https://api.igdb.com/v4/games'),
      headers: {
        'Client-ID': '92hgc1hks3axm39nqurfsd9g57slbv',
        'Authorization': 'Bearer olri728cp8oz5wajq55y1t07ses589',
      },
      body: 'fields age_ratings.rating, cover, genres.name; where id = $gameId; limit 10;',
    );

    if(gameId == '' || response.statusCode == 429) {
      return RestItem( dev: '', genre: '', ageRating: '', image: '');
    }

    if (response.statusCode == 200) {
      print(gameId);
      final List<dynamic> games = json.decode(response.body);
      final game = games[0];

      final List<dynamic>? ageRatings = game['age_ratings'];
      final List<int> _ageRatings = [];
      String ageRating = '';

      if (ageRatings != null) {
        for (var ageRating in ageRatings) {
          final rating = ageRating['rating'];

          if (rating is int && rating > 0 && rating < 13) {
            _ageRatings.add(rating);
          }
        }
        if (_ageRatings.isNotEmpty) {
          int whatRating = _ageRatings.length;

          ageRating = ratings[_ageRatings[whatRating-1]-1];
          print(ageRating);
        }
      }

      final List<dynamic>? genres = game['genres'];
      List<String> _genres = [];
      String genre = '';

      if (genres != null) {
        for (var genre in genres) {
          final genreName = genre['name'];

          if (genreName is String) {
            _genres.add(genreName);
          }
        }

        print(_genres);

      }

      genre = json.encode(_genres);
      genre = genre.replaceAll('"', "'");

      final devAPI = CompanyAPIDeveloper();
      await devAPI.fetchDevelopers(int.parse(gameId!));
      List<DeveloperItem>? developers = devAPI.body;
      List<String> devs = [];
      String dev = '';

      if (developers.isNotEmpty) {
        for (var dev in developers) {

          final devName = dev.developerName;

          devs.add(devName);

        }
        print(devs);
      }

      dev = json.encode(devs);
      dev = dev.replaceAll('"', "'");

      print(json.encode(devs));

      final int? coverId = game['cover'];
      String cover = '';
      if (coverId != null)
      {cover = await CoverAPI().fetchCoverImage(coverId);}

      //body = gameItems;
      return RestItem(dev: dev, genre: genre, ageRating: ageRating, image: cover);
    } else {
      print(response.statusCode);
      print(gameId);
      print(json.decode(response.body));
      throw Exception('Failed to load data');
    }
  }
}

class RestItem {
  final String dev;
  final String genre;
  final String ageRating;
  final String image;

  RestItem({
    required this.dev,
    required this.genre,
    required this.ageRating,
    required this.image
  });
}