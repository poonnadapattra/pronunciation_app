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
import 'package:flutter/services.dart' show PlatformException;

 main(){
  checkDeepLink();
  runApp(MyApp());
}
 
Future checkDeepLink() async {
  StreamSubscription _sub;
  try {
    print("------checkDeepLink-------");
    // await getInitialLink();
    String initialLink = await getInitialLink();
    print('initialLink : $initialLink');
    _sub = getUriLinksStream().listen((Uri uri) {
      print(uri);
      runApp(MyApp(uri: uri));
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
 
      print("onError");
    });
  } on PlatformException {
    print("PlatformException");
  }
}
class MyApp extends StatelessWidget {
  final Uri uri;
 
  MyApp({this.uri});
 
  @override
  Widget build(BuildContext context) {
    checkDeepLink();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(uri: uri),
    );
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.uri}) : super(key: key);
  final Uri uri;
 
 
  @override
  Widget build(BuildContext context) {
 
    SchedulerBinding.instance.addPostFrameCallback((_){
      if(uri != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(uri)));
      }
    });
 
    return Scaffold(
      appBar: AppBar(
        title: Text("benznest's blog"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Deep link",
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
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