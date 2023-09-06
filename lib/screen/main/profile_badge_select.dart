import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/components/Header.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';

// import 'package:flutter_redux/flutter_redux.dart';
// ignore: use_key_in_widget_constructors
class ProfileBadgeSelect extends StatefulWidget {
  const ProfileBadgeSelect({super.key, required this.badges});

  final List<BadgeItemObject> badges;
  @override
  // ignore: library_private_types_in_public_api
  _ProfileBadgeSelectState createState() => _ProfileBadgeSelectState();
}

class _ProfileBadgeSelectState extends State<ProfileBadgeSelect> {
 
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            constraints: BoxConstraints(
              minHeight: vh(context, 90), // Set the minimum height here
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: getDeviceWidth(context) / 47 * 1,
                      right: getDeviceWidth(context) / 47 * 1),
                  child: const HeaderWidget(title: "プロフィール登録"),
                ),
                Container(
                  width: vww(context, 100),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: vww(context, 6)),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 218, 217, 226),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: 
                  Wrap(
                spacing: 8,
                runSpacing: -8,
                children: widget.badges.map((BadgeItemObject e) {
                  String textColor = e.color;
                  return FilterChip(
                    label: Text(e.title,
                        style: TextStyle(
                            fontSize: 13,
                            color: e.isChecked
                                ? Colors.white
                                : Colors.white)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                          color: Color(int.parse(textColor.substring(1, 7),
                                  radix: 16) +
                              0xFF000000),
                          width: 1.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: e.isChecked
                        ? Color(int.parse(textColor.substring(1, 7),
                                radix: 16) +
                            0xFF000000)
                        : Color(int.parse(textColor.substring(1, 7),
                                radix: 16) +
                            0xFF000000),
                    selectedColor: Color(
                        int.parse(textColor.substring(1, 7), radix: 16) +
                            0xFF000000),
                    onSelected: (bool value) {},
                  );
                }).toList())
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: vw(context, 3), vertical: vh(context, 5)),
                    child: Wrap(
                        spacing: 8,
                        runSpacing: -8,
                        children: List.generate(
                                            appCubit.badgeList.length,
                                            (index) {
                          if (appCubit.badgeList[index].id == -1) {
                            return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container());
                          }
                          return FilterChip(
                              label: Text(appCubit.badgeList[index].title,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: appCubit.badgeList[index].isChecked
                                          ? Colors.white
                                          : Color(int.parse(
                                                  appCubit.badgeList[index].color.substring(1, 7),
                                                  radix: 16) +
                                              0xFF000000))),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                    color: Color(int.parse(
                                            appCubit.badgeList[index].color.substring(1, 7),
                                            radix: 16) +
                                        0xFF000000),
                                    width: 1.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              backgroundColor: appCubit.badgeList[index].isChecked
                                  ? Color(int.parse(appCubit.badgeList[index].color.substring(1, 7),
                                          radix: 16) +
                                      0xFF000000)
                                  : Color(int.parse(appCubit.badgeList[index].color.substring(1, 7),
                                          radix: 16) +
                                      0x33000000),
                              selectedColor: Color(
                                  int.parse(appCubit.badgeList[index].color.substring(1, 7), radix: 16) + 0xFF000000),
                              onSelected: (isSelected) => appCubit.changeBadge(index));
                        }).toList())),
                Expanded(
                  child: Container(),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getDeviceWidth(context) / 47 * 3),
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RadiusButton(
                            id: 0,
                            color: BUTTON_MAIN,
                            text: "つぎへ",
                            goNavigation: (id) {
                              Navigator.pushNamed(context, "/profile_edit_screen");
                              
                              BlocProvider.of<AppCubit>(context).fetchProfileInfo();
                            },
                            isDisabled: appCubit.selectedBadgeList.length < 3,
                          ),
                        ))),
                Expanded(
                  child: Container(),
                )
              ],
            )));
    });
  }

  void selectBadge(e) {
    // if (!e.isChecked) {
    //   selectedList.add(e);
    //   if (selectedList.length > 5) {
    //     setState(() {
    //       badgeList
    //           .where((element) => element == selectedList.elementAt(0))
    //           .first
    //           .isChecked = false;
    //     });
    //     selectedList.removeAt(0);
    //   }
    // } else {
    //   selectedList.remove(e);
    // }
    setState(() {
      e.isChecked = !e.isChecked;
    });
  }
}
