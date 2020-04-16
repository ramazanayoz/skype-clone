class XUser {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  //Constructur
  XUser({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.profilePhoto
  });


  //fonk
  Map toMap(XUser user) {
    var data = Map<String, dynamic>(); //map oluşturma
    data['uid'] = user.uid; //mapa eleman ekleme yapma
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data['status'] = user.status;
    data['state'] = user.state;
    data["profile_photo"] = user.profilePhoto;
    return data;
  }

  XUser.fromMap(Map<String, dynamic> mapData){
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }



}