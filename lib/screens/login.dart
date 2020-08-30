import 'package:flutter/material.dart';
import 'package:pronunciation_app/services/authGoogle.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController authCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 1;
    final height = MediaQuery.of(context).size.height / 1;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Container(
              width: width - 70,
              // height: 50,
              margin: EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: authCode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Enter an authorized code'
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: width - 70,
              margin: EdgeInsets.only(bottom: 15),
              child: InkWell(
                onTap: () {
                  authGoogle();
                },
                child: Text('Request authorized code.', style: TextStyle(fontSize: 14, color: Colors.blue))),
            ),
            RaisedButton(
              onPressed: () {
                // authGoogle();
              },
              color: Colors.white,
              child: Container(
                width: width - 100,
                height: 50,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 30,
                        child: Image.asset('assets/images/google-icon.png'),
                      ),
                      Text('auth with Google', style: TextStyle(fontSize: 20)),
                      Container(width: 20,),
                    ],
                  ))),
            ),
          ]
        ),
      )
    );
  }
}