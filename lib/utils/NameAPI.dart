import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NameAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';

  List<NameItem> body = [];

  static Future<List<NameItem>> fetchData(String? gameName) async {
    final response = await http.post(
      Uri.parse('https://api.igdb.com/v4/games'),
      headers: {
        'Client-ID': '92hgc1hks3axm39nqurfsd9g57slbv',
        'Authorization': 'Bearer olri728cp8oz5wajq55y1t07ses589',
      },
      body: 'fields category, name, first_release_date; search "$gameName"; limit 10;',
    );

    if(gameName == '' || response.statusCode == 429) {return [NameItem(title: '', id: 0)];}

    if (response.statusCode == 200) {
      print(gameName);
      final List<dynamic> data = json.decode(response.body);
      final List<NameItem> gameItems = [];

      print(data);



      for (var game in data) {
        final title = game['name'];
        final id = game['id'];
        final category = game['category'];
        final date = game['first_release_date'];
        String year; 

        if (date == null) {year = '';}

       else {
          var milleseconds = DateTime.fromMillisecondsSinceEpoch(date * 1000);  
          var dateFormatted = DateFormat('y').format(milleseconds);
          year = ' (' + dateFormatted + ')';
        }

        if (title is String && id is int && (category == 0 || category == 8)) {
          NameItem gameItem = NameItem(title: title + year, id: id);
          gameItems.add(gameItem);
        }
      }

      //body = gameItems;
      return gameItems;
    } else {
      print(response.statusCode);
      print(gameName);
      print(json.decode(response.body));
      throw Exception('Failed to load data');
    }
  }
}

class NameItem {
  final String title;
  final int id;

  NameItem({
    required this.title,
    required this.id
  });
}