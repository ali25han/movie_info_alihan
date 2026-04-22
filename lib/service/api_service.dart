import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/movie.dart';

class ApiService {
  static const String apiKey = 'YOUR_API_KEY';
  static const String baseUrl = 'https://www.omdbapi.com/';

  Future<Movie?> fetchMovie(String name) async {
    final url = Uri.parse('$baseUrl?t=$name&apikey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == 'True') {
        return Movie.fromJson(data);
      }
      return null;
    } else {
      throw Exception('Failed to load movie');
    }
  }
}
