import 'package:intl/intl.dart';

import 'package:matching_app/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class BoardItem {
  const BoardItem({
    required this.article_id,
    required this.article_count,
    required this.board_content,
    required this.created_date,
    required this.user_id,
  });

  final String article_id;
  final String article_count;
  final String board_content;
  final String created_date;
  final String user_id;

  factory BoardItem.fromMap(Map<String, dynamic> data) {
    return BoardItem(
      article_id: data['article_id'].toString(),
      article_count: data['article_count'].toString(),
      board_content: data['board_content'].toString(),
      created_date: data['created_date'].toString(),
      user_id: data['user_id'].toString(),
    );
  }

  @override
  String toString() => 'BoardItem(article_id: $article_id, article_count: $article_count, '
      'board_content: $board_content, created_date: $created_date, user_id: $user_id)';
}

typedef BoardItemList = List<BoardItem>;
