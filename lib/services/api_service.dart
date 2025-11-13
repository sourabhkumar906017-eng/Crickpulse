import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = "8f97668b-ad68-460f-94c6-da7ea55db59e";

  Future<List<dynamic>> fetchMatches() async {
    final url = Uri.parse("https://api.cricapi.com/v1/matches?apikey=8f97668b-ad68-460f-94c6-da7ea55db59e&offset=0");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(response.body);

      // 👇 Print full data to console for inspection
      print("=== FULL API RESPONSE ===");
      print(const JsonEncoder.withIndent('  ').convert(decoded));

      if (decoded.containsKey('data')) {
        return decoded['data'];
      } else {
        return [];
      }
    } else {
      print("Error: ${response.statusCode}");
      throw Exception("Failed to load matches");
    }
  }
}