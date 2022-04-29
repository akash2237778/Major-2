import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {


  @override
  void initState() {

    super.initState();


  }



  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('plate').snapshots();


    return StreamBuilder(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return snapshot.hasData ?
        ListView.builder(

            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){

              return Card(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              Image(image: NetworkImage(
                                  'https://img.freepik.com/free-photo/delicious-vietnamese-food-including-pho-ga-noodles-spring-rolls-white-table_181624-34062.jpg'
                              )),


                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(snapshot.data?.docs.elementAt(index).get('description'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(snapshot.data?.docs.elementAt(index).get('address'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                ),
                              ),




                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: GestureDetector(
                                  onTap: (){
                                    launchURL('tel://+91' + snapshot.data?.docs.elementAt(index).get('mobile'));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Text('Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: GestureDetector(
                                  onTap: (){

                                    String plusCode = snapshot.data?.docs.elementAt(index).get('plus_code');
                                    print(plusCode.contains('+'));
                                    if(plusCode.contains('+')) {
                                      plusCode = plusCode.replaceAll('+', '%2B');
                                    }

                                    launchURL('https://www.google.com/maps?q=' + plusCode);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Text('Get Direction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),

                              // https://www.google.com/maps?q=88XH%2BJCM
                            ],
                          ),
                        ],
                      )
                    ],
                  )
              );

            })
            : Container();

      },
    );
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
