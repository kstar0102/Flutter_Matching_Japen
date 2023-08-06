import 'package:intl/intl.dart';

import 'package:matching_app/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class PeopleItem {
  const PeopleItem({
    required this.user_id,
    required this.user_nickname,
    required this.photo1,
    required this.badge_name,
    required this.badge_color,
    required this.age,
    required this.residence,
    required this.identity_state,
    required this.height,
    required this.body_name,
    required this.holiday,
    required this.use_purpose,
    required this.cigarette,
    required this.alcohol,
    required this.phone_number,
    required this.phone_token,
    required this.created_at,
    required this.status,
    required this.online_status,
    required this.last_msg,
    required this.last_time,
    required this.is_read,
    required this.unread_message,
  });

  final String user_id;
  final String user_nickname;
  final String photo1;
  final String badge_name;
  final String age;
  final String residence;
  final String identity_state;
  final String badge_color;
  final String height;
  final String body_name;
  final String holiday;
  final String use_purpose;
  final String cigarette;
  final String alcohol;
  final String phone_number;
  final String phone_token;
  final String status;
  final String created_at;
  final String online_status;
  final String last_msg;
  final String last_time;
  final String is_read;
  final String unread_message;

  factory PeopleItem.fromMap(Map<String, dynamic> data) {
    return PeopleItem(
      user_id: data['user_id'].toString(),
      user_nickname: data['user_nickname'].toString(),
      photo1: data['photo1'].toString(),
      badge_name: data['badge_name'].toString(),
      age: data['age'].toString(),
      residence: data['residence'].toString(),
      identity_state: data['identity_state'].toString(),
      badge_color: data['badge_color'].toString(),
      height: data['height'].toString(),
      body_name: data['body_name'].toString(),
      holiday: data['holiday'].toString(),
      use_purpose: data['use_purpose'].toString(),
      cigarette: data['cigarette'].toString(),
      alcohol: data['alcohol'].toString(),
      phone_number: data['phone_number'].toString(),
      phone_token: data['phone_token'].toString(),
      created_at: data['created_at'].toString(),
      status: data['status'].toString(),
      online_status: data['online_status'].toString(),
      last_msg: data['last_msg'].toString() ?? "",
      last_time: data['last_time'].toString() ?? "",
      is_read: data['is_read'].toString() ?? "",
      unread_message: data['unread_message'].toString() ?? "",
    );
  }

  @override
  String toString() => 'PeopleItem(user_id: $user_id, user_nickname: $user_nickname, '
      'photo1: $photo1, badge_name: $badge_name, age: $age, residence: $residence, identity_state: $identity_state, badge_color: $badge_color, height: $height, body_name: $body_name, holiday: $holiday, use_purpose: $use_purpose, cigarette: $cigarette, alcohol: $alcohol, phone_number: $phone_number, phone_token: $phone_token, is_read: $is_read, unread_message: $unread_message)';
}

typedef PeopleItemList = List<PeopleItem>;
