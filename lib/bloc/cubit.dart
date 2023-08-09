import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/bloc/model/user.dart';
import 'package:matching_app/common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'state.dart';

class AppCubit extends Cubit<AppState> {
  // !--------> register start
  int userId = 0;
  String nickName = "";
  String userName = "";
  bool isValidNickName = false;
  String bDay = "";
  List<AddressObject> addressList = <AddressObject>[];
  List<CommunityObject> communityList = <CommunityObject>[];
  double height = 130;
  List<BodyTypeObject> bodyTypeList = <BodyTypeObject>[];
  List<BodyTypeObject> bloodTypeList = <BodyTypeObject>[];
  int bodyType = -1;
  List<PurposeTypeObject> purposeList = <PurposeTypeObject>[];
  int purpose = -1;
  List<BadgeItemObject> badgeList = <BadgeItemObject>[];
  List<BadgeItemObject> selectedBadgeList = [];
  List<String> avatarImages = ["", "", "", "", "", ""];
  //my register part
  String avatarImage = "";
  String avatarImage1 = "";
  String avatarImage2 = "";
  String avatarImage3 = "";
  String avatarImage4 = "";
  String avatarImage5 = "";
  String address_info = "";
  String address_id = "";
  String tall_height = "";
  String body_type = "";
  String blood_type = "";
  String edu_type = "";
  String purpose_type = "";
  String annual_budget = "";
  String holi_info = "";
  String ciga_info = "";
  String alcohol_info = "";
  String intro_text = "";
  String change_nickname = "";
  String body_id = "";
  String UserId = "";
  int? r_count = 0;
  String s_age_start= "";
  String s_age_end= "";
  String s_height_start = "";
  String s_height_end = "";
  String s_body = "";
  String s_holiday = "";
  String s_purpose = "";
  String s_ciga = "";
  String s_sake = "";
  String s_live = "";
  String s_checked = "";
  String phone = "";
  String phone_token = "";
  String receiver_id = "";
  //end
  AppCubit() : super(AppInitial());

  void changeNickName(String value) {
    nickName = value;
    emit(AppRegister());
  }

  void formatButton() async
  {
    s_age_start= "";
    s_age_end= "";
    s_height_start = "";
    s_height_end = "";
    s_body = "";
    s_holiday = "";
    s_purpose = "";
    s_ciga = "";
    s_sake = "";
    s_live = "";
    s_checked = "";
    emit(AppMain());
  }

  Future<void> validationNickName(String value) async {
    try {
      final response = await http
          .get(Uri.parse('${API_URL}nickname_validation?nickname=$value'));
      // print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData['result']);
        isValidNickName = jsonData['result'];
      } else {
        Fluttertoast.showToast(
          msg: "ユーザーIDが重複しています。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
        isValidNickName = false;
      }
    } catch (e) {
      print("Error---------->${e}");
      isValidNickName = false;
    }
    emit(AppRegister());
  }

  void phoneToken(String phone_number, String token) {
    phone = phone_number;
    phone_token = token;
    print(phone + phone_token);
    emit(AppRegister());
  }


  void changeBDay(String value) {
    bDay = value;
    emit(AppRegister());
  }

  void changeHeight(double value) {
    height = value;
    emit(AppRegister());
  }

