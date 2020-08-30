import 'package:http/http.dart' as http;

class ApiProvider {
  ApiProvider();

  String apiUrl = 'https://api.yourdomain.com/v1';

  // Future<http.Response> getPost() async {
  //   return await http.get('$apiUrl/post');
  // }

  // Future<http.Response> getPostView(int id) async {
  //   return await http.get('$apiUrl/post/$id');
  // }
}