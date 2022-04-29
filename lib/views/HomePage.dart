
import 'package:flutter/material.dart';
import 'package:food_management/views/AddFoodForm.dart';
import 'package:food_management/views/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../main.dart';
import '../widgets/widgets.dart';
import 'Timeline.dart';
import 'homeCardsView.dart';


class HomePage extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      drawer: drawer(context),
      body: Timeline(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFoodFormPage()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_card),
      ),
    );
  }
}

