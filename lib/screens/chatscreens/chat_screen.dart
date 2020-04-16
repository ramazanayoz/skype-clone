import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone_app/models/message.dart';
import 'package:skype_clone_app/models/users.dart';
import 'package:skype_clone_app/resources/firebase_repository.dart';
import 'package:skype_clone_app/utils/universal_veriables.dart';
import 'package:skype_clone_app/widgets/appbar.dart';
import 'package:skype_clone_app/widgets/custom_tile.dart';

class XChatScreen extends StatefulWidget {
  //CONSTRUCTUR
  final XUser receiverUser;

  XChatScreen({this.receiverUser});

  @override
  _XChatScreenState createState() => _XChatScreenState();
}

class _XChatScreenState extends State<XChatScreen> {
  //VAR
  TextEditingController _textEditingController = TextEditingController();
  bool _isWriting = false;
  
  XUser _senderUser;
  XFirebaseRepository _firebaseRepository = XFirebaseRepository();
  String _currentUserId;

  //FUNCTİONS
  @override
  void initState(){
    super.initState();
    _firebaseRepository.getCurrentUser().then((user){
      print("getCurrentUser()::${user}");
      _currentUserId = user.uid;
      setState(() {
        _senderUser = XUser(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  sendMessage(){
    var text = _textEditingController.text;
    
    XMessage _message = XMessage(
      receiverId: widget.receiverUser.uid,
      senderId: _senderUser.uid,
      message: text, 
      timestamp: FieldValue.serverTimestamp(),
      type: 'text',
    );

    setState(() {
      _isWriting = false;
    });

    _firebaseRepository.addMessageToDb(_message, _senderUser, widget.receiverUser);
  }

  //DESİGNS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XUniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList()
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList(){
    print("messageList() fonk working");
    return StreamBuilder(
      stream: Firestore.instance
        .collection("messages")
        .document(_currentUserId)
        .collection(widget.receiverUser.uid)
        .orderBy("timestamp",descending:true)
        .snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot>  snapshot){
        if(snapshot.data == null){
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return chatMessageItem(snapshot.data.documents[index]);
          }
        );
      }
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot){
    print("chatMessageItem() fonk working");
    return Container(
      margin: EdgeInsets.symmetric(vertical:15),
      alignment:Alignment.centerRight,
      child: Container(
        alignment: snapshot["senderId"] == _currentUserId ? Alignment.centerRight : Alignment.centerLeft,
        child: snapshot['senderId'] == _currentUserId ? senderLayout(snapshot): receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot){
    print("senderLayout() fonk working");
    Radius xmessageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top:12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65,),
      decoration: BoxDecoration(
        color: XUniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: xmessageRadius,
          topRight: xmessageRadius,
          bottomLeft: xmessageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(snapshot),
      ),
    );
  }


  Widget receiverLayout(DocumentSnapshot snapshot){
    print("receiverLayout() fonk working");
    Radius xmessageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top:12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: XUniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: xmessageRadius,
          topRight: xmessageRadius,
          bottomLeft: xmessageRadius,
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(snapshot),
      ),
    );
  }  

  getMessage(DocumentSnapshot snapshot){
    return Text(
      snapshot['message'],
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  Widget chatControls(){
    setWritingTo(bool val){
      setState(() {
        _isWriting = val;
        print("_isWriting: ${_isWriting}");
      });
    }

    addMediaModal(context){
      showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: XUniversalVariables.blackColor, 
        builder: (context){
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    XModalTile(
                      title: "Media",
                      subtitle: "Share Photos and Videos",
                      icon: Icons.image,
                    ),
                    XModalTile(
                      title: "File",
                      subtitle: "Share files",
                      icon: Icons.tab,
                    ),
                    XModalTile(
                      title: "Contact",
                      subtitle: "Share contacts",
                      icon: Icons.contacts,
                    ),
                    XModalTile(
                      title: "Location",
                      subtitle: "Share a location",
                      icon: Icons.add_location,
                    ),
                    XModalTile(
                      title: "Schedule Call",
                      subtitle: "Arrange a skype call and get reminders",
                      icon: Icons.schedule,
                    ),
                    XModalTile(
                      title: "Create Poll",
                      subtitle: "Share polls",
                      icon: Icons.poll,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      );
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          new GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: XUniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val){
                (val.length > 0 && val.trim() !="" )? setWritingTo(true) : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: XUniversalVariables.greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.symmetric(horizontal:20, vertical: 5),
                filled: true,
                fillColor: XUniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: (){},
                  child: Icon(Icons.face),
                )
              ), //metine yazılan string
            )
          ),
          _isWriting ? Container() : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.record_voice_over),
          ),
          _isWriting ? Container() : Icon(Icons.camera_alt),
          _isWriting 
            ? Container(
                margin:EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  gradient: XUniversalVariables.fabGradient,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    size:15,
                  ),
                  onPressed: ()=> sendMessage(),
                ),
            ) : Container(),
        ],
      ),
    );
  }

  XCustomAppBar customAppBar(context) {
    return XCustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiverUser.name,
      ),
      actions: <Widget>[
        new IconButton(
          icon: Icon(
            Icons.video_call,
          ), 
          onPressed: (){},
        ),
        new IconButton(
          icon: Icon(Icons.phone), 
          onPressed: (){},
        )
      ],
    );
  }
}


class XModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
 
  //CONSTRUCTUR
  const XModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: XCustomTile(
        mini:false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: XUniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: XUniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: XUniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

}