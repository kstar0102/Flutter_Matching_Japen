import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/user_filter_by_info.dart';
import 'package:matching_app/utile/index.dart';

class UserFilterByAddress extends StatefulWidget {
  final String info;

  const UserFilterByAddress({super.key, required this.info});

  @override
  // ignore: library_private_types_in_public_api
  _UserFilterByAddressState createState() => _UserFilterByAddressState();
}

class _UserFilterByAddressState extends State<UserFilterByAddress> {
  List<AddressObject> selectedList = [];
  List<dynamic> selectedidx = [];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context).fetchAddressList();
  }

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  @override
  Widget build(BuildContext context) {

    AppCubit appCubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
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
                      SizedBox(
                          width: vw(context, 100),
                          height: vhh(context, 10),
                          child: Column(children: [
                            Expanded(child: Container()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    width: 100,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          iconColor: PRIMARY_FONT_COLOR),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 28,
                                      ),
                                    )),
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      children: [
                                        Text("検索条件",
                                            style: TextStyle(
                                                color: PRIMARY_FONT_COLOR,
                                                fontSize: 14))
                                      ],
                                    )),
                                const SizedBox(
                                  width: 100,
                                  child: Text("条件をリセット",
                                      style: TextStyle(
                                          fontSize: 14, color: BUTTON_MAIN)),
                                )
                              ],
                            ),
                          ])),
                      Wrap(
                          spacing: 4,
                          runSpacing: -8,
                          children: appCubit.addressList.map((AddressObject e) {
                            return FilterChip(
                                label: Text(e.address,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: e.isChecked
                                            ? Colors.white
                                            : BUTTON_MAIN)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(
                                      color: BUTTON_MAIN, width: 1.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                backgroundColor:
                                    e.isChecked ? BUTTON_MAIN : Colors.white,
                                selectedColor: BUTTON_MAIN,
                               onSelected: (isSelected) => setState(() {
                                e.isChecked = !e.isChecked;
                                if (e.isChecked) {
                                  selectedidx.add(e.address);
                                } else {
                                  selectedidx.remove(e.address);
                                }
                                print(selectedidx);
                              }));
                          }).toList()),
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
                          return UserFilterByInfo(info_id: widget.info, live_info: selectedidx.toString());
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
                    "検索",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            )));
    });
  }
}
