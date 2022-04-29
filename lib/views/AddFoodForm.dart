import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_management/views/HomePage.dart';
import 'package:food_management/widgets/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:location/location.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import '../services/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
var controller = MapController(
  location: LatLng(0, 0),
);



class AddFoodFormPage extends StatefulWidget {
  const AddFoodFormPage({Key? key}) : super(key: key);

  @override
  _AddFoodFormPageState createState() => _AddFoodFormPageState();
}

class _AddFoodFormPageState extends State<AddFoodFormPage> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController addEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController plusCodeEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future<void> sendData(String uid, String description, String address, String mobile, String plus_code) async {

    String? id = FirebaseAuth.instance.currentUser?.uid;

    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot document  = await firestore.collection('userData').doc(id).get();

    int count = 0;
    count = document.get('active_post');
      firestore.collection('userData').doc(id).update(
        {
          'active_post': ( count + 1 ),
        }
      );



    CollectionReference data = firestore.collection('plate');
    // Call the user's CollectionReference to add a new user
    return data.doc(id! + ':'+ count.toString()).set({
      'uid': id,
      'description': description,
      'address': address,
      'mobile': mobile,
      'plus_code': plus_code
    })
        .then((value) => print("Data Added"))
        .catchError((error) => print("Failed to add data: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        drawer: drawer(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      validator: (val) {
                        return RegExp(
                            r"^\d{10}$")
                            .hasMatch(val!)
                            ? null
                            : "Please enter correct number";
                      },
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Phone number"),
                      controller: phoneEditingController,
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val!.length > 0
                            ? null
                            : "Description";
                      },
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Description"),
                      controller: textEditingController,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val!.length > 0
                            ? null
                            : "Address";
                      },
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Address"),
                      controller: addEditingController,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val!.length > 0
                            ? null
                            : "Plus Code";
                      },
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Plus Code"),
                      controller: plusCodeEditingController,
                    ),
                  ]),
                ),
                SizedBox(
                  height: 100,
                ),

                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: (){
                      if(formKey.currentState!.validate() ){
                        // DatabaseMethods().addData('EmergencyAlerts', {'SAP' : user.email.split('@')[0], 'actionTaken': false, 'description' : textEditingController.text , 'latitude': locationData.latitude.toString() , 'longitude' : locationData.longitude.toString(), 'timeStamp' : DateTime.now().millisecondsSinceEpoch.toString() });
                        sendData('uid', textEditingController.text, addEditingController.text, phoneEditingController.text, plusCodeEditingController.text);
                        Navigator.push(context,   MaterialPageRoute(builder: (context) => HomePage()));

                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: (){
                      launchURL('tel://+91-8882237778');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.black54, fontSize: 16);
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black54),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)));
}


Future Locate()async{
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();

  return _locationData;
  // return MapController(
  //     location: LatLng(_locationData.latitude, _locationData.longitude)
  // );

}



launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


