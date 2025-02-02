import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Use your VisualCrossing API key here
  final String apiKey = '4G634C6D4MUXCQXDWELXVE83T';

  Future<Map<String, dynamic>> fetchWeather(String location) async {
    final url =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$location?unitGroup=metric&key=$apiKey&contentType=json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
