import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone_app/resources/firebase_repository.dart';
import 'package:skype_clone_app/screens/home_screen.dart';
import 'package:skype_clone_app/screens/login_screen.dart';
import 'package:skype_clone_app/screens/pageviews/search_screen.dart';
/*https://github.com/Ronak99/Skype-Clone/tree/Part-12-Video_Calling_Over_Network*/ 
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  XFirebaseRepository _repository = XFirebaseRepository();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Skype Clone",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/search_screen' : (context) => XSearchScreen(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context,AsyncSnapshot<FirebaseUser> snapshot){
             // XFirebaseRepository().signOut();

          if(snapshot.hasData){
            return XHomeScreen();
          }else{
            return XLoginScreen();
          }
        },
      ),
    );
  }
}

