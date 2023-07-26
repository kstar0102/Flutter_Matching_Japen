import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/screen/main/setting/board_res_item.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoardRepository {
  BoardRepository({required this.authRepo});

  final AuthRepository authRepo;
  BoardItemList _boarditems = [];
  Future<BoardItemList> doFetchResData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    dynamic data = await DioClient.doFetchResData(user_id!);

    final result = data['result'];

    if (result is List) {
      _boarditems = result.map((data) => BoardItem.fromMap(data)).toList();
      print('doFetchResData() src=${_boarditems.toString()}');

      return _boarditems;
    } else {
      return _boarditems;
    }
  }
}

final BoardProvider = Provider<BoardRepository>((ref) {
  return BoardRepository(authRepo: ref.watch(authRepositoryProvider));
});
