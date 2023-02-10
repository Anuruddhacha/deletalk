


class ChatRoom{
  final String createrId;
  final String receiverId;
  final DateTime timeCreated;
  final bool delete;
  final bool hidePhone;



  ChatRoom({required this.createrId,
   required this.receiverId,
    required this.timeCreated,
    required this.delete,
    required this.hidePhone});

      factory ChatRoom.fromMap(Map<String,dynamic> map){
         return ChatRoom(
          createrId: map['createrId'] ?? '',
          receiverId: map['receiverId'] ?? '',
          delete: map['delete'],
          timeCreated: map['timeCreated'].toDate(),
          hidePhone: map['hidePhone'],
          );}


      Map<String ,dynamic> toMap(){
        return {
          'createrId': createrId,
          'receiverId': receiverId,
          'timeCreated': timeCreated,
          'delete':delete,
          'hidePhone':hidePhone
        };
      }



}