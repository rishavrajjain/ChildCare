import 'package:first_screen/Authentication.dart';
//import 'package:first_screen/LoginRegisterPage.dart';
//import 'package:first_screen/ui/HomePage.dart';
import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Authentication.dart';

//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'ProfileScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On Care',
      theme: ThemeData(
        
        primarySwatch: Colors.pink,
      ),
      home: MappingPage(auth: Auth(),),//LoginRegisterPage(),
    );
  }
}

