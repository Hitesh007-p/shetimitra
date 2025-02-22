// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class MarketPriceService {
//   Future<List<Map<String, dynamic>>> getMarketPrices(
//       double latitude, double longitude) async {
//     // Replace this URL with a real market price API
//     final url =
//         'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-=$latitude&lon=$longitude';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       return data.map((item) => item as Map<String, dynamic>).toList();
//     } else {
//       throw Exception('Failed to fetch market prices');
//     }
//   }
// }
