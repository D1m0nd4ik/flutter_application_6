import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchDogImages() async {
  final response = await http.get(
    Uri.parse('https://dog.ceo/api/breeds/image/random/10'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      return List<String>.from(data['message']);
    } else {
      throw Exception('API вернул ошибку');
    }
  } else {
    throw Exception('HTTP ошибка: ${response.statusCode}');
  }
}