import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/other_profile.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:matching_app/screen/main/profile_people_screen.dart';

import '../bloc/cubit.dart';

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
    AppCubit appCubit = AppCubit.get(context);
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: info.matching_check !="1"? info.private_age == "1" || info.private_matching == "1" ? ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      colors: [Colors.transparent, Colors.transparent, Colors.black],
                      stops: [0, 0.1, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Stack(
                    children: [
                      Image.network(
                        "http://greeme.net/uploads/" + info.photo1,
                        width: 165,
                        height: 165,
                      ),
                      Container(
                        width: 165,
                        height: 165,
                        color: Colors.grey.withOpacity(0.9),
                      ),
                    ],
                  ),
                ):Image.network(
                  "http://greeme.net/uploads/" + info.photo1,
                  width: 165,
                  height: 165,
                ):Image.network(
                  "http://greeme.net/uploads/" + info.photo1,
                  width: 165,
                  height: 165,
                )
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
                                      fontSize: 16, color: PRIMARY_FONT_COLOR, fontWeight: FontWeight.bold ))
                            ])),
                    SizedBox(
                        width: vww(context, 90) - 70,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${info.residence+ "                       " + info.age+"歳"}",
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
                                          if(isBlockedUser != true){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => OtherProfile(info : info.user_id, matching_data:info.matching_check,)));
                                          }
                                          else{
                                            appCubit.changeBlockStatus(info.user_id);
                                            Navigator.pushNamed(context, "/blocked_users_screen");
                                          }
                                        },
                                        child: Text("ブロック解除",
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