  Future<void> fetchAddressList() async {
    try {
      final response = await http.get(Uri.parse('${API_URL}get_residence'));
      // print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonAddressList = jsonDecode(response.body);
        addressList.clear();
        for (var i = 0; i < jsonAddressList['data'].length; i++) {
          addressList.add(AddressObject(jsonAddressList['data'][i]['id'],
              jsonAddressList['data'][i]['residence'], false));
        }
        emit(AppRegister());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }

  Future<void> fetchCommunityList() async {
    try {
      final response = await http.get(Uri.parse('${API_URL}get_community'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonAddressList = jsonDecode(response.body);
        communityList.clear();
        for (var i = 0; i < jsonAddressList['data'].length; i++) {
          communityList.add(CommunityObject(
              jsonAddressList['data'][i]['idx'],
              jsonAddressList['data'][i]['label'],
              false,
              jsonAddressList['data'][i]['category'],
              jsonAddressList['data'][i]['parent'],
              "$BASE_URL/uploads/${jsonAddressList['data'][i]['image']}"));
        }
        emit(AppRegister());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }

  Future<void> fetchBodyTypeList() async {
    try {
      final response = await http.get(Uri.parse('${API_URL}get_bodytype'));
      if (response.statusCode == 200) {
        bodyTypeList.clear();
        Map<String, dynamic> list = jsonDecode(response.body);
        for (var i = 0; i < list['data'].length; i++) {
          bodyTypeList.add(BodyTypeObject(
              list['data'][i]['id'], list['data'][i]['type_name'], false));
        }
        emit(AppRegister());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }

  void changeBodyType(int idx) {
    bodyType = idx;
    emit(AppRegister());
  }

  Future<void> fetchPurposeList() async {
    try {
      final response = await http.get(Uri.parse('${API_URL}get_usepurpose'));
      if (response.statusCode == 200) {
        purposeList.clear();
        Map<String, dynamic> list = jsonDecode(response.body);
        for (var i = 0; i < list['data'].length; i++) {
          purposeList.add(PurposeTypeObject(
              list['data'][i]['id'], list['data'][i]['use_purpose'],false));
        }
        emit(AppRegister());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }

  void changePurpose(int idx) {
    purpose = idx;
    emit(AppRegister());
  }

  Future<void> fetchBadgeList() async {
    try {
      final response = await http.get(Uri.parse('${API_URL}get_introbadge'));
      if (response.statusCode == 200) {
        selectedBadgeList.clear();
        badgeList.clear();
        Map<String, dynamic> list = jsonDecode(response.body);
        for (var i = 0; i < list['data'].length; i++) {
          if (i != 0 &&
              list['data'][i - 1]['tag_color'] !=
                  list['data'][i]['tag_color']) {
            badgeList.add(BadgeItemObject(-1, list['data'][i]['tag_text'],
                false, list['data'][i]['tag_color']));
          }
          badgeList.add(BadgeItemObject(
              list['data'][i]['id'],
              list['data'][i]['tag_text'],
              false,
              list['data'][i]['tag_color']));
        }
        emit(AppRegister());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }

  void changeBadge(int idx) {
    if (!badgeList.elementAt(idx).isChecked) {
      selectedBadgeList.add(badgeList.elementAt(idx));
      print(selectedBadgeList.length);
      if (selectedBadgeList.length > 5) {
        badgeList
            .where((element) => element.id == selectedBadgeList.elementAt(0).id)
            .first
            .isChecked = false;
        selectedBadgeList.removeAt(0);
      }
    } else {
      selectedBadgeList.remove(badgeList.elementAt(idx));
    }
    badgeList.elementAt(idx).isChecked = !badgeList.elementAt(idx).isChecked;
    uploadBadgeData();
    emit(AppRegister());
  }

  void changeAvatar(String uri) {
    avatarImage = uri;
    emit(AppRegister());
  }

  void changeMultiAvatar(String uri, int item_id) {
    avatarImages[item_id] = uri;
    uploadAvatarImage((item_id+1).toString(), uri);
    emit(AppRegister());
  }

  void changeAddress(String address, String idx) async{
    address_info = address;
    address_id = idx;
    print(UserId);
    final data = await DioClient.changeAddressData(UserId,address_id);
    emit(AppMain());
  }

   void changeBody(String body, String idx) async{
    body_type = body;
    body_id = idx;
    final data = await DioClient.changeBodyData(UserId,idx);
    emit(AppMain());
  }

  void addMatching(String receiver_token) async{
    final data = await DioClient.addMatching(receiver_token, UserId);
    print(data['result']);
    if(data['result'] == "success"){
      Fluttertoast.showToast(
        msg: "成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
  }

  void removeMatching(String receiver_token) async{
    final data = await DioClient.removeMatching(receiver_token, UserId);
    if(data['result'] == "success"){
      Fluttertoast.showToast(
        msg: "成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
  }

   void userReport(String receiver_token) async{
    final data = await DioClient.userReport(receiver_token, UserId);
    if(data['result'] == "success"){
      Fluttertoast.showToast(
        msg: "成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
    else if(data['result'] == 'error')
    {
      Fluttertoast.showToast(
        msg: "あなたはすでにこのユーザーの違反\nを報告しています。",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }


  void searchFilter(String search_age_start, String search_age_end, String search_height_start, String search_height_end, String search_body, String search_holiday, String search_purpose, String search_ciga, String search_sake, String live_place, String VerifyChecked) async{
    s_age_start = search_age_start;
    s_age_end = search_age_end;
    s_height_start = search_height_start;
    s_height_end = search_height_end;
    s_body = search_body;
    s_holiday = search_holiday;
    s_purpose = search_purpose;
    s_ciga = search_ciga;
    s_sake = search_sake;
    s_live = live_place;
    s_checked = VerifyChecked;
    emit(AppMain());
  }

  void changeTallHeight(String t_height) async
  {
    tall_height = t_height;
    UserId = userId.toString();
    final data = await DioClient.changeHeightData(UserId,tall_height);
    emit(AppMain());
  }

  void changeBlood(String blood_t) async
  {
    blood_type = blood_t;
    final data = await DioClient.changeBloodData(UserId,blood_t);
    emit(AppMain());
  }

  void changeEducation(String edu) async
  {
    edu_type = edu;
    final data = await DioClient.changeEducation(UserId,edu);
    emit(AppMain());
  }

  void changePurposeInfo(String pur_info, String idx) async
  {
    purpose_type = pur_info;
    UserId = userId.toString();
    final data = await DioClient.changePurpose(UserId,idx);
    emit(AppMain());
  }

  void postIntroduce(String intro) async
  {
    intro_text = intro;
    final data = await DioClient.postIntroduce(UserId.toString(),intro);
    emit(AppMain());
  }

  void changeNick(String nicky)
  {
    change_nickname = nicky;
    emit(AppMain());
  }

  void changeBudget(String annual) async
  {
    annual_budget = annual;
    final data = await DioClient.changeBudget(UserId,annual);
    emit(AppMain());
  }

  void changeHoliday(String holi) async
  {
    holi_info = holi;
    final data = await DioClient.changeHoliday(UserId,holi);
    emit(AppMain());
  }

  void changeCiga(String ciga) async
  {
    ciga_info = ciga;
    final data = await DioClient.changeCiga(UserId,ciga);
    emit(AppMain());
  }

  void changeAlcohol(String al_info) async
  {
    alcohol_info = al_info;
    final data = await DioClient.changeAlcohol(UserId,al_info);
    emit(AppMain());
  }

  dynamic addLikesData(String receiver_id, String send_id) async
  {
    final data = await DioClient.addLikesData(send_id, receiver_id);
    var result = data['result'];
    if(result == "success")
    {
      return true;
    }
    else if(result == "error"){
      return false;
    }
  }

  Future<int> uploadProfile() async {
    String selectedCommunityList = "";
    for (var i = 0; i < communityList.length; i++) {
      if (communityList[i].isChecked) {
        print(communityList[i].idx); 
        selectedCommunityList += "${communityList[i].idx},";
      }
    }
    String selectedBadges = "";
    for (var i = 0; i < selectedBadgeList.length; i++) {
      selectedBadges += "${selectedBadgeList[i].id},";
    }
    var request =
        http.MultipartRequest('POST', Uri.parse('${API_URL}register_action'));
    request.fields['edtNickName'] = nickName;
    String date =
        "${bDay.split('/')[0]}-${int.parse(bDay.split('/')[1]) < 10 ? "0" : ""}${bDay.split('/')[1]}-${int.parse(bDay.split('/')[2]) < 10 ? "0" : ""}${bDay.split('/')[2]}";
    request.fields['edtBirthday'] = date;
    request.fields['edtAddress'] =
        addressList.where((element) => element.isChecked).first.idx.toString();
    request.fields['edtCommunity'] = selectedCommunityList;
    request.fields['edtHeight'] = height.toString();
    request.fields['edtBodyType'] = bodyType.toString();
    request.fields['edtUsePurpose'] = purpose.toString();
    request.fields['phone_number'] = phone.toString();
    request.fields['phone_token'] = phone_token.toString();
    request.fields['edtIntroBadge'] = selectedBadges;
    var imageFile = File(avatarImage);
    var imageStream = http.ByteStream(imageFile.openRead());
    var imageLength = await imageFile.length();

    var multipartFile = http.MultipartFile('image', imageStream, imageLength,
        filename: imageFile.path);
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream
          .bytesToString(); // Convert response stream to string
      var decodedData = json.decode(responseData);
      if (decodedData["type"] == "success") {
        userId = decodedData["data"]["id"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("UserId",userId.toString());
        return 1;
      } else {
        return 0;
      }
    } else {
      print(await response.stream.bytesToString());
      return 0;
    }
  }

  

  // !--------> register end

  // !--------> identity verify start

  Future<int> uploadIdentifyImage(String file) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${API_URL}identify_verify'));
    request.fields['user_id'] = userId.toString();
    request.fields['user_name'] = "";
    request.fields['nick_name'] = nickName;
    request.fields['identity_type'] = "運転免許証";
    var imageFile = File(file);
    var imageStream = http.ByteStream(imageFile.openRead());
    var imageLength = await imageFile.length();

    var multipartFile = http.MultipartFile('image', imageStream, imageLength,
        filename: imageFile.path);
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream
          .bytesToString(); // Convert response stream to string
      var decodedData = json.decode(responseData);
      if (decodedData["type"] == "success") {
        return 1;
      } else {
        return 0;
      }
    } else {
      print(response);
      return 0;
    }
  }

  Future<int> uploadBadgeData() async {
    String selectedBadges = "";
    for (var i = 0; i < selectedBadgeList.length; i++) {
      selectedBadges += "${selectedBadgeList[i].id},";
    }
    var request =
        http.MultipartRequest('POST', Uri.parse('${API_URL}introbadge_update'));
    request.fields['id'] = UserId.toString();
    request.fields['data'] = selectedBadges;
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream
          .bytesToString(); // Convert response stream to string
      var decodedData = json.decode(responseData);
      print(decodedData['result']);
      if (decodedData["type"] == "success") {
        return 1;
      } else {
        return 0;
      }
    } else {
      print(await response.stream.bytesToString());
      return 0;
    }
  }

  Future<int> changeCoin(String price) async {
    UserId = userId.toString();
    var request =
        http.MultipartRequest('POST', Uri.parse('${API_URL}upload_likes'));
    request.fields['id'] = UserId.toString();
    request.fields['data'] = price;
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream
          .bytesToString(); // Convert response stream to string
      var decodedData = json.decode(responseData);
      print(decodedData['result']);
      if (decodedData["type"] == "success") {
        Fluttertoast.showToast(
          msg: "成功しました。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
        return 1;
      } else  {
         Fluttertoast.showToast(
          msg: "コインを埋める必要があります。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
         );
        return 0;
      }
    } else {
      print(await response.stream.bytesToString());
      return 0;
    }
  }
  // !--------> identity verify end

  // !--------> profile start

  User user = User();

  Future<int> uploadAvatarImage(String item_id, String avatar) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${API_URL}upload_avatar'));
    var imageFile = File(avatar);
    var imageStream = http.ByteStream(imageFile.openRead());
    var imageLength = await imageFile.length();
    var multipartFile = http.MultipartFile('image', imageStream, imageLength,
        filename: imageFile.path);
    request.fields['item_id'] = item_id.toString();
    request.fields['id'] = UserId.toString();
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream
          .bytesToString(); // Convert response stream to string
      var decodedData = json.decode(responseData);
      if (decodedData["type"] == "success") {
          user = User();
          user.photo1 = "$BASE_URL/uploads/${decodedData['data']['photo1']}";
          user.photo2 = "$BASE_URL/uploads/${decodedData['data']['photo2']}";
          user.photo3 = "$BASE_URL/uploads/${decodedData['data']['photo3']}";
          user.photo4 = "$BASE_URL/uploads/${decodedData['data']['photo4']}";
          user.photo5 = "$BASE_URL/uploads/${decodedData['data']['photo5']}";
          user.photo6 = "$BASE_URL/uploads/${decodedData['data']['photo6']}";
        emit(AppMain());
        return 1;
      } else {
        return 0;
      }
    } else {
      print(await response.stream.bytesToString());
      return 0;
    }
  }

  Future<void> fetchProfileInfo1(String user_id) async {
    try {
      final response =
          await http.get(Uri.parse('${API_URL}get_user?id=$user_id'));
      if (response.statusCode == 200) {
        user = User();
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        user.id = userId;
        user.name = jsonData['data']['user_name'] ?? "";
        user.nickname = jsonData['data']['user_nickname'] ?? "";
        user.residenceId = jsonData['data']['residenceid'] ?? 0;
        user.residence = jsonData['data']['residence'] ?? "";
        int age = DateTime.now().year - int.parse(jsonData['data']['birthday'].split("-")[0]);
        user.bday = age.toString();
        user.height = double.parse(jsonData['data']['height'] ?? 130);
        user.bodytypeId = jsonData['data']['bodytypeId'] ?? 0;
        user.bodytype = jsonData['data']['bodytype'] ?? "";
        user.usePurpose = jsonData['data']['use_purpose'] ?? "";
        user.introduce = jsonData['data']['introduce'] ?? "";
        user.planType = jsonData['data']['plan_type'] ?? "";
        // user.likesRate = int.parse(jsonData['data']['likes_rate'] ?? 0);
        user.coin = double.parse(jsonData['data']['coin'] ?? 0);
        user.identityState = jsonData['data']['identity_state'] ?? "";
        user.bloodType = jsonData['data']['blood_type'] ?? "";
        user.alcohol = jsonData['data']['alcohol'] ?? "";
        user.cigarette = jsonData['data']['cigarette'] ?? "";
        user.education = jsonData['data']['education'] ?? "";
        user.holiday = jsonData['data']['holiday'] ?? "";
        user.annualIncome = jsonData['data']['annual_income'] ?? "";
        user.res_count = jsonData['count']['res_count'] ?? "0";
        r_count = jsonData['count']['res_count'] ?? "0";
        user.phone_number = jsonData['data']['phone_number'] ?? "";
        user.phone_token = jsonData['data']['phone_token'] ?? "";
        avatarImages = [
          "$BASE_URL/uploads/${jsonData['data']['photo1']}",
          "$BASE_URL/uploads/${jsonData['data']['photo2']}",
          "$BASE_URL/uploads/${jsonData['data']['photo3']}",
          "$BASE_URL/uploads/${jsonData['data']['photo4']}",
          "$BASE_URL/uploads/${jsonData['data']['photo5']}",
          "$BASE_URL/uploads/${jsonData['data']['photo6']}",
        ];
        // user.phone = jsonData['data']['phone'] ?? "";
        user.photo1 = "$BASE_URL/uploads/${jsonData['data']['photo1']}";
        user.photo2 = "$BASE_URL/uploads/${jsonData['data']['photo2']}";
        user.photo3 = "$BASE_URL/uploads/${jsonData['data']['photo3']}";
        user.photo4 = "$BASE_URL/uploads/${jsonData['data']['photo4']}";
        user.photo5 = "$BASE_URL/uploads/${jsonData['data']['photo5']}";
        user.photo6 = "$BASE_URL/uploads/${jsonData['data']['photo6']}";

        var tempCommunityList = jsonData['data']['community'];
        var tempBadgeList = jsonData['data']['intro_badge'];
        for (var i = 0; i < tempCommunityList.length; i++) {
          CommunityObject temp = CommunityObject(
              tempCommunityList[i]['id'],
              tempCommunityList[i]['community_name'],
              false,
              1,
              int.parse(tempCommunityList[i]['community_category']),
              "$BASE_URL/uploads/${tempCommunityList[i]['community_photo']}");
          user.community.add(temp);
        }
        for (var i = 0; i < tempBadgeList.length; i++) {
          BadgeItemObject tempBadge = BadgeItemObject(
              tempBadgeList[i]['id'],
              tempBadgeList[i]['tag_text'],
              false,
              tempBadgeList[i]['tag_color']);
          user.introBadge.add(tempBadge);
        }
        emit(AppMain());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }

  Future<void> fetchLikeRandom() async {
    try {
      final response =
          await http.get(Uri.parse('${API_URL}get_like_random_data/$UserId'));
      print(response.body);
      if (response.statusCode == 200) {
        user = User();
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        receiver_id = jsonData['data']['user_id'].toString();
        user.name = jsonData['data']['user_name'] ?? "";
        user.nickname = jsonData['data']['user_nickname'] ?? "";
        user.residenceId = jsonData['data']['residenceid'] ?? 0;
        user.residence = jsonData['data']['residence'] ?? "";
        int age = DateTime.now().year - int.parse(jsonData['data']['birthday'].split("-")[0]);
        user.bday = age.toString();
        user.height = double.parse(jsonData['data']['height'] ?? 130);
        user.bodytypeId = jsonData['data']['bodytypeId'] ?? 0;
        user.bodytype = jsonData['data']['bodytype'] ?? "";
        user.usePurpose = jsonData['data']['use_purpose'] ?? "";
        user.introduce = jsonData['data']['introduce'] ?? "";
        user.planType = jsonData['data']['plan_type'] ?? "";
        // user.likesRate = int.parse(jsonData['data']['likes_rate'] ?? 0);
        user.coin = double.parse(jsonData['data']['coin'] ?? 0);
        user.identityState = jsonData['data']['identity_state'] ?? "";
        user.bloodType = jsonData['data']['blood_type'] ?? "";
        user.alcohol = jsonData['data']['alcohol'] ?? "";
        user.cigarette = jsonData['data']['cigarette'] ?? "";
        user.education = jsonData['data']['education'] ?? "";
        user.holiday = jsonData['data']['holiday'] ?? "";
        user.annualIncome = jsonData['data']['annual_income'] ?? "";
        user.res_count = jsonData['count']['res_count'] ?? "0";
        r_count = jsonData['count']['res_count'] ?? "0";
        user.phone_number = jsonData['data']['phone_number'] ?? "";
        user.phone_token = jsonData['data']['phone_token'] ?? "";

        // user.phone = jsonData['data']['phone'] ?? "";
        user.photo1 = "$BASE_URL/uploads/${jsonData['data']['photo1']}";
        user.photo2 = "$BASE_URL/uploads/${jsonData['data']['photo2']}";
        user.photo3 = "$BASE_URL/uploads/${jsonData['data']['photo3']}";
        user.photo4 = "$BASE_URL/uploads/${jsonData['data']['photo4']}";
        user.photo5 = "$BASE_URL/uploads/${jsonData['data']['photo5']}";
        user.photo6 = "$BASE_URL/uploads/${jsonData['data']['photo6']}";
        avatarImages = [
          "$BASE_URL/uploads/${jsonData['data']['photo1']}",
          "$BASE_URL/uploads/${jsonData['data']['photo2']}",
          "$BASE_URL/uploads/${jsonData['data']['photo3']}",
          "$BASE_URL/uploads/${jsonData['data']['photo4']}",
          "$BASE_URL/uploads/${jsonData['data']['photo5']}",
          "$BASE_URL/uploads/${jsonData['data']['photo6']}",
        ];
        var tempCommunityList = jsonData['data']['community'];
        var tempBadgeList = jsonData['data']['intro_badge'];
        for (var i = 0; i < tempCommunityList.length; i++) {
          CommunityObject temp = CommunityObject(
              tempCommunityList[i]['id'],
              tempCommunityList[i]['community_name'],
              false,
              1,
              int.parse(tempCommunityList[i]['community_category']),
              "$BASE_URL/uploads/${tempCommunityList[i]['community_photo']}");
          user.community.add(temp);
        }
        for (var i = 0; i < tempBadgeList.length; i++) {
          BadgeItemObject tempBadge = BadgeItemObject(
              tempBadgeList[i]['id'],
              tempBadgeList[i]['tag_text'],
              false,
              tempBadgeList[i]['tag_color']);
          user.introBadge.add(tempBadge);
        }
        emit(AppMain());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }

  Future<void> fetchProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserId = await prefs.getString("UserId").toString();

    try {
      final response =
          await http.get(Uri.parse('${API_URL}get_user?id=$UserId'));
      print(response.body);
      if (response.statusCode == 200) {
        user = User();
        Map<String, dynamic> jsonData = jsonDecode(response.body);
     
        user.id = userId;
        user.name = jsonData['data']['user_name'] ?? "";
        user.nickname = jsonData['data']['user_nickname'] ?? "";
        user.residenceId = jsonData['data']['residenceid'] ?? 0;
        user.residence = jsonData['data']['residence'] ?? "";
        user.bday = jsonData['data']['birthday'] ?? "";
        user.height = double.parse(jsonData['data']['height'] ?? 130);
        user.bodytypeId = jsonData['data']['bodytypeId'] ?? 0;
        user.bodytype = jsonData['data']['bodytype'] ?? "";
        user.usePurpose = jsonData['data']['use_purpose'] ?? "";
        user.introduce = jsonData['data']['introduce'] ?? "";
        user.planType = jsonData['data']['plan_type'] ?? "";
        user.likesRate = int.parse(jsonData['data']['likes_rate'] ?? 0);
        user.coin = double.parse(jsonData['data']['coin'] ?? 0);
        user.identityState = jsonData['data']['identity_state'] ?? "";
        user.bloodType = jsonData['data']['blood_type'] ?? "";
        user.alcohol = jsonData['data']['alcohol'] ?? "";
        user.cigarette = jsonData['data']['cigarette'] ?? "";
        user.education = jsonData['data']['education'] ?? "";
        user.holiday = jsonData['data']['holiday'] ?? "";
        user.annualIncome = jsonData['data']['annual_income'] ?? "";
        user.res_count = jsonData['count']['res_count'] ?? "0";
        user.today_recom = jsonData['today_recom']['today_count'].toString() ?? "0";
        r_count = jsonData['count']['res_count'] ?? "0";
        user.phone_number = jsonData['data']['phone_number'] ?? "";
        user.phone_token = jsonData['data']['phone_token'] ?? "";
        body_type = jsonData['data']['bodytype'] ?? "";
        blood_type = jsonData['data']['blood_type'] ?? "";
        edu_type = jsonData['data']['education'] ?? "";
        purpose_type = jsonData['data']['use_purpose'] ?? "";
        annual_budget = jsonData['data']['annual_income'] ?? "";
        holi_info = jsonData['data']['holiday'] ?? "";
        ciga_info = jsonData['data']['cigarette'] ?? "";
        alcohol_info = jsonData['data']['alcohol'] ?? "";
        // user.phone = jsonData['data']['phone'] ?? "";
        user.photo1 = "$BASE_URL/uploads/${jsonData['data']['photo1']}";
        user.photo2 = "$BASE_URL/uploads/${jsonData['data']['photo2']}";
        user.photo3 = "$BASE_URL/uploads/${jsonData['data']['photo3']}";
        user.photo4 = "$BASE_URL/uploads/${jsonData['data']['photo4']}";
        user.photo5 = "$BASE_URL/uploads/${jsonData['data']['photo5']}";
        user.photo6 = "$BASE_URL/uploads/${jsonData['data']['photo6']}";

        var tempCommunityList = jsonData['data']['community'];
        var tempBadgeList = jsonData['data']['intro_badge'];
        for (var i = 0; i < tempCommunityList.length; i++) {
          CommunityObject temp = CommunityObject(
              tempCommunityList[i]['id'],
              tempCommunityList[i]['community_name'],
              false,
              1,
              int.parse(tempCommunityList[i]['community_category']),
              "$BASE_URL/uploads/${tempCommunityList[i]['community_photo']}");
          user.community.add(temp);
        }
        for (var i = 0; i < tempBadgeList.length; i++) {
          BadgeItemObject tempBadge = BadgeItemObject(
              tempBadgeList[i]['id'],
              tempBadgeList[i]['tag_text'],
              false,
              tempBadgeList[i]['tag_color']);
          user.introBadge.add(tempBadge);
        }
        emit(AppMain());
      } else {
        print("Url Not Found!");
      }
    } catch (e) {
      print("Error---------->${e}");
    }
  }
  // !--------> profile end

  static AppCubit get(context) => BlocProvider.of(context);
}
