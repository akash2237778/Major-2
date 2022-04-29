import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData , String userName) async {
    FirebaseFirestore.instance.collection("users").doc(userName).set(userData).catchError((e) {
      print(e.toString());
    });
  }
}