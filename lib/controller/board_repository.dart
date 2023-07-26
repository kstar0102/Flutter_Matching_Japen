import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/screen/main/setting/board_list.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardRepository {
  BoardRepository({required this.authRepo});

  final AuthRepository authRepo;
  BoardList _boards = []; //InMemoryStore<NotifList>([]);
  Future<BoardList> doFetchNotifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    dynamic data = await DioClient.getBoardData(user_id!);

    final result = data['result'];

    if (result is List) {
      _boards = result.map((data) => Board.fromMap(data)).toList();
      print('doFetchNotifs() src=${_boards.toString()}');

      return _boards;
    } else {
      return _boards;
    }
  }
}

final BoardProvider = Provider<BoardRepository>((ref) {
  return BoardRepository(authRepo: ref.watch(authRepositoryProvider));
});
