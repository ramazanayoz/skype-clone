import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype_clone_app/models/users.dart';
import 'package:skype_clone_app/resources/firebase_repository.dart';
import 'package:skype_clone_app/screens/chatscreens/chat_screen.dart';
import 'package:skype_clone_app/utils/universal_veriables.dart';
import 'package:skype_clone_app/widgets/custom_tile.dart';

class XSearchScreen extends StatefulWidget {
  @override
  _XSearchScreenState createState() => _XSearchScreenState();
}

class _XSearchScreenState extends State<XSearchScreen> {
  //VAR
  XFirebaseRepository _repository = XFirebaseRepository();
  List<XUser> _userList;
  String _query ="";
  TextEditingController _searchController = TextEditingController(); 
  
  //FONKS
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _repository.getCurrentUser().then((FirebaseUser user){
      _repository.fetchAllUsers(user).then((List<XUser> list) {
        setState(() {
          print("lisst${list}");
          _userList = list;
        });
      });
    });
  }

  //DESİGNS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XUniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(_query),
      ),
    );
  }

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      backgroundColorStart: XUniversalVariables.gradientColorStart,
      backgroundColorEnd: XUniversalVariables.gradientColorEnd,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,), 
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight+20),
        child:  Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _query = val;
              });
            },
            cursorColor: XUniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white,), 
                onPressed: (){
                  _searchController.clear();
                  WidgetsBinding.instance.addPostFrameCallback( (_) => _searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:35,
                color: Color(0x88ffffff),
              )
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
      final List<XUser> suggestionList = query.isEmpty ? []
        : _userList != null
          ?_userList.where((XUser xuser){
            print("xxzcxz:${xuser.username}");
            String _getUsername = xuser.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName =  xuser.name.toLowerCase();
            bool matchesUserName = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);
            print("query: ${_query} xuser: ${xuser.name}");
            
            return (matchesUserName || matchesName);
        }).toList() : [];
      print("suggestionList: ${suggestionList}");
      
      return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context, index){
          
          XUser searchedUser = XUser(
            uid:  suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,  
            name: suggestionList[index].name,
            username: suggestionList[index].username
          );

          return XCustomTile( 
            mini: false,
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => XChatScreen(receiverUser : searchedUser,) ) );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.profilePhoto),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              searchedUser.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              searchedUser.name,
              style: TextStyle(color: XUniversalVariables.greyColor),
            ),
          );

        })
      );
  }


}