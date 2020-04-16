import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone_app/resources/firebase_repository.dart';
import 'package:skype_clone_app/screens/home_screen.dart';
import 'package:skype_clone_app/utils/universal_veriables.dart';

class XLoginScreen extends StatefulWidget {
  @override
  _XLoginScreenState createState() => _XLoginScreenState();
}

class _XLoginScreenState extends State<XLoginScreen> {
  
  //VAR
  XFirebaseRepository _repository = XFirebaseRepository();
  
  bool _isLoginPressed = false;

  //FUNCT
  void performLogin(){
    print("tring to perform login");
    setState(() {
      _isLoginPressed = true;
    });

    _repository.signIn().then((FirebaseUser user) {
      if(user != null){
        authenticateUser(user);
      }else {
        print("There was an error");
      }
    });
  }

  void authenticateUser(FirebaseUser user){
    print("authenticateuser fon working");
    _repository.authenticateUser(user).then((isNewUser){
      setState(() {
        _isLoginPressed = false;
      });
      //yeni kayıt oluşturuluyorsa çalışmata
      if(isNewUser){
        _repository.addDataToDb(user).then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return XHomeScreen();} ) );
        });
      }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return XHomeScreen();} ) );
      }
    });
  }

  //DESİGN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XUniversalVariables.blackColor,
      body:Stack(
        children: <Widget>[
          Center(    
            child: loginButton(),
          ),
          _isLoginPressed ? Center(child:CircularProgressIndicator(),) : Container(),
        ],
      )
    );
  }

  Widget loginButton(){
      return Shimmer.fromColors(
        baseColor: Colors.white, 
        highlightColor: XUniversalVariables.senderColor,
        child: FlatButton(
          padding: EdgeInsets.all(35),
          child: Text(
            "LOGIN",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2
            ),
          ),
          onPressed: () => performLogin(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
  }  



}