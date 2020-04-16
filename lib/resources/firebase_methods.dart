
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone_app/models/message.dart';
import 'package:skype_clone_app/models/users.dart';
import 'package:skype_clone_app/utils/utilities.dart';

class XFirebaseMethods {
  
  //VAR
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore _firestore =Firestore.instance;

  XUser _user = XUser();

  //METHODS
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication = await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken
    );

    //FirebaseUser user = await _auth.signInWithCredential(credential).then((user){user.user;});
    AuthResult user = await _auth.signInWithCredential(credential);

    return user.user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await _firestore
      .collection("users")
      .where("email", isEqualTo: user.email)
      .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length ==0 ? true : false ; 
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = XUtils.getUserName(currentUser.email);

    _user = XUser(uid:currentUser.uid, 
      email: currentUser.email, 
      name: currentUser.displayName, 
      profilePhoto: currentUser.photoUrl,
      username: username, 
    );

    _firestore
      .collection("users")
      .document(currentUser.uid)
      .setData(_user.toMap(_user));
  }

  Future<void> signOut() async {
   // await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<XUser>> fetchAllUsers(FirebaseUser currentUser) async {
    List<XUser> userList= List<XUser>();

    QuerySnapshot _querySnapshot = await _firestore.collection("users").getDocuments();
    for(var i = 0; i< _querySnapshot.documents.length;i++){
      if(_querySnapshot.documents[i].documentID!= currentUser.uid){
        userList.add(XUser.fromMap(_querySnapshot.documents[i].data));
      }
    }
    return userList; 
  }

  Future<void> addMessageToDb(XMessage message, XUser senderuser, XUser receiveruser) async {
    var messagemap = message.toMap();

    await _firestore
      .collection("messages")
      .document(message.senderId)
      .collection(message.receiverId)
      .add(messagemap);     

     return await _firestore
      .collection("messages")
      .document(message.receiverId)
      .collection(message.senderId)
      .add(messagemap);     
  }

}

