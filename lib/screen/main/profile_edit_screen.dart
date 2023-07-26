import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/edit_avatar_widget.dart';
import 'package:matching_app/components/profile_info_item.dart';
import 'package:matching_app/components/profile_info_tall.dart';
import 'package:matching_app/components/profile_info_address.dart';
import 'package:matching_app/components/profile_info_nickname.dart';
import 'package:matching_app/components/profile_body_type.dart';
import 'package:matching_app/components/profile_blood_type.dart';
import 'package:matching_app/components/profile_education_type.dart';
import 'package:matching_app/components/profile_propose_type.dart';
import 'package:matching_app/components/profile_year_budget.dart';
import 'package:matching_app/components/profile_holiday_type.dart';
import 'package:matching_app/components/profile_ciga_type.dart';

import 'package:matching_app/screen/main/layouts/introduction_widget.dart';
import 'package:matching_app/screen/register/nick_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/utile/index.dart';
import 'layouts/profile_badge.dart';
import 'layouts/profile_edit_header.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:matching_app/controller/profile_controller.dart';
import 'package:matching_app/controller/profile_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: use_key_in_widget_constructors
class ProfileEditScreen extends ConsumerStatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  List<dynamic> items = [];
  List<BadgeObject> badgeList = [];
  List<bool> baseInfo = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  String photo1 = "";
  String photo2 = "";
  String photo3 = "";
  String photo4 = "";
  String photo5 = "";
  String photo6 = "";
  String nickName = "";
  List<dynamic> bloodType = [
    "A型",
    "B型",
    "O型",
    "AB型",
  ];
  List<dynamic> educationType = [
    "高校卒",
    "専門/高専卒",
    "大学卒",
    "大学院卒",
  ];
  List<dynamic> budgetType = [
    "200万円未満",
    "200万円～400万円",
    "400万円～600万円",
    "600万円から800万円",
    "800万円以上"
  ];

  List<dynamic> holidayType = [
    "平日",
    "土日",
    "祝日",
    "不定期"
  ];

  List<dynamic> cigaType = [
    "選択しない",
    "吸う",
    "たまに",
    "吸わない"
  ];

  List<dynamic> alcoholType= [
    "選択しない",
    "飲む",
    "たまに",
    "飲まない"
  ];
  @override
  void initState() {
    super.initState();
    AppCubit appCubit = AppCubit.get(context);
    photo1 = appCubit.user.photo1;
    photo2 = appCubit.user.photo2;
    photo3 = appCubit.user.photo3;
    photo4 = appCubit.user.photo4;
    photo5 = appCubit.user.photo5;
    photo6 = appCubit.user.photo6;
    items = [
      photo1,
      photo2,
      photo3,
      photo4,
      photo5,
      photo6,
    ];
    badgeList = [
      BadgeObject("とにかく話したい", false, 1),
      BadgeObject("いつでも", false, 2),
      BadgeObject("鉄板焼き", false, 3),
    ];
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();
  }
  void initStateItems() {
    setState(() {
      baseInfo = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final NickNameData = ref.watch(profileStateChangesProvider).value;
    
    if (NickNameData != null) {
      nickName = NickNameData.user_nickname??"TSUBASA";
    }
    AppCubit appCubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: ProfileEditHeader(title: "プロフィール"),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: vhh(context, 3)),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: double.infinity - 20,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: vww(context, 6)),
                                            child: 
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 15,
                                                  alignment:
                                                      WrapAlignment.spaceBetween,
                                                  children: 
                                                  List.generate(
                                                    items.length,
                                                    (index) {
                                                      return EditAvatarWidget(
                                                          item: items[index],
                                                          item_id: index);
                                                    },
                                                    ),
                                                  ),
                                                )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/self_introduction");
                                        },
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 30),
                                            child: IntroductionWidget(
                                                isEditScreen: true)),
                                                ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: vww(context, 6)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 17),
                                              child: Text("プロフィール",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          PRIMARY_FONT_COLOR))),
                                          ProfileInfoNickName(
                                              title: "ニックネーム",
                                              value: appCubit.change_nickname,
                                              onPressed: (state) {
                                                Navigator.pushNamed(
                                                    context, "/nick_name_edit");
                                              },
                                              isShowWheel: false),
                                          ProfileInfoAddress(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[0] = state;
                                                });
                                              },
                                              title: "居住地",
                                              value: appCubit.address_info,
                                              list: appCubit.addressList,
                                              isShowWheel: baseInfo[0]),
                                          ProfileInfoTall(
                                            
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[1] = state;
                                                });
                                              },
                                              title: "身長",
                                              value: appCubit.tall_height,
                                              list: appCubit.addressList,
                                              isShowWheel: baseInfo[1]),
                                          ProfileInfoBodyType(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[2] = state;
                                                });
                                              },
                                              title: "体型",
                                              value: appCubit.body_type,
                                              list: appCubit.bodyTypeList,
                                              isShowWheel: baseInfo[2]),
                                          profileBloodType(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[3] = state;
                                                });
                                              },
                                              title: "血液型",
                                              value:
                                              appCubit.blood_type == ""?"未設定":appCubit.blood_type,
                                              list: bloodType,
                                              isShowWheel: baseInfo[3]),
                                          profileEducationType(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[4] = state;
                                                });
                                              },
                                              title: "学歴",
                                              value: appCubit.edu_type == ""?"未設定":appCubit.edu_type,
                                              list: educationType,
                                              isShowWheel: baseInfo[4]),
                                          ProfileInfoProposeType(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[5] = state;
                                                });
                                              },
                                              title: "利用目的",
                                              value: appCubit.purpose_type,
                                              list: appCubit.purposeList,
                                              isShowWheel: baseInfo[5]),
                                          profileYearBudget(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[6] = state;
                                                });
                                              },
                                              title: "年収",
                                              value: appCubit.annual_budget == ""?"未設定":appCubit.annual_budget,
                                              list: budgetType,
                                              isShowWheel: baseInfo[6]),
                                          ProfileHolidayType(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[7] = state;
                                                });
                                              },
                                              title: "休日",
                                              value: appCubit.holi_info == ""?"未設定":appCubit.holi_info,
                                              list: holidayType, 
                                              isShowWheel: baseInfo[7]),
                                          ProfileCigaType(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[8] = state;
                                                });
                                              },
                                              title: "タバコ",
                                              value: appCubit.ciga_info == ""?"未設定":appCubit.ciga_info,
                                              list: cigaType, 
                                              isShowWheel: baseInfo[8]),
                                          ProfileInfoItem(
                                              onPressed: (state) {
                                                initStateItems();
                                                setState(() {
                                                  baseInfo[9] = state;
                                                });
                                              },
                                              title: "お酒",
                                              value: appCubit.alcohol_info == ""?"未設定":appCubit.alcohol_info,
                                              list: alcoholType, 
                                              isShowWheel: baseInfo[9]),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20, bottom: 5,),
                                            child: ProfileBadgeWidget(badges: appCubit.user.introBadge),),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      '/profile_badge_screen');
                                                },
                                                child: const Text(
                                                  "編集",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 193, 192, 201)),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ))))
                  ]);
            }, childCount: 1)),
          ],
        ));
    });
  }
}
