import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/constants/app_constants.dart';
import 'package:matching_app/constants/app_styles.dart';
import 'package:matching_app/communcation/home_commun/communicate_item.dart';
import 'package:matching_app/communcation/home_commun/communicate_controller.dart';
import 'package:matching_app/screen/main/community_screen.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/components/main_community_widget.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/screen/main/layouts/users_bottom_modal.dart';
import 'package:matching_app/utile/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/bloc/cubit.dart';

class CommunicateCard extends ConsumerStatefulWidget {
  const CommunicateCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final CommunicateItem info;
  final VoidCallback onPressed;

  @override
  ConsumerState<CommunicateCard> createState() => _CommunicateCardState();
}
class _CommunicateCardState extends ConsumerState<CommunicateCard> {

  @override
  Widget build(BuildContext context) {
    CommunicateItem boardInfo = widget.info;
    AppCubit appCubit = AppCubit.get(context);
    return Container(
      child: Column(
        children:[
          Padding(padding: EdgeInsets.only(left: 7,),
            child:Column(children: [
              SizedBox(
                child:Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(),
                      child:InkWell(
                        onTap: (){
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            shape:
                                const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .vertical(
                                top: Radius.circular(
                                    25),
                              ),
                            ),
                            builder: (context) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                    left: vww(context, 3),
                                    right: vww(context, 3),
                                    top: 20,
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: SizedBox(
                                    height: vhh(context, 45),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Center(
                                            child: Container(
                                          width: vw(context, 20),
                                          height: 5,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50.0),
                                              color: PRIMARY_FONT_COLOR),
                                        )),
                                        const Text(
                                          "コミュニティー参加で\nもっと友達に",
                                          style: TextStyle(fontSize: 15, color: PRIMARY_FONT_COLOR),
                                          textAlign: TextAlign.center,
                                        ),
                                        // const FractionallySizedBox(
                                        //     widthFactor: 0.3,
                                        //     child: MainCommunityWidget(
                                        //         isChecked: false,
                                        //         label: "ゴルフ",
                                        //         NetworkImage(""), )),
                                        Column(
                                          children: [
                                            Image.network("http://192.168.144.61:8000/uploads/"+boardInfo.community_photo, width: 100, height: 100,),
                                            Text(boardInfo.community_name, 
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Color.fromARGB(255, 0, 0, 0),
                                              ),
                                            ),
                                            Text(boardInfo.community_count + " 人" ?? "0 人", 
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: RadiusButton(
                                                text: "参加する",
                                                color: BUTTON_MAIN,
                                                goNavigation: (id) {
                                                  Navigator.pop(context);

                                                  showMaterialModalBottomSheet(
                                                      context: context,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(25),
                                                        ),
                                                      ),
                                                      builder: (context) {
                                                        appCubit.formatButton();
                                                        return UsersBottomModal(sub_id: boardInfo.sub_category_id);
                                                      });
                                                },
                                                id: 0,
                                                isDisabled: false))
                                      ],
                                    )),
                                  );
                            });
                        },
                        child: Column(
                          children: [
                            Image.network("http://192.168.144.61:8000/uploads/"+boardInfo.community_photo, width: 100, height: 100,),
                            Text(boardInfo.community_name, 
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(boardInfo.community_count + " 人" ?? "0 人", 
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],),
          ), 
          
      ]),
    );
  }
}
