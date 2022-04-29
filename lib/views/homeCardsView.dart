import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flip_card/flip_card.dart';

var addedArr;


class CardsView extends StatefulWidget {
  @override
  _CardsViewState createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  late Stream userStream;


  @override
  Future<void> initState() async {
    // getUserInfogetChats();
    //setState(() {

    //});


    super.initState();
    await Firebase.initializeApp();
  }
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('plate').snapshots();




    @override
    Widget build(BuildContext context) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/banner.jpg')
              )
          ),
          child: Center(
            child: Container(

              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,

              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['full_name']),
                        subtitle: Text(data['company']),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }


class userStreamTile extends StatefulWidget {
  final String userName;
  final int index;
  final String status;
  final String gender;
  final String frndLeft;
  final String likes;

  userStreamTile({required this.userName,required this.index, required this.status , required this.gender, required this.frndLeft , required this.likes});

  @override
  _userStreamTileState createState() => _userStreamTileState();
}
class _userStreamTileState extends State<userStreamTile> {

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {



    return FlipCard(
      direction: FlipDirection.VERTICAL, // default
      front: Container(
      //  height: MediaQuery.of(context).size.height*0.7,
        width: MediaQuery.of(context).size.width,
        child: frontCard(),
      ),
      back: Container(
       // height: MediaQuery.of(context).size.height*0.7,
        width: MediaQuery.of(context).size.width,
        child: backCard(),
      ),
    );
  }

  Widget frontCard(){
    return Container(
      
       // height: MediaQuery.of(context).size.width*0.7,
        margin: EdgeInsets.only(top: 10, left: 10 , right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: [
                widget.gender == "Male" ? Color.fromRGBO(12, 87, 199, 2) : Color.fromRGBO(100, 10, 13, 2),
                widget.gender == "Male" ? Color.fromRGBO(12, 87, 100, 2) :Color.fromRGBO(170, 10, 13, 2)
              ]
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 50,
              backgroundImage: widget.userName == "Professor" ? AssetImage('assets/images/professorlogo.png') : AssetImage('assets/images/maskBlack.jpg'),
            ),
            Text(
              widget.userName, style: TextStyle(fontSize: 40 , fontWeight: FontWeight.bold , color: Colors.black),
            ),
          ],
        )
    );
  }

  Widget backCard(){
    return Container(
       // height: MediaQuery.of(context).size.width*0.7,
        margin: EdgeInsets.only(top: 10, left: 10 , right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: [
                widget.gender == "Male" ? Color.fromRGBO(12, 87, 100, 2) :Color.fromRGBO(170, 10, 13, 2),
                widget.gender == "Male" ? Color.fromRGBO(12, 87, 199, 2) : Color.fromRGBO(100, 10, 13, 2)
              ]
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('El Estado',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )),
            Center(
              child: Container(
                child: Text(
                  widget.status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(Icons.group),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(widget.frndLeft, style: TextStyle(fontSize: 18),),
                    ),
                  ],
                ),
                Icon( (addedArr[widget.index] == null? false : addedArr[widget.index] ) ? Icons.favorite : Icons.favorite_border, ),
                GestureDetector(
                  onTap: (){
                    // if(widget.userName != userEn.userName) {
                    //   print("Hello");
                    //   sendMessage(widget.userName);
                    // }
                  },
                    child: Icon(Icons.question_answer)),
                GestureDetector(
                  onTap: (){
//                     if(widget.userName != userEn.userName){
//
//                       //                        userEn.userLikes = (int.parse(userEn.userLikes) + 1).toString();
//                       Firestore.instance
//                           .collection("users")
//                           .document( widget.userName).updateData({"userLikes": (int.parse(widget.likes)+1).toString()});
//                       FirebaseDatabase.instance.reference().child("users/"+widget.userName+"/userLikes" ).set((int.parse(widget.likes)+1).toString());
// //                          HelperFunctions.saveUserInfo("USERLIKES", userEn.userLikes.toString());
//                     }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text(widget.likes, style: TextStyle(fontSize: 20),),
                      ),
                      Icon(Icons.thumb_up),

                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

              ],
            )
          ],
        )
    );
  }
}
/*
*
* onTap: (){
        if(widget.userName != userEn.userName) {
          print("Hello");
          sendMessage(widget.userName);
        }
      }*/