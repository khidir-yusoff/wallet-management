import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/crd.dart';
import 'dart:async';
import 'dart:core';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  double _amount;
  String _desc, _tag = '';
  List<String> _tags = <String>['', 'Food/Grocery', 'Bills', 'Debt', 'Personal', 'Family', 'Household'];

  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>(debugLabel: '_formkey');
  CrdMethod crdObj = new CrdMethod();
  QuerySnapshot transactions;
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding( 
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (input){
                      if (input.isEmpty){
                        return 'Please enter the value';
                      }
                      return null;
                    },
                    onSaved: (input) => this._amount = double.parse(input),
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText:'Amount'
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                     validator: (input){
                      if (input.isEmpty){
                        return 'Please enter the description';
                      }
                      return null;
                    },
                    onSaved: (input) => this._desc = input,
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText:'Description'
                    ),
                  ),
                ),
                Padding( 
                  padding: EdgeInsets.all(8.0),
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tag',
                        ),
                        isEmpty: _tag == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _tag,
                            isDense: true,
                            onChanged: (String newValue){
                              setState(() {
                               this._tag = newValue;
                               state.didChange(newValue); 
                              });
                            },
                            items: _tags.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  )
                )
              ],
            )
          ),
          actions: <Widget>[
            FlatButton( 
              child: Text('Add'),
              onPressed: (){
                if (_formkey.currentState.validate()) {
                  _formkey.currentState.save();
                  Navigator.of(context).pop();
                  crdObj.addData({
                    'amount': this._amount,
                    'desc': this._desc,
                    'tag': this._tag,
                  }).then((result) {
                    dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                  _refreshPage();
                }
              },
            ),
          ],
        );
      }
    );
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success!'),
          content: Text('Transaction recorded.'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  @override
  void initState() {
    crdObj.getData().then((result) {
      setState(() {
       transactions = result; 
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold( 
      appBar: AppBar(  
        title: Text('Transaction'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_money),
            onPressed: (){
              addDialog(context);
            },
          )
        ],
      ),

      body: _transactionList(), 
    );
  }

  Widget _transactionList() {
    if (transactions != null) {
      return ListView.separated(
        separatorBuilder: (context,i) => Divider( 
          color: Colors.black,
        ),
        itemCount: transactions.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return new ListTile(
            title: Text('RM ' + transactions.documents[i].data['amount'].toStringAsFixed(2)),
            subtitle: Text(transactions.documents[i].data['tag']),
            onTap: (){
              AlertDialog alert = AlertDialog( 
                title: Text(transactions.documents[i].data['tag'] +
                  ', RM ' + transactions.documents[i].data['amount'].toStringAsFixed(2)),
                content: Text(transactions.documents[i].data['desc']),
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
                barrierDismissible: true,
              );
            },
            onLongPress: () {
              String id = transactions.documents[i].documentID;
              crdObj.deleteData(id);
              _refreshPage();
            },
          );
        },
      );
    } else {
      return Text('');
    }
  }

  _refreshPage() {
    crdObj.getData().then((result) {
      setState(() {
       transactions = result;
      });
    });
  }
}