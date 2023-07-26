import 'package:intl/intl.dart';

import 'package:matching_app/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class BoardDetailItem {
  const BoardDetailItem({
    required this.res_id,
    required this.board_id,
    required this.res_board_content,
    required this.active_user_id,
    required this.created_date,
    required this.status,
    required this.user_nickname,
    required this.residence,
    required this.age,
    required this.photo1,

  });

  final String res_id;
  final String board_id;
  final String res_board_content;
  final String active_user_id;
  final String created_date;
  final String status;
  final String user_nickname;
  final String residence;
  final String age;
  final String photo1;

  factory BoardDetailItem.fromMap(Map<String, dynamic> data) {
    return BoardDetailItem(
      res_id: data['res_id'].toString(),
      board_id: data['board_id'].toString(),
      res_board_content: data['res_board_content'].toString(),
      active_user_id: data['active_user_id'].toString(),
      created_date: data['created_date'].toString(),
      status: data['status'].toString(),
      user_nickname: data['user_nickname'].toString(),
      residence: data['residence'].toString(),
      age: data['age'].toString(),
      photo1: data['photo1'].toString(),
    );
  }

  @override
  String toString() => 'BoardDetailItem(res_id: $res_id, board_id: $board_id, '
      'res_board_content: $res_board_content, active_user_id: $active_user_id, created_date: $created_date, status: $status, '
      'user_nickname: $user_nickname, residence: $residence,age: $age, photo1: $photo1)';
}

typedef BoardDetailItemList = List<BoardDetailItem>;
