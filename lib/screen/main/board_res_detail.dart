import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/board_res_detail/board_detail_card.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/screen/main/layouts/board_card.dart';
import 'package:matching_app/screen/main/layouts/board_message_modal.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/board_res_detail/board_detail_controller.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:matching_app/board_res_detail/board_detail_item.dart';
import 'dart:core';
import 'package:matching_app/utile/index.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:matching_app/bloc/cubit.dart';
// import 'package:matching_app/screen/main/layouts/unidentified_modal.dart';
import 'package:matching_app/screen/verify_screen/identity_verify.dart';
import 'package:matching_app/components/Header.dart';

// ignore: use_key_in_widget_constructors
class BoardResDetail extends ConsumerStatefulWidget {
  const BoardResDetail({Key? key, required this.data}) : super(key: key);
  final String data;
  @override
  ConsumerState<BoardResDetail> createState() => _BoardResDetailState();
}

class _BoardResDetailState extends ConsumerState<BoardResDetail> {
  final int _currentIndex = 4;
  String dataValue = "";
  @override
  void initState() {
    super.initState();
    getData();
  }

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );

  void getData() async {
    dataValue = widget.data; 
    ref.read(boardProvider.notifier).doFetchResData(dataValue);
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    ref.listen<AsyncValue>(boardProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(boardProvider);
    final detail_data = state.value;
     
      return Scaffold(
         body: RefreshIndicator(
            onRefresh: () async {
              getData();
            },
          backgroundColor: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: vww(context, 2)),
                          child: HeaderWidget(title: "おさそいをしてくれた人"),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: vhh(context, 2), horizontal: vww(context, 6)),
                       
                           child:Container(
                             
                            height: 500, 
                            child: RefreshIndicator(
                              onRefresh: () async {
                                getData();
                              },
                            child: detail_data != null && detail_data.isNotEmpty
                              ? GroupedListView(
                                  order: GroupedListOrder.DESC,
                                  elements: detail_data,
                                  groupBy: (board) => board.res_id,
                                  groupSeparatorBuilder: (value) {
                                    return SizedBox();
                                  },
                                  itemBuilder: (context, element) {
                                    return InkWell(
                                      child: BoardDetailCard(
                                        info: element,
                                        onPressed: () {},
                                      ),
                                    );
                                  },
                                )
                              : Text(
                                  "",
                              ),
                        ),
                      ),
                      )
                    ]);
              }, childCount: 1)),
            ],
                   ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex));
  }
}
