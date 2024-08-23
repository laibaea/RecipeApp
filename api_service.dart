import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  final String apiUrl =
      'https://yummly2.p.rapidapi.com/feeds/list?limit=24&start=0';
  final Map<String, String> headers = {
    'x-rapidapi-host': 'yummly2.p.rapidapi.com',
    'x-rapidapi-key': 'c79e08cc8cmsh6b2fa2d94b4f270p11fa8fjsn49838556d387',
  };

  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['feed'];
      return data.map((item) {
        return Recipe.fromJson({
          'id': item['content']['details']['id'],
          'title': item['content']['details']['name'],
          'imageUrl': item['content']['details']['images'][0]['hostedLargeUrl'],
        });
      }).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
