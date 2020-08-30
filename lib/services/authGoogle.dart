import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Future authGoogle() async {
  const url = "https://accounts.google.com/o/oauth2/v2/auth?redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=756540441847-uelprsnktfct6dj2vib2ofr1hb9k160n.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform&access_type=offline";
  if (await canLaunch(url)) {
    await launch(
      url,
      // forceSafariVC: true,
      // forceWebView: true,
      // enableDomStorage: true,
    );
  } else {
    throw 'Could not launch $url';
  }
}

class ApiGoogleProvider {
  ApiGoogleProvider();

  String apiUrl = 'https://api.yourdomain.com/v1';
  String tokenGoogleApi = 'https://accounts.google.com/o/oauth2/token';

  Future<http.Response> getPost() async {
    return await http.get('$apiUrl/post');
  }

  Future<http.Response> postRequestToken(String authCode) async {
    const headers = {
      'content-type': ''
    };
    return await http.post('$apiUrl');
  }
}