import 'package:cloud_firestore/cloud_firestore.dart';

class XMessage {
  String senderId;
  String receiverId;
  String type;
  String message;
  FieldValue timestamp;
  String photoUrl;

  //CONSTRUCTUR
  XMessage ({this.senderId, this.receiverId, this.type, this.message, this.timestamp});

  //will be only called when you wish to send an image
  XMessage.imageMessage({this.senderId, this.receiverId, this.message, this.type, this.timestamp, this.photoUrl});

  Map toMap(){
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

   XMessage fromMap(Map<String, dynamic> map){
    XMessage _message = XMessage();
    _message.senderId = map['senderId'];
    _message.receiverId = map['receiverId'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    return _message;
  }

}
