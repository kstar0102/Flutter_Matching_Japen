import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:matching_app/screen/main/profile_people_screen.dart';

class UserListItem extends StatelessWidget {
  final PeopleItem info;
  final VoidCallback onPressed;
  final bool isBlockedUser;

  const UserListItem({
    Key? key,
    required this.info,
    required this.onPressed,
    required this.isBlockedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromARGB(255, 237, 237, 237)))),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage('http://greeme.net/uploads/' + info.photo1),
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
            Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 15, left: 10, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: vww(context, 90) - 70,
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${info.user_nickname}",
                                  style: TextStyle(
                                      fontSize: 16, color: PRIMARY_FONT_COLOR))
                            ])),
                    SizedBox(
                        width: vww(context, 90) - 70,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${info.residence+ " " + info.age+"歳"}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 151, 157, 170),
                                      letterSpacing: -2.4)),
                              Container(
                                  height: 25.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isBlockedUser == true ? const Color.fromARGB(255, 255, 70, 70) : BUTTON_MAIN,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      color: isBlockedUser == true ? const Color.fromARGB(255, 255, 70, 70) : BUTTON_MAIN),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProfilePeopleScreen(info : info.user_id)),);
                                        },
                                        child: Text("いいね",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white)),
                                      ) 
                                    ))
                            ])),
                  ],
                ))
          ],
        ));
  }
}
