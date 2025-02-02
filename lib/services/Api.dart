import 'package:http/http.dart' as http;
import '../common/constants.dart';

class ApiService {
  var client = http.Client();
  String endpoint = Constants.API_BASE_URL + Constants.API_PREFIX;
  String apiKey = Constants.API_KEY;

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Accept": "application/json"
  };

  // Get top headlines
  Future<http.Response> getTopHeadlines() {
    return client.get(
      Uri.parse('$endpoint/top-headlines?apiKey=$apiKey'),
      headers: headers,
    );
  }

  // Modify the getEverything method to include search functionality
  Future<http.Response> getEverything(String keyword, int page, [String? searchKeyword]) {
    // Construct the query parameter for searching
    String query = searchKeyword != null && searchKeyword.isNotEmpty
        ? searchKeyword
        : keyword;

    return client.get(
      Uri.parse('$endpoint/everything?q=$query&language=en&sortBy=publishedAt&page=$page&apiKey=$apiKey'),
      headers: headers,
    );
  }
}
