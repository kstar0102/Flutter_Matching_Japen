import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/board_res_detail/board_detail_item.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoardDetailRepository {
  BoardDetailRepository({required this.authRepo});

  final AuthRepository authRepo;
  BoardDetailItemList _boarddetailitems = [];
  Future<BoardDetailItemList> doFetchResData(String datavalue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data = await DioClient.doFetchDetailData(datavalue);

    final result = data['result'];

    if (result is List) {
      _boarddetailitems = result.map((data) => BoardDetailItem.fromMap(data)).toList();
      print('doFetchResData() src=${_boarddetailitems.toString()}');

      return _boarddetailitems;
    } else {
      return _boarddetailitems;
    }
  }
}

final BoardProvider = Provider<BoardDetailRepository>((ref) {
  return BoardDetailRepository(authRepo: ref.watch(authRepositoryProvider));
});
