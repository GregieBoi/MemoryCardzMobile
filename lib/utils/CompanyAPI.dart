import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyAPI {
  final String apiKey = '92hgc1hks3axm39nqurfsd9g57slbv';
  final String authKey = 'Bearer olri728cp8oz5wajq55y1t07ses589';
  final String baseUrl = 'https://api.igdb.com/v4/games';
  final String companiesUrl = 'https://api.igdb.com/v4/involved_companies';

  List<CompanyItem> body = [];

  Future<void> fetchCompanies(int? gameId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Client-ID': apiKey,
        'Authorization': authKey,
      },
      body:
          'fields involved_companies.company.name; where id = $gameId; limit 1;',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty && data[0]['involved_companies'] is List) {
        final List<dynamic> companies = data[0]['involved_companies'];

        for (var company in companies) {
          final companyName = company['company']['name'];

          if (companyName is String) {
            body.add(CompanyItem(companyName: companyName));
          }
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class CompanyItem {
  final String companyName;

  CompanyItem({
    required this.companyName,
  });
}
