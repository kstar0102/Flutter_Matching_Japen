import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:matching_app/screen/main/profile_people_screen.dart';
import 'package:matching_app/screen/main/chatting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:intl/intl.dart';

class UserInfoItems extends StatefulWidget {
  final PeopleItem info;
  final VoidCallback onPressed;
  const UserInfoItems({ 
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);
  @override
  State<UserInfoItems> createState() => _UserInfoItemsState();
}
class _UserInfoItemsState extends State<UserInfoItems> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isCurrentDateEqualToCreatedDate(String createdAt) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Parse the created_at value into a DateTime object
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime createdDate = format.parse(createdAt);

    // Compare the current date with the created date
    bool isEqual = currentDate.year == createdDate.year &&
        currentDate.month == createdDate.month &&
        currentDate.day == createdDate.day;

    // Return the result
    return isEqual;
  }

  @override
  Widget build(BuildContext context) {
    PeopleItem boardInfo = widget.info;
    String avatar = boardInfo!.photo1;
    String badge_name = boardInfo.badge_name;
    List<String> numberArray = badge_name.split(",");
    List<String> badgeArray = boardInfo.badge_color.split(",");
    AppCubit appCubit = AppCubit.get(context);
    bool isNew = isCurrentDateEqualToCreatedDate(boardInfo.created_at);
    List<BadgeItemObject> badgeList = [];
    String? tab_val;
    for (var i = 0; i < numberArray.length; i++) {
      badgeList.add(BadgeItemObject(i, numberArray[i], false, badgeArray[i]));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
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
                  tab_val: "0",
              ),
            ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              "http://192.168.144.61:8000/uploads/" + avatar,
              width: 165,
              height: 165,
            ),
          ),
        ),
        boardInfo.age != ""
        ? Padding(
          padding: const EdgeInsets.only(
                        left: 1, right: 1,),
          child: Wrap(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: 7, top: 5, right: 10, bottom: 5),
                    child: Text(
                      "${boardInfo.age} 歳",
                      style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: PRIMARY_FONT_COLOR),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 5, top: 5, right: 1, bottom: 5),
                    child: Text(
                      boardInfo.user_nickname,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold, color: PRIMARY_FONT_COLOR),
                      textAlign: TextAlign.start,
                    )),
                boardInfo.identity_state == "1" ? 
                    Padding(
                      padding: EdgeInsets.only(
                        left: 5, top: 5, right: 5, bottom: 5),
                      child: Image(
                        image: AssetImage("assets/images/status/on.png"),
                        width: 15) ) : Padding(padding: EdgeInsets.only(
                        left: 1, top: 5, right: 5, bottom: 5),),
                isNew == true
                    ?
                    Padding(
                      padding: EdgeInsets.only(
                        left: 1, top: 5, right: 1, bottom: 5),
                      child: Container(
                        width: 30,
                        padding: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromARGB(255, 255, 157, 0)),
                        child: const Text("New", style: TextStyle(fontSize: 8, color: Colors.white), textAlign: TextAlign.center,),
                      )
                    )
                    : Padding(padding: EdgeInsets.only(
                        left: 1, top: 5, right: 10, bottom: 5),),
              ],
            ),
        )
        : Container(),
        SizedBox(
          height: 50,
          width: 150,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 5,
              runSpacing: 8,
              children: badgeList.map((BadgeItemObject e) {
                String textColor = e.color;
                return FilterChip(
                  label: Text(e.title,
                      style: TextStyle(
                          fontSize: 10,
                          color:
                          Color(int.parse(textColor.substring(2, 7),
                                      radix: 16) +
                                  0xFF000000))),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        color: Color(int.parse(textColor.substring(2, 7),
                                radix: 16) +
                            0xFF000000),
                        width: 1.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Colors.white,
                  selectedColor: Color(
                      int.parse(textColor.substring(2, 7), radix: 16) +
                          0xFF000000),
                  onSelected: (bool value) {},
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
