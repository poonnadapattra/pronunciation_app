import 'dart:io';
import 'dart:async';
import 'dart:convert' show json, jsonEncode, utf8;
import 'package:http/http.dart' as http;
import 'package:pronunciation_app/voice.dart';

class TextToSpeechAPI {

  static final TextToSpeechAPI _singleton = TextToSpeechAPI._internal();
  final _httpClient = HttpClient();
  static const _apiKey = "e64a7c9bb00911caacab318c3ed2fe38188c8e97";
  static const _apiURL = "texttospeech.googleapis.com";


  factory TextToSpeechAPI() {
    return _singleton;
  }

  TextToSpeechAPI._internal();

  Future synthesizeText(String text, String name, String languageCode) async {
    try {
      final uri = Uri.https(_apiURL, '/v1beta1/text:synthesize');
      final Map _json = {
        'input': {
          'text': text
        },
        'voice': {
          'name': name,
          'languageCode': languageCode
        },
        'audioConfig': {
          'audioEncoding': 'MP3'
        }
      };

      // final Map _json = {
      //   "audioConfig": {
      //     "audioEncoding": "LINEAR16",
      //     "pitch": 0,
      //     "speakingRate": 1
      //   },
      //   "input": {
      //     "text": text
      //   },
      //   "voice": {
      //     "languageCode": "en-US",
      //     "name": "en-US-Wavenet-D"
      //   }
      // };

      // final _jsonResponse = await _postJson(uri, _json);
      final jsonResponse = await http.post('https://texttospeech.googleapis.com/v1beta1/text:synthesize',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ya29.a0AfH6SMDuA-cTdJ2mWa8A5a7ImAriHJ53XaBmNVF07xSzcXZ3DHz4HzO9u4H_DpgaqyJ4Jw9VTDwT7NtDc4UA9xaznV1eYHxAUt67lQ1QnKpUYrKRX8e3mZhKrRR40vNMWHDT61GNWfG2nMvmuNf_HdxTkPwdu3pz4qQ'
          // Authorization: Bearer ya29.a0AfH6SMAQvBKL5pXwxOvTJu10ASh5jWWPWi6hgr6Gz9eDpvsYODorl7Z44IR7y_N5wYGI2hD2X3DPTL33qjpfxNRS3GlQuVA5bANTy7_pkdspLzzrTnEl4QjSHLFc6XsPnBZDUhkJ68aAWOmW_B2P7dF8yppNKT9CvfOo
          // 'Authorization': 'Bearer ya29.a0AfH6SMAQvBKL5pXwxOvTJu10ASh5jWWPWi6hgr6Gz9eDpvsYODorl7Z44IR7y_N5wYGI2hD2X3DPTL33qjpfxNRS3GlQuVA5bANTy7_pkdspLzzrTnEl4QjSHLFc6XsPnBZDUhkJ68aAWOmW_B2P7dF8yppNKT9CvfOo'
        },
        body: jsonEncode(_json)
      );

      print(jsonResponse.body);
      if (jsonResponse == null) return null;
      final audioContent = await json.decode(jsonResponse.body);
      return audioContent['audioContent'];
    } on Exception catch(e) {
      print("$e");
      return null;
    }
  }

  Future<List<Voice>> getVoices() async {
    try {
      final uri = Uri.https(_apiURL, '/v1beta1/text:synthesize');

      final jsonResponse = await _getJson(uri);
      if (jsonResponse == null) {
        return null;
      }

      final List<dynamic> voicesJSON = jsonResponse['voices'].toList();

      if (voicesJSON == null) {
        return null;
      }

      final voices = Voice.mapJSONStringToList(voicesJSON);
      return voices;
    } on Exception catch(e) {
      print("$e");
      return null;
    }

  }

  Future<Map<String, dynamic>> _postJson(Uri uri, Map jsonMap) async {
    try {
      final httpRequest = await _httpClient.postUrl(uri);
      final jsonData = utf8.encode(json.encode(jsonMap));
      final jsonResponse = await _processRequestIntoJsonResponse(httpRequest, jsonData);
      return jsonResponse;
    } on Exception catch(e) {
      print("err: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final jsonResponse = await _processRequestIntoJsonResponse(httpRequest, null);
      return jsonResponse;
    } on Exception catch(e) {
      print("$e");
      return null;
    }
  }

  Future<Map<String, dynamic>> _processRequestIntoJsonResponse(HttpClientRequest httpRequest, List<int> data) async {
    try {
      httpRequest.headers.add('X-Goog-Api-Key', _apiKey);
      httpRequest.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
      httpRequest.headers.add(HttpHeaders.authorizationHeader, 'Bearer ya29.a0AfH6SMDdYf8-A1PkNGJ_X7jhI60dshv0iBZA87CgACSJr2uZ24LuFLqvAELsTgEeAkxV5hR-l4V_o-39Uk7PsAVaVda1YEVDIeIo0nAaKArcr11KsWrvW8loyG_wujwzgZdxdFy6ejP87cxnFZjtbXgPsfGxtdfQha0');
      // console.log("TextToSpeechAPI -> Future<dynamic>synthesizeText -> jsonResponse", jsonResponse)
      if (data != null) {
        httpRequest.add(data);
      }
      final httpResponse = await httpRequest.close();
      print(httpResponse.statusCode);
      if (httpResponse.statusCode != 200) {
        throw Exception('Bad Response');
      }
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch(e) {
      print("$e");
      return null;
    }
  }

}
