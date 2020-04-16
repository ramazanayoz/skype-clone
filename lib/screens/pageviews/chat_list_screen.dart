import 'package:flutter/material.dart';
import 'package:skype_clone_app/resources/firebase_repository.dart';
import 'package:skype_clone_app/utils/universal_veriables.dart';
import 'package:skype_clone_app/utils/utilities.dart';
import 'package:skype_clone_app/widgets/appbar.dart';
import 'package:skype_clone_app/widgets/custom_tile.dart';

class XChatListScreen extends StatefulWidget {
  @override
  _XChatListScreenState createState() => _XChatListScreenState();
}

//GLOBAL
final XFirebaseRepository _repository = XFirebaseRepository();

class _XChatListScreenState extends State<XChatListScreen> {
  
  //VAR
  String  _currentUserId;
  String _initials;

  //FUNCT
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user){
      setState(() {
        _currentUserId = user.uid;
        _initials = XUtils.getInitials(user.displayName);
      });
    });
  }

  //DESİGN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XUniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: XNewChatButton(),
      body: XChatListContainer(_currentUserId),
    );
  }

//header
  XCustomAppBar customAppBar(BuildContext context) {
      return XCustomAppBar(
          title: XUserCircle(_initials),
          centerTitle: true,        
          leading: IconButton(
            icon:  Icon(
              Icons.notifications,
              color:Colors.white,
            ),
            onPressed: (){
            },
          ),
          actions: <Widget>[

            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ), 
              onPressed: (){
                Navigator.pushNamed(context, "/search_screen");
              },
            ),
            
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ), 
              onPressed: (){},
            ),            
          ],
      );
  }

}

//NEW CLASS
class XChatListContainer extends StatefulWidget {
  //VAR
  final String _currentUserId;
  //CONSTRUCTUR
  XChatListContainer(this._currentUserId);

  @override
  _XChatListContainerState createState() => _XChatListContainerState();
}

class _XChatListContainerState extends State<XChatListContainer> {

 //DESİGNS Chat List
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index){
          return new XCustomTile(
            mini: false,
            onTap: (){},
            title: Text(
              "The CS Guy",
              style: TextStyle(
                color: Colors.white, fontFamily: "Arial", fontSize: 19,
              )
            ),
            subtitle: Text(
              "Hello",
              style: TextStyle(
                color: XUniversalVariables.greyColor,
                fontSize:14,
              )
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: XUniversalVariables.onlineDotColor,
                        border: Border.all(
                          color: XUniversalVariables.blackColor,
                          width: 2
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


//NEW CLASS
class XUserCircle extends StatelessWidget {
  //VAR
  final String _text;
  //CONSTRUCTUR
  XUserCircle(this._text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: XUniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[

          new Align(
            alignment: Alignment.center,
            child: Text(
              _text,
              style: TextStyle(
                fontWeight:  FontWeight.bold,
                color: XUniversalVariables.lightBlueColor,
                fontSize: 13,
              ),
            ),
          ),

          new Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: XUniversalVariables.blackColor,
                  width: 2
                ),
                color: XUniversalVariables.onlineDotColor
              ),
            ),
          )
        ],
      ),
    );
  }
}

//NEW CLASS

class XNewChatButton extends StatelessWidget {
  
  //DESİGN
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: XUniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}