import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone_app/resources/firebase_repository.dart';
import 'package:skype_clone_app/screens/pageviews/chat_list_screen.dart';
import 'package:skype_clone_app/utils/universal_veriables.dart';

class XHomeScreen extends StatefulWidget {
  @override
  _XHomeScreenState createState() => _XHomeScreenState();  
}

class _XHomeScreenState extends State<XHomeScreen> {
  PageController _pageController;
  int _page = 0;

  //FUNCT
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    _pageController.jumpToPage(page);
  }

  //Desgin
  @override
  Widget build(BuildContext context) {
    double _labelFontSize =10;
   // XFirebaseRepository().signOut();
    return Scaffold(
      backgroundColor: XUniversalVariables.blackColor,
      body: PageView(
        children: <Widget>[
          Container(child: XChatListScreen(),),
          Center(child: Text("Call Logs")),
          Center(child: Text("Contact Screen")),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged, ///???
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: XUniversalVariables.blackColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat, 
                  color: (_page ==0) ? XUniversalVariables.lightBlueColor : XUniversalVariables.greyColor
                ),
                title: Text(
                  "Chats", 
                  style: TextStyle(
                    fontSize:_labelFontSize, 
                    color: (_page ==0) ? XUniversalVariables.lightBlueColor : Colors.grey, 
                  )
                ) 
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.call, 
                  color: (_page ==1) ? XUniversalVariables.lightBlueColor : XUniversalVariables.greyColor
                ),
                title: Text(
                  "Chats", 
                  style: TextStyle(
                    fontSize:_labelFontSize, 
                    color: (_page ==1) ? XUniversalVariables.lightBlueColor : Colors.grey, 
                  )
                ) 
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.contact_phone, 
                  color: (_page ==2) ? XUniversalVariables.lightBlueColor : XUniversalVariables.greyColor
                ),
                title: Text(
                  "Chats", 
                  style: TextStyle(
                    fontSize:_labelFontSize, 
                    color: (_page ==2) ? XUniversalVariables.lightBlueColor : Colors.grey, 
                  )
                ) 
              ),                            
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),

    );
  }
  
}