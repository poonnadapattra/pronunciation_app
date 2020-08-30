import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:pronunciation_app/TextToSpeechAPI.dart';
import 'package:pronunciation_app/screens/login.dart';
import 'package:pronunciation_app/voice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' show json, jsonEncode, utf8;
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'DeepMind WaveNet Text To Speech',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        // primarySwatch: Colors.teal,
      ),
      home: LoginPage(),
      // home: new MyHomePage(title: 'DeepMind WaveNet Text To Speech'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Voice> _voices = [];
  Voice _selectedVoice;
  AudioPlayer audioPlugin = AudioPlayer();
  final TextEditingController _searchQuery = TextEditingController();


  initState() {
    super.initState();
    getVoices();
  }
  
  void auth() async {
    final jsonResponse = await http.post('https://texttospeech.googleapis.com/v1beta1/text:synthesize',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ya29.a0AfH6SMDuA-cTdJ2mWa8A5a7ImAriHJ53XaBmNVF07xSzcXZ3DHz4HzO9u4H_DpgaqyJ4Jw9VTDwT7NtDc4UA9xaznV1eYHxAUt67lQ1QnKpUYrKRX8e3mZhKrRR40vNMWHDT61GNWfG2nMvmuNf_HdxTkPwdu3pz4qQ'
          // Authorization: Bearer ya29.a0AfH6SMAQvBKL5pXwxOvTJu10ASh5jWWPWi6hgr6Gz9eDpvsYODorl7Z44IR7y_N5wYGI2hD2X3DPTL33qjpfxNRS3GlQuVA5bANTy7_pkdspLzzrTnEl4QjSHLFc6XsPnBZDUhkJ68aAWOmW_B2P7dF8yppNKT9CvfOo
          // 'Authorization': 'Bearer ya29.a0AfH6SMAQvBKL5pXwxOvTJu10ASh5jWWPWi6hgr6Gz9eDpvsYODorl7Z44IR7y_N5wYGI2hD2X3DPTL33qjpfxNRS3GlQuVA5bANTy7_pkdspLzzrTnEl4QjSHLFc6XsPnBZDUhkJ68aAWOmW_B2P7dF8yppNKT9CvfOo'
        },
        // body: jsonEncode(_json)
      );
  }


  void synthesizeText(String text, String name) async {
    print(text);
      if (audioPlugin.state == AudioPlayerState.PLAYING) {
        await audioPlugin.stop();
      }
      final String audioContent = await TextToSpeechAPI().synthesizeText(text, 'en-US-Wavenet-F', 'en-US');
      print(audioContent);
      if (audioContent == null) return;
      final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/wavenet.mp3');
      await file.writeAsBytes(bytes);
      await audioPlugin.play(file.path, isLocal: true);
  }
  
  void getVoices() async {
    final voices = await TextToSpeechAPI().getVoices();
    if (voices == null) return;
    setState(() {
      _selectedVoice = voices.firstWhere((e) => e.name == 'en-US-Wavenet-F' && e.languageCodes.first == 'en-US', orElse: () => Voice('en-US-Wavenet-F', 'FEMALE', ['en-US']));
      _voices = voices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: SingleChildScrollView(child:
        Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: DropdownButton<Voice>(
              value: _selectedVoice,
              hint: Text('Select Voice'),
              items: _voices.map((f) => DropdownMenuItem(
                value: f,
                child: Text('${f.name} - ${f.languageCodes.first} - ${f.gender}'),
              )).toList(),
              onChanged: (voice) {
                setState(() {
                  _selectedVoice = voice;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextField(
              autofocus: true,
              controller: _searchQuery,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: 'Please enter text to convert to WaveNet Speech'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Text('launch url'),
              onTap: () async {
                const url = "https://accounts.google.com/o/oauth2/v2/auth?redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=756540441847-uelprsnktfct6dj2vib2ofr1hb9k160n.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform&access_type=offline";
                // const url = "https://flutter.io";
                // if (await canLaunch(url))
                //   launch(url);
                // // else com.example.pronunciation_app
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
              },
            ),
          )
        ])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        child: Icon(Icons.audiotrack),
        onPressed: () {
          final text = _searchQuery.text;
          print(text);
          // if (text.length == 0 || _selectedVoice == null) return;
          synthesizeText(text, 'poon');
        },
      ),
    );
  }

}

class SecondPage extends StatelessWidget {
 
  final Uri uri;
 
  SecondPage(this.uri);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Text("benznest's blog")
    ),
        body: Container(child: Center(child: Text(uri.toString(), style: TextStyle(fontSize: 22),))));
  }
}