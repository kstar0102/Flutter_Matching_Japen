import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/controller/profile_info.dart';
import 'package:matching_app/exceptions/app_exception.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:matching_app/utile/in_memory_store.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthRepository {
  String? _uid; // AuthRepository will not use data model.
  String? get uid => _uid;

  set setUid(String str) {
    this._uid = str;
  }
  ProfileInfo? get currProfile => _profileState.value;

  final _profileState = InMemoryStore<ProfileInfo?>(null);
  Stream<ProfileInfo?> profileStateChanges() => _profileState.stream;
  Future<bool> doIntroduce(String uID, String introText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final data = await DioClient.postIntroduce(uID, introText);
    developer.log('doIntroduce() returned: $data');
    var result = data['result'];
    if (result == 'true') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'false') {
      showToastMessage("No Internet");
      return false;
    }
    return false;
  }

  Future<bool> doNickname(String _uID, String nick_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final data = await DioClient.postNickname(_uID, nick_name);
    developer.log('postNickname() returned: $data');
    var result = data['result'];
    if (result == 'true') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'false') {
      showToastMessage("No Internet");
      return false;
    }
    return false;
  }

  Future<bool> doPhoneVaild(String phone_number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final data = await DioClient.postPhoneNumber(phone_number);
    developer.log('postPhoneNumber() returned: $data');
    var result = data['result'];
    if (result == 'Connected') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'Wrong') {
      showToastMessage("Wrong");
      return false;
    }  else if (result == 'No data') {
      showToastMessage("No data");
      return false;
    }
    return false;
  }

  Future<bool> doBoardReply(String userId, String Id, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? res_id = prefs.getString('UserId');
    final data = await DioClient.postBoardReply(userId,Id,message,res_id!);
    var result = data['result'];
    if (result == 'success') {
      Fluttertoast.showToast(
          msg: "正確に送信されました。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
      );
      return true;
    } else if(result == 'error'){
      Fluttertoast.showToast(
          msg: "認証を確認してください。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
      );
    } 
      return false;
  }

  Future<bool> addBoardData(String selectedItems, String board_text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    final data = await DioClient.addBoardData(user_id!, selectedItems, board_text);
    developer.log('addBoardData() returned: $data');
    var result = data['result'];
    if (result == 'success') {
      Fluttertoast.showToast(
          msg: "正確に送信されました。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
      );
      return true;
    } else if(result == "error"){
       Fluttertoast.showToast(
          msg: "認証を確認してください。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
      );
      return false;
    } 
    return false;

  }

  Future<bool> doDetailData(String res_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    final data = await DioClient.doDetailData(res_id);
    developer.log('doDetailData() returned: $data');
    var result = data['result'];
    if (result == 'success') {
       Fluttertoast.showToast(
          msg: "操作が成功しました",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
      );
      return true;
    } else if (result == 'error') {
       Fluttertoast.showToast(
          msg: "操作が失敗しました。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
      );
      return false;
    } 
    return false;
  }

  Future<bool> doPeopleRecom(String receiver_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    final data = await DioClient.doPeopleRecom(user_id!, receiver_id);
    developer.log('doDetailData() returned: $data');
    var result = data['result'];
    if (result == 'success') {
      Fluttertoast.showToast(
          msg: "成功しました。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
      );
      return true;
    } else if(result == "error") {
       Fluttertoast.showToast(
          msg: "「いいね」 おすすめ数が足りません。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
      );

      return false;
    } 
    return false;
  }

  Future<bool> doChatting(String receiver_id, String sender_id, String msg, String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await DioClient.doChatting(sender_id, receiver_id, msg, time);
    developer.log('doDetailData() returned: $data');
    var result = data['result'];
    if (result == 'success') {
      return true;
    } else if(result == "error") {
      return false;
    } 
    return false;
  }
  
  Future<bool> doMessage(String receiver_id, String sender_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await DioClient.doMessage(sender_id, receiver_id);
    developer.log('doDetailData() returned: $data');
    var result = data['result'];
    if (result == 'success') {
      return true;
    } else if(result == "error") {
      return false;
    } 
    return false;
  }

  Future<ProfileInfo?> doGetIntro(String uid) async {
    final data = await DioClient.GetIntro(uid);
    // print(data);
    try {
      ProfileInfo profileData = ProfileInfo.fromMap(data);
      developer.log('doGetProfile222() returned: $profileData');
    } catch (e) {
      developer.log('doGetProfile222() error=$e');
    }
    try {
      _profileState.value = ProfileInfo.fromMap(data);
    } catch (e) {
      developer.log('doGetProfile() error=$e');
    }

    return _profileState.value;
  }

  Future<bool> doLogout() async {
     SharedPreferences preferences =
        await SharedPreferences.getInstance();
    preferences.setString('UserId', '0');
    preferences.setString('login_id', 'not');
    preferences.setBool('isLogin', false);
    preferences.setString('VerifyPhoneNumber', '0');

    return true;
  }

}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
