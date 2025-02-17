import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'bb813ce10fc17207f8e37539e88d8760';

  Future<Map<String, dynamic>> getWeather(
      double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';
    // 'https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&units=metric&appid=bb813ce10fc17207f8e37539e88d8760';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON response
      return json.decode(response.body);
    } else {
      // Print error details
      print(
          'Failed to load weather data: ${response.statusCode} - ${response.reasonPhrase}');
      print('Response body: ${response.body}');

      throw Exception('Failed to load weather data');
    }
  }
}
