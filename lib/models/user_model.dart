


class User_Model {
final String uid;
final String name;
final String proPic;
final bool isOnline;
final String phoneNumber;
final List<dynamic> groupIds;

  User_Model({required this.uid,
   required this.name,
    required this.proPic,
     required this.isOnline,
      required this.phoneNumber,
       required this.groupIds});

  Map<String , dynamic> toMap(){
return {
'uid':uid,
'name':name,
'propic':proPic,
'isOnline':isOnline,
'phoneNumber':phoneNumber,
'groupIds':groupIds
};
  } 

  factory User_Model.fromMap(Map<String,dynamic> map){
    return User_Model(
     uid: map['uid'] ?? '',
     name: map['name'] ?? '',
     proPic: map['propic'] ?? '',
     isOnline: map['isOnline'] ?? '',
     phoneNumber: map['phoneNumber'] ?? '',
     groupIds: map['groupIds'] ?? '' );
  }








}