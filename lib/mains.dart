import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Hello World'),
              InkWell(
                child: Text('Hello'),
                onTap: () {
                  synthesizeText('Hello', 'poon', 'en-gb');
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}

class APIKeyService {
  static const _apiKey = "e64a7c9bb00911caacab318c3ed2fe38188c8e97";

  static String fetch()  {
    return  _apiKey;
  }
}

Future<dynamic> synthesizeText(String text, String name, String languageCode) async {
  // var _apiURL = 'backoffice-api.waylar.net';
  var _apiURL = 'texttospeech.googleapis.com';
  try {
    final uri = Uri.https(_apiURL, '/v1beta1/text:synthesize');
    final Map _json = {
      "audioConfig": {
        "audioEncoding": "LINEAR16",
        "pitch": 0,
        "speakingRate": 1
      },
      "input": {
        "text": "Google Cloud Text-to-Speech enables developers to synthesize natural-sounding speech with 100+ voices, available in multiple languages and variants. It applies DeepMind’s groundbreaking research in WaveNet and Google’s powerful neural networks to deliver the highest fidelity possible. As an easy-to-use API, you can create lifelike interactions with your users, across many applications and devices."
      },
      "voice": {
        "languageCode": "en-US",
        "name": "en-US-Wavenet-D"
      }
    };

    final jsonResponse = await http.post('https://texttospeech.googleapis.com/v1beta1/text:synthesize',
    // headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer a0AfH6SMBOqD6QKTehjEsNVbGkqO2XRtQmL7rnB7_o8MWGvpezqb5RGncG8KUmTmCDwp0jox3tTF6IXBOhFmktuUI897eQkKx7gUV_UyoHGm93_4CLOQ9qisNcE4NGXfV5lAqXV36e73MqGWBPP52Lj52UXSNvC68o1uw'
    // },
      body: jsonEncode(_json)
    );
    print(jsonResponse.body);
    // final jsonResponse = await _postJson(uri, json);
    if (jsonResponse == null) return null;
    // final String audioContent = await jsonResponse['audioContent'];
    // return audioContent;
  } on Exception catch(e) {
    print("$e");
    return null;
  }
}
