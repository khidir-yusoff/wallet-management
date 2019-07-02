import 'package:flutter/material.dart';
import 'package:wallet_management/dashboard.dart';
import 'package:wallet_management/transaction.dart';

import 'frontpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Stonk Savings',
      home: FrontPage(),
      routes: <String, WidgetBuilder>{
        '/landingpage': (BuildContext context) => new MyApp(),
        '/dashboard': (BuildContext context) => new DashboardPage(),
        '/transaction': (BuildContext context) => new TransactionPage(),
      },
    );
  }
}
