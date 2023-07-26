import 'dart:developer' as developer;

class ProfileInfo {
  ProfileInfo({
    required this.id,
    required this.user_name,
    required this.user_nickname,
    required this.address,
    required this.birthday,
    required this.community,
    required this.height,
    required this.body_type,
    required this.use_purpose,
    required this.intro_badge,
    required this.introduce,
    required this.plan_type,
    required this.likes_rate,
    required this.coin,
    required this.identity_state,
    required this.remember_token,
    required this.blood_type,
    required this.education,
    required this.holiday,
    required this.cigarette,
    required this.alcohol,
    required this.annual_income,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.photo5,
    required this.photo6,
  });

  final String id;
  final String? user_name;
  final String? user_nickname;
  final String? address;
  final String? birthday;
  final String? community;
  final String? height;
  final String? body_type;
  final String? use_purpose;
  final String? intro_badge;
  final String introduce;
  final String? plan_type;
  final String? likes_rate;
  final String? coin;
  final String? identity_state;
  final String? remember_token;
  final String? blood_type;
  final String? education;
  final String? holiday;
  final String? cigarette;
  final String? alcohol;
  final String? annual_income;
  final String? photo1;
  final String? photo2;
  final String? photo3;
  final String? photo4;
  final String? photo5;
  final String? photo6;

  factory ProfileInfo.fromMap(Map<String, dynamic> data) {
    final result = data['result'];
    print(result);
    return ProfileInfo(
      id: result['id'].toString()??"",
      user_name: result['user_name'].toString()??"asd",
      user_nickname: result['user_nickname'].toString()??"",
      address: result['address'].toString()??"",
      birthday: result['birthday'].toString()??"",
      community: result['community'].toString()??"",
      height: result['height'].toString()??"",
      body_type: result['body_type'].toString()??"",
      use_purpose: result['use_purpose'].toString()??"",
      intro_badge: result['intro_badge'].toString()??"",
      introduce: result['introduce'].toString()??"",
      plan_type: result['plan_type'].toString()??"",
      likes_rate: result['likes_rate'].toString()??"",
      coin: result['coin'].toString()??"",
      identity_state: result['identity_state'].toString()??"",
      remember_token: result['remember_token'].toString()??"",
      blood_type: result['blood_type'].toString()??"",
      education: result['education'].toString()??"",
      holiday: result['holiday'].toString()??"",
      cigarette: result['cigarette'].toString()??"",
      alcohol: result['alcohol'].toString()??"",
      annual_income: result['annual_income'].toString()??"",
      photo1: result['photo1'].toString()??"",
      photo2: result['photo2'].toString()??"",
      photo3: result['photo3'].toString()??"",
      photo4: result['photo4'].toString()??"",
      photo5: result['photo5'].toString()??"",
      photo6: result['photo6'].toString()??"",
    );
  }
  @override
  String toString() =>
      'ProfileInfo(id: $id, user_name: $user_name, user_nickname: $user_nickname, address: $address, birthday: $birthday,  community: $community, height: $height, body_type: $body_type, use_purpose: $use_purpose, intro_badge: $intro_badge, introduce: $introduce, plan_type: $plan_type, likes_rate: $likes_rate, coin: $coin, identity_state: $identity_state, remember_token: $remember_token,blood_type: $blood_type, education: $education, holiday: $holiday, cigarette: $cigarette, alcohol: $alcohol,annual_income: $annual_income,photo1: $photo1, photo2: $photo2, photo3: $photo3, photo4: $photo4, photo5: $photo5,photo6: $photo6)';
}

typedef ProfileInfoList = List<ProfileInfo>;
