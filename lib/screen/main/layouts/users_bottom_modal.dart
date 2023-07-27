import 'package:flutter/material.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:matching_app/components/user_info_items.dart';
import 'package:matching_app/screen/main/community_screen.dart';
import 'package:matching_app/screen/main/layouts/user_filter_by_address.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/communcation/category_people/people_controller.dart';
import 'package:matching_app/communcation/category_people/people_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:matching_app/bloc/cubit.dart';
class UsersBottomModal extends ConsumerStatefulWidget {
  final String sub_id;

  const UsersBottomModal({super.key, required this.sub_id});

  @override
  ConsumerState<UsersBottomModal> createState() => _UsersBottomModalState();
}

class _UsersBottomModalState extends ConsumerState<UsersBottomModal> {
  String message = "";
  List<UsersObject> items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    ref.read(peopleProvider.notifier).doGetPeopleData(widget.sub_id);
  }

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(peopleProvider.select((state) => state),
    (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(peopleProvider);
    final peoples = state.value;
    AppCubit appCubit = AppCubit.get(context);
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: vww(context, 3), vertical: vhh(context, 3)),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return Column(
                    children: [
                      Center(
                          child: Container(
                        width: vw(context, 10),
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: PRIMARY_FONT_COLOR),
                      )),
                      SizedBox(
                          width: vw(context, 100),
                          height: vhh(context, 10),
                          child: Column(children: [
                            Expanded(child: Container()),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                     Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context) => CommunityScreen()));
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      iconColor: PRIMARY_FONT_COLOR),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 28,
                                  ),
                                ),
                                Expanded(child: Container()),
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      children: [
                                        Text("参加中の人",
                                            style: TextStyle(
                                                color: PRIMARY_FONT_COLOR,
                                                fontSize: 14)),
                                        Text("ゴルフ",
                                            style: TextStyle(
                                                color: PRIMARY_FONT_COLOR,
                                                fontSize: 9))
                                      ],
                                    )),
                                Expanded(child: Container()),
                                const SizedBox(
                                  width: 70,
                                )
                              ],
                            ),
                          ])),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: vhh(context, 0),
                              horizontal: vww(context, 1),
                            ),
                            child: Container(
                              height: 620,
                              child: peoples != null && peoples.isNotEmpty
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Wrap(
                                        spacing: 5,
                                        runSpacing: 10,
                                        children: peoples.where((PeopleItem person) {
                                          int? age = int.tryParse(person.age);
                                          String heightString = person.height;
                                          double heightDouble = double.parse(heightString);
                                          int height = heightDouble.toInt();
                                          int? startAge = int.tryParse(appCubit.s_age_start);
                                          int? endAge = int.tryParse(appCubit.s_age_end);
                                          int? startHeight = int.tryParse(appCubit.s_height_start);
                                          int? endHeight = int.tryParse(appCubit.s_height_end);

                                          String? bodyType = person.body_name;
                                          String? bodyNames = appCubit.s_body;
                                          List<String> bodyList = bodyNames!.split(',').map((name) => name.trim()).toList();
                                          bool bodyTypeMatches = bodyNames == "" || bodyNames.isEmpty || bodyList.any((name) => bodyType.contains(name));

                                          String? HolidayType = person.holiday;
                                          String? HolidayName = appCubit.s_holiday;
                                          List<String> HolidayList = HolidayName!.split(',').map((name) => name.trim()).toList();
                                          bool HolidayTypeMatches = HolidayName == "" || HolidayName.isEmpty || HolidayList.any((name) => HolidayType.contains(name));

                                          String? PurposeType = person.use_purpose;
                                          String? PurposeName = appCubit.s_purpose;
                                          List<String> PurposeList = PurposeName!.split(',').map((name) => name.trim()).toList();
                                          bool PurposeTypeMatches = PurposeType == "" || PurposeName.isEmpty || PurposeList.any((name) => PurposeType.contains(name));

                                          String? CigaType = person.cigarette;
                                          String? CigaName = appCubit.s_ciga;
                                          List<String> CigaList = CigaName!.split(',').map((name) => name.trim()).toList();
                                          bool CigaTypeMatches = CigaType == "" || CigaName.isEmpty || CigaList.any((name) => CigaType.contains(name));

                                          String? SakeType = person.alcohol;
                                          String? SakeName = appCubit.s_sake;
                                          List<String> sakeList = SakeName!.split(',').map((name) => name.trim()).toList();
                                          bool SakeTypeMatches = SakeType == "" || SakeName.isEmpty || sakeList.any((name) => SakeType.contains(name));

                                          String? LiveType = person.residence;
                                          String? LiveName = appCubit.s_live;
                                          List<String> liveNames = LiveName!.split(',').map((name) => name.trim()).toList();
                                          bool liveTypeMatches = LiveType == "" || liveNames.isEmpty || liveNames.any((name) => LiveType.contains(name));

                                          String? dbChecked = person.identity_state;
                                          String? verifyChecked = appCubit.s_checked == ""?"":appCubit.s_checked;
                                          bool verifyTypeMatches = dbChecked == "" || verifyChecked == "" || dbChecked.contains(verifyChecked);
                                          return age != null &&
                                              height != null &&
                                              (startAge == null || endAge == null || age >= startAge && age <= endAge) &&
                                              (startHeight == null || endHeight == null || height >= startHeight && height <= endHeight) &&
                                              bodyTypeMatches && HolidayTypeMatches && PurposeTypeMatches && CigaTypeMatches && SakeTypeMatches && verifyTypeMatches && liveTypeMatches;
                                        }).map<Widget>((childItem) => PeopleCard(
                                            info: childItem,
                                            onPressed: () {},
                                        )).toList(),
                                      ),
                                    )
                                  : Text("No data"),
                            ),
                          ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  );
                },
              ))
            ],
          ),
        ),
        floatingActionButton: Container(
            padding: EdgeInsets.only(left: vww(context, 10)),
            alignment: Alignment.bottomCenter,
            width: vww(context, 100),
            child: SizedBox(
              width: 200,
              child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        builder: (context) {
                          return UserFilterByAddress(info: widget.sub_id);
                        });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(BUTTON_MAIN)),
                  child: const Text(
                    "検索条件",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            )));
  }
}
