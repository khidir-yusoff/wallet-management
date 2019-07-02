import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/crd.dart';
//import 'dart:async';
import 'dart:core';

class DashboardPage extends StatefulWidget{
  @override 
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>{
  
  double _foodGrocery = 0, _bills = 0, _debt = 0, _personal = 0, _family = 0, _household = 0, _balance = 0;
  CrdMethod crdObj = new CrdMethod();
  QuerySnapshot transactions;

  @override
  void initState() { 
    crdObj.getData().then((results) {
      setState(() { 
        transactions = results;
        _balance = 0;
        _foodGrocery = 0;
        _bills = 0;
        _debt = 0;
        _personal =0;
        _family = 0;
        _household = 0;
      });
    });
    super.initState();
  }

  _refreshPage() {
    crdObj.getData().then((results) {
      setState(() { 
        transactions = results;
        _balance = 0;
        _foodGrocery = 0;
        _bills = 0;
        _debt = 0;
        _personal =0;
        _family = 0;
        _household = 0;
      });
    });
  }
        

  @override
  Widget build(BuildContext context){
    _refreshPage();

    var data = [
      new Spending('Food/Grocery', getFoodGrocery(), Colors.red),
      new Spending('Bills', getBills(), Colors.orange),
      new Spending('Debt', getDebt(), Colors.yellow),
      new Spending('Personal', getPersonal(), Colors.green),
      new Spending('Family', getFamily(), Colors.blue),
      new Spending('Household', getHousehold(), Colors.purple)
    ];

    var series = [
      new charts.Series(
        domainFn: (Spending spend, _) => spend.tag,
        measureFn: (Spending spend, _) => spend.amount,
        colorFn: (Spending spend, _) => spend.color,
        id: 'Spending',
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Dashboard'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.local_atm),
            onPressed: () {
              Navigator.pushNamed(context, '/transaction');
            },
          )
        ],
      ),

      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('This is your spending, so stonks, much wow.'),
            new Text('Your balance is: RM ' + getBalance().toString()),
            chartWidget,
          ],
        )
      ),
    );
  }

  double getBalance(){
    if (transactions != null){
      for (var i = 0; i < transactions.documents.length; i++) {
        _balance = _balance + transactions.documents[i].data['amount'];
      }
      return _balance;
    } else {
      return _balance = 0;
    }
  }

  double getFoodGrocery(){
    if (transactions != null){
      for (var i = 0; i < transactions.documents.length; i++) {
        if (transactions.documents[i].data['tag'] == 'Food/Grocery'){
          _foodGrocery = _foodGrocery + transactions.documents[i].data['amount'];
        }
      }
      return _foodGrocery;
    } else {
      return _foodGrocery = 0;
    }
  }

  double getBills(){
    if (transactions != null){
      for (var i = 0; i < transactions.documents.length; i++) {
        if (transactions.documents[i].data['tag'] == 'Bills'){
          _bills = _bills + transactions.documents[i].data['amount'];
        }
      }
      return _bills;
    } else {
      return _bills = 0;
    }
  }

  double getDebt(){
    if (transactions != null){
      for (var i = 0; i < transactions.documents.length; i++) {
        if (transactions.documents[i].data['tag'] == 'Debt'){
          _debt = _debt + transactions.documents[i].data['amount'];
        }
      }
      return _debt;
    } else {
      return _debt = 0;
    }
  }

  double getPersonal(){   
    if (transactions != null){
      for (var i = 0; i < transactions.documents.length; i++) {
        if (transactions.documents[i].data['tag'] == 'Personal'){
          _personal = _personal + transactions.documents[i].data['amount'];
        }
      }
      return _personal;
    } else {
      return _personal = 0;
    }
  }

  double getFamily(){
    if (transactions != null){
      for (var i = 0; i < transactions.documents.length; i++) {
        if (transactions.documents[i].data['tag'] == 'Family'){
          _family = _family + transactions.documents[i].data['amount'];
        }
      }
      return _family;
    } else {
      return _family = 0;
    }
  }

  double getHousehold(){
    if (transactions != null){
      for (var i = 0; i < transactions.documents.length; i++) {
        if (transactions.documents[i].data['tag'] == 'Household'){
          _household = _household + transactions.documents[i].data['amount'];
        }
      }
      return _household;
    } else {
    return _household = 0;
    }
  }  
}

class Spending {
  final String tag;
  final double amount;
  final charts.Color color;

  Spending(this.tag, this.amount, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha,
    );
}
