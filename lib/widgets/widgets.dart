import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_management/views/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

PreferredSizeWidget appBar(BuildContext context){
  return AppBar(
    automaticallyImplyLeading: context.toString().contains("SignIn")?false: true,
    backgroundColor: Colors.black,
    title: Container(
      child: Row(
        children: [
          Text("अन्नपूर्णा" , style: TextStyle(color: Color.fromRGBO(190, 10, 13, 2), fontWeight: FontWeight.bold),)

        ],
      ),
    ),
  );
}
int count = 0;
String name="";
String email ="";


Future<void> getFirebaseData() async {



  DocumentSnapshot document  = await FirebaseFirestore.instance.collection('userData').doc(FirebaseAuth.instance.currentUser?.uid).get();
  count = document.get('active_post');
  name=document.get('name');
  email=document.get('email');
}


Widget drawer(BuildContext context){

  getFirebaseData();


  return Drawer(
    child: Container(
      decoration: BoxDecoration(
          color:  Color(0xff1F1F1F)
      ),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(12, 87, 199, 2),
                            Color.fromRGBO(12, 87, 100, 2),
                          ]
                      )
                  ),
                  //color: Color.fromRGBO(160, 204, 57, 2),
                  alignment: Alignment.topLeft,
                  //color: Color.fromRGBO(160, 204, 57, 2) ,
                  height: 200,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage: AssetImage('assets/images/user.png'),
                                  radius: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 2.0),
                        //     child: Text(
                        //       "status",
                        //       style: TextStyle(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black
                        //       ),),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                createDrawerItem(
                    icon: Icons.email, text: email, n: 1, context: context),

                createDrawerItem(
                    icon: Icons.post_add,
                    text: count.toString(),
                    n: 5,
                    context: context),



              ],
            ),
          ),
          Container(
            child: FlatButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "Logout ?",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, "/auth");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      color:  Color.fromRGBO(203, 20, 13, 2),
                    ),
                    DialogButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(116, 116, 191, 1.0),
                        Color.fromRGBO(52, 138, 199, 1.0)
                      ]),
                    )
                  ],
                ).show();

              },
              child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(34)

                  ),
                  child: Text('Log Out !', style: TextStyle(color: Colors.red, fontSize: 12),)),
            ),
          )
        ],
      ),
    ),
  );
}

Widget createDrawerItem(
    {IconData? icon,
      String? text,
      GestureTapCallback? onTap,
      int? n,
      BuildContext? context}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon , color: Color.fromRGBO(203, 20, 13, 2),),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text! , style: TextStyle(color: Colors.white),),
        )
      ],
    ),
  );
}