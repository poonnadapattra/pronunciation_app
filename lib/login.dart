import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 1;
    final height = MediaQuery.of(context).size.height / 1;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Page')
      // ),
      body: Center(
        // width: MediaQuery.of(context).size.width / 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            RaisedButton(
              onPressed: () {},
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
                      Text('Google sign in', style: TextStyle(fontSize: 20)),
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