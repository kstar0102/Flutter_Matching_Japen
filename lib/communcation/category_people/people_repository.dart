import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/communcation/category_people/people_item.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeopleRepository {
  PeopleRepository({required this.authRepo});

  final AuthRepository authRepo;
  PeopleItemList _peopleitems = [];
  Future<PeopleItemList> doGetPeopleData(String sub_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    dynamic data = await DioClient.doGetPeopleData(sub_id,user_id!);

    final result = data['result'];

    if (result is List) {
      _peopleitems = result.map((data) => PeopleItem.fromMap(data)).toList();
      print('doFetchResData() src=${_peopleitems.toString()}');

      return _peopleitems;
    } else {
      return _peopleitems;
    }
  }

  Future<PeopleItemList> doGetLikeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    dynamic data = await DioClient.doGetLikeData(user_id!);

    final result = data['result'];

    if (result is List) {
      _peopleitems = result.map((data) => PeopleItem.fromMap(data)).toList();
      print('doFetchResData() src=${_peopleitems.toString()}');

      return _peopleitems;
    } else {
      return _peopleitems;
    }
  }
}

final PeopleProvider = Provider<PeopleRepository>((ref) {
  return PeopleRepository(authRepo: ref.watch(authRepositoryProvider));
});
