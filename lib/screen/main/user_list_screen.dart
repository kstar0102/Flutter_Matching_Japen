import 'package:flutter/material.dart';
import 'package:matching_app/components/user_list_item.dart';
import 'package:matching_app/screen/main/layouts/user_list_header.dart';
import 'package:matching_app/utile/async_value_ui.dart';
import 'package:matching_app/utile/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/communcation/category_people/people_controller.dart';

import '../../bloc/cubit.dart';
// ignore: use_key_in_widget_constructors
class UserListScreen extends ConsumerStatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    ref.read(peopleProvider.notifier).doGetPreview();
  }
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
     ref.listen<AsyncValue>(peopleProvider.select((state) => state),
    (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(peopleProvider);
    final peoples = state.value;
    AppCubit appCubit = AppCubit.get(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
                delegate: UserListHeader((id){}), pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: vww(context, vww(context, 1))),
                              child: Container(
                              height: MediaQuery.of(context).size.height / 1.2,
                              child: peoples != null && peoples.isNotEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Wrap(
                                      spacing: 20,
                                      runSpacing: 20,
                                      children: peoples.map<Widget>((childItem) => UserListItem(
                                          info: childItem,
                                          onPressed: () {},
                                          isBlockedUser: false,
                                      )).toList(),
                                    ),
                                  )
                                : Center(
                                    child:Text("No Data")
                                  ),
                            ),
                          ),
                        ]);
            }, childCount: 1)),
          ],
        ));
  }
}
