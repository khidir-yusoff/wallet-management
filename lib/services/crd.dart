import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class CrdMethod {
  Future<void> addData(transactionData) async {
    Firestore.instance.collection('transaction').add(transactionData);
  }

  getData() async {
    return await Firestore.instance.collection('transaction').getDocuments();
  }

  deleteData(id) {
    return Firestore.instance.collection('transaction').document(id).delete();
  }
}