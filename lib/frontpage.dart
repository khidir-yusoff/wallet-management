import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('images/background.jpg'),
                fit: BoxFit.cover)
            ),
          ),
          new Center(
            child: new GestureDetector(
              onTap: () {Navigator.of(context).pushReplacementNamed('/dashboard');},
            ),
          )
        ],)
    );
  }
}