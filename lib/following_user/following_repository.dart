import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/following_user/following_item.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowingRepository {
  FollowingRepository({required this.authRepo});

  final AuthRepository authRepo;
  FollowingItemList _peopleitems = [];

  Future<FollowingItemList> doGetLikeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    dynamic data = await DioClient.doGetLikeData(user_id!);

    final result = data['result'];

    if (result is List) {
      _peopleitems = result.map((data) => FollowingItem.fromMap(data)).toList();
      print('doFetchResData() src=${_peopleitems.toString()}');

      return _peopleitems;
    } else {
      return _peopleitems;
    }
  }
}

final FollowingProvider = Provider<FollowingRepository>((ref) {
  return FollowingRepository(authRepo: ref.watch(authRepositoryProvider));
});
