import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype_clone_app/models/message.dart';
import 'package:skype_clone_app/models/users.dart';
import 'package:skype_clone_app/resources/firebase_methods.dart';

class XFirebaseRepository {
  XFirebaseMethods _firebaseMethods = XFirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser>  signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
    _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user) => _firebaseMethods.addDataToDb(user);

  //responsible for signing out
  Future<void> signOut() =>  _firebaseMethods.signOut();

  Future<List<XUser>> fetchAllUsers(FirebaseUser user) => _firebaseMethods.fetchAllUsers(user);

  Future<void> addMessageToDb(XMessage message, XUser sender, XUser receiver) =>
    _firebaseMethods.addMessageToDb(message, sender, receiver);
}