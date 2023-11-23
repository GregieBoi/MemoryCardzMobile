import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyAPIDeveloper {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';
  final String companiesUrl = 'https://api.igdb.com/v4/involved_companies';

  List<DeveloperItem> body = [];

  Future<void> fetchDevelopers(int? gameId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body: 'fields involved_companies.developer, involved_companies.company.name; where id = $gameId; limit 1;',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty && data[0]['involved_companies'] is List) {
        final List<dynamic> companies = data[0]['involved_companies'];

        for (var company in companies) {
          final companyName = company['company']['name'];
          final developerName = company['developer'];

          if (companyName is String && developerName == true) {
            body.add(DeveloperItem(developerName: companyName));
          }
        }
      }
    } else {
      //throw Exception('Failed to load data');
      body.add(DeveloperItem(developerName: ''));
    }
  }
}

class DeveloperItem {
  final String developerName;

  DeveloperItem({required this.developerName});
}
