import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  static const String _baseUrl =
      'https://restcountries.com/v3.1/all?fields=name,cca2';

  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final countries = data
          .map((json) => Country.fromJson(json))
          .where((c) => c.cca2.isNotEmpty && c.name.isNotEmpty)
          .toList();
      countries.sort((a, b) => a.name.compareTo(b.name));
      return countries;
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }
}
