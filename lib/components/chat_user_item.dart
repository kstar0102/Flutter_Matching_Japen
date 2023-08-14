import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/cubit.dart';
import '../screen/main/chatting_screen.dart';
class ChatUserItem extends StatefulWidget {
  final PeopleItem info;
  final VoidCallback onPressed;
  const ChatUserItem({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);
  @override
  State<ChatUserItem> createState() => _ChatUserItemState();
}



class _ChatUserItemState extends State<ChatUserItem> {
  String? tab_val;
  
  @override
  Widget build(BuildContext context) {
    PeopleItem boardInfo = widget.info;
    AppCubit appCubit = AppCubit.get(context);
    String lastMessage = boardInfo.last_msg;
    String displayText = (lastMessage != "" && lastMessage.length > 15)
                  ? "${lastMessage.substring(0, 15)}..."
                  : lastMessage !=""? lastMessage: "チャット記録はありません。";

    Widget summary = boardInfo.is_read== 'null'?
      Text(displayText == "null"?'':displayText,
      textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey[500]
              )):
      Text(displayText,
      textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 15,
              color: PRIMARY_FONT_COLOR,
              ));

    return InkWell(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ChattingScreen(
              receiverUserPhone: boardInfo.phone_number,
              receiverUserToken: boardInfo.phone_token,
              receiverUserId: boardInfo.user_id,
              receiverUserAvatar: boardInfo.photo1,
              receiverUserName: boardInfo.user_nickname,
              receiverUserBadgeName: boardInfo.badge_name,
              receiverUserBadgeColor: boardInfo.badge_color,
              senderUserId: appCubit.user.phone_token,
              tab_val: "1",
              send_identy: appCubit.user.identityState,
              address: boardInfo.residence,
              age: boardInfo.age,
              payUser: appCubit.user.pay_user,
          ),
        ));
      },
      child:  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage('http://192.168.142.55:8000/uploads/' + boardInfo.photo1),
                radius: 50,
                backgroundColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(
                              244, 130, 34, 1)),
                      borderRadius:
                          BorderRadius.circular(55)),
                ),
              ),
            ),
            boardInfo.unread_message != "null"?
            Container(
                margin:
                    EdgeInsets.only(left: 45, top: 40),
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 0, 255, 8),
                    ),
                    child: Center(
                      child: Text(
                        '${boardInfo.unread_message}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                )):
              Container()
          ],
        ),
       
        Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 237, 237, 237)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  width: vww(context, 90) - 70,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("${boardInfo.user_nickname}",
                          style: TextStyle(
                              fontSize: 15, color: PRIMARY_FONT_COLOR)),
                      Text("${boardInfo.last_time=='null'?'':boardInfo.last_time}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 193, 192, 201)))
                    ])),
                summary
              ],
            ))
          ],
        ),
    ) ;
     
  }
}
