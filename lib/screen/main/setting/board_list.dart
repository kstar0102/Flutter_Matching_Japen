import 'package:intl/intl.dart';

import 'package:matching_app/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class Board {
  const Board({
    required this.id,
    required this.user_id,
    required this.created_date,
    required this.board_content,
    required this.user_nickname,
    required this.birthday,
    required this.photo1,
    required this.residence,
    required this.age,
  });

  final String id;
  final String user_id;
  final String created_date;
  final String board_content;
  final String user_nickname;
  final String birthday;
  final String photo1;
  final String residence;
  final String age;

  factory Board.fromMap(Map<String, dynamic> data) {
    return Board(
      id: data['id'].toString(),
      user_id: data['user_id'].toString(),
      created_date: data['created_date'].toString(),
      board_content: data['board_content'].toString(),
      user_nickname: data['user_nickname'].toString(),
      birthday: data['birthday'].toString(),
      photo1: data['photo1'].toString(),
      residence: data['residence'].toString(),
      age: data['age'].toString(),
    );
  }

  @override
  String toString() => 'Board(id: $id, user_id: $user_id, '
      'created_date: $created_date, board_content: $board_content, user_nickname: $user_nickname, '
      'birthday: $birthday, photo1: $photo1, residence: $residence, age: $age)';
}

typedef BoardList = List<Board>;
