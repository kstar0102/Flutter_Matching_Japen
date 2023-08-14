import 'package:intl/intl.dart';

import 'package:matching_app/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class FollowingItem {
  const FollowingItem({
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
    required this.private_age,
    required this.private_matching,
    required this.matching_check,
    required this.pay_user,
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
  static int totalCount = 0;
  final String private_age;
  final String private_matching;
  final String matching_check;
  final String pay_user;
  factory FollowingItem.fromMap(Map<String, dynamic> data) {
    FollowingItem._incrementCount();
    return FollowingItem(
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
      private_age: data['private_age'].toString(),
      private_matching: data['private_matching'].toString(),
      matching_check: data['matching_check'].toString(),
      pay_user: data['pay_user'].toString(),
    );
  }
  static int _dataCount = 0;

  // Getter for accessing the count
  static int get dataCount => _dataCount;

  // Method to increment the count
  static void _incrementCount() {
    _dataCount++;
  }
  @override
  String toString() => 'PeopleItem(user_id: $user_id, user_nickname: $user_nickname, '
      'photo1: $photo1, badge_name: $badge_name, age: $age, residence: $residence, identity_state: $identity_state, badge_color: $badge_color, height: $height, body_name: $body_name, holiday: $holiday, use_purpose: $use_purpose, cigarette: $cigarette, alcohol: $alcohol, private_age: $private_age, private_matching: $private_matching, matching_check: $matching_check, pay_user: $pay_user)';
}

typedef FollowingItemList = List<FollowingItem>;
