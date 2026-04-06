import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketPriceService {
  static const String _apiKey =
      '579b464db66ec23bdd000001ce66afa035614da844e40ec5e305c27e';
  static const String _resourceId = '9ef84268-d588-465a-a308-a864a43d0070';

  Future<List<Map<String, dynamic>>> getMarketPrices({
    int limit = 5,
    int offset = 0,
    String? commodity,
    String? market,
    String? state,
    String? district,
  }) async {
    final queryParameters = <String, String>{
      'api-key': _apiKey,
      'format': 'json',
      'offset': offset.toString(),
      'limit': limit.toString(),
    };

    if (commodity != null && commodity.isNotEmpty) {
      queryParameters['commodity'] = commodity;
    }
    if (market != null && market.isNotEmpty) {
      queryParameters['market'] = market;
    }
    if (state != null && state.isNotEmpty) {
      queryParameters['state'] = state;
    }
    if (district != null && district.isNotEmpty) {
      queryParameters['district'] = district;
    }

    final url = Uri.https(
      'api.data.gov.in',
      '/resource/$_resourceId',
      queryParameters,
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch market prices: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final List<Map<String, dynamic>> records = [];

    if (data is Map<String, dynamic>) {
      final rawRecords = data['records'];
      if (rawRecords is List) {
        for (final item in rawRecords) {
          if (item is Map<String, dynamic>) {
            records.add(item);
          } else if (item is Map) {
            records.add(Map<String, dynamic>.from(item));
          }
        }
      }
    }

    return records;
  }
}
