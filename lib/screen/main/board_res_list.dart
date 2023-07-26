import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/screen/main/layouts/board_res_card.dart';
import 'package:matching_app/screen/main/layouts/board_message_modal.dart';
import 'package:matching_app/screen/main/layouts/bottom_nav_bar.dart';
import 'package:matching_app/screen/main/layouts/date_select_widget.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/board_res_list/board_res_controller.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:matching_app/screen/main/setting/board_res_item.dart';
import 'dart:core';
import 'package:matching_app/utile/index.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:matching_app/bloc/cubit.dart';
// import 'package:matching_app/screen/main/layouts/unidentified_modal.dart';
import 'package:matching_app/screen/verify_screen/identity_verify.dart';
import 'package:matching_app/components/Header.dart';

// ignore: use_key_in_widget_constructors
class BoardResList extends ConsumerStatefulWidget {

  const BoardResList({Key? key}) : super(key: key);

  @override
  ConsumerState<BoardResList> createState() => _BoardResListState();
}

class _BoardResListState extends ConsumerState<BoardResList> {
  final int _currentIndex = 4;
  @override
  void initState() {
    super.initState();
    getData();
  }

  final RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );

  void getData() async {
    // BlocProvider.of<AppCubit>(context).fetchProfileInfo();
    ref.read(boardProvider.notifier).doFetchResData();
  }


  @override
  Widget build(BuildContext context) {
    
    AppCubit appCubit = AppCubit.get(context);
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();

    ref.listen<AsyncValue>(boardProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(boardProvider);
    final boarditems = state.value;

    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
     
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
                          child: HeaderWidget(title: "募集したボード"),
                        ),
                          Container(
                            height: 600, 
                            child: RefreshIndicator(
                              onRefresh: () async {
                                getData();
                              },
                            child: boarditems != null && boarditems.isNotEmpty
                              ? GroupedListView(
                                  order: GroupedListOrder.DESC,
                                  elements: boarditems,
                                  groupBy: (board) => board.article_id,
                                  groupSeparatorBuilder: (value) {
                                    return SizedBox();
                                  },
                                  itemBuilder: (context, element) {
                                    return InkWell(
                                      child: BoardResCard(
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
                    ]);
              }, childCount: 1)),
            ],
          ),
      ),
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex));
   });
  }
}
