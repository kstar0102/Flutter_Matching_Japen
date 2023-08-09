// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matching_app/model/dio_exception.dart';

class DioClient {
  static final _baseOptions = BaseOptions(
    // baseUrl: 'http://mobileapp.swaconnect.net/api',
    baseUrl: 'http://greeme.net/api',
    //connectTimeout: 10000, receiveTimeout: 10000,
    headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie':
          'XSRF-TOKEN=eyJpdiI6Inc1YW0wQ29WVlJaUUF3V2RkUXRVaVE9PSIsInZhbHVlIjoibDkrMmRmSFFNQkxZbENybFFscXo1d3hHUXAySFVBWE1XbEthRFoybStRT0ZETk9BcXlLRXkrQmZYSnRzODZ6aHRjamtNZ1RyK2VKbmFlS3BNTGtSS1g1NnhjNjJ0RHVReUVjTFpBMzhlaytCc3hVWDBJZWxNOTVUYURrakRud3YiLCJtYWMiOiIzYzNmOTU1NDA0ODkxZTU3NWQzMDQyMmMzZThmMDU2OWQ3ODkzYTY2ZGI1ZWViNmU0M2VmMmMwZDBhYjg1YzlmIn0%3D; laravel_session=eyJpdiI6IndwREYyUnNob3B2aUtiam5JdEE0ckE9PSIsInZhbHVlIjoiL1FUejBJbUEwcG9lWnl5NmtXVlQzQ1VRVzZZWEhZZDIwbnpnNFBuSTBuclpESjBKTkhPaFdhdlFTQWFuNUh4MWErOGdSTVdkVkZyYnEvOEJ1RVhTWUEvRlA0TlRPZC9jL0NVZlRRWkRCaUZXUHlEYWNqVTIzV2hwZnBPZzhVVjEiLCJtYWMiOiIzZDczOWM1Y2ViZDE0OTE2N2M5ODYyNDdkMmRlYzMyOGUwNjU2MmY0NTcxZGU2NGI4MTM1ZTEwZWE2MGY5ZWVmIn0%3D',
    },
  );

  // * keep token for future usage.
  static String _token = '';

  // * GET: '/token'
  static Future<String> _getToken() async {
    final random = Random.secure();
    var values = List<int>.generate(8, (i) => random.nextInt(256));
    _token = base64Url.encode(values);
    return _token;
  }

  String createToken() {
    final random = Random.secure();
    var values = List<int>.generate(8, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // * POST: '/login'
  static Future<dynamic> postIntroduce(String uId, String introText) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isShow', "true");
    try {
      final response = await dio
          .post('/introduce_update', data: {'id': uId, 'data': introText});
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

    // * POST: '/NickName'
  static Future<dynamic> postNickname(String uId, String nick_name) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio
          .post('/nickname_update', data: {'id': uId, 'data': nick_name});
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST: '/PhoneNumber'
  static Future<dynamic> postPhoneNumber(String phone_number) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio
          .post('/phone_valid', data: {'phone': phone_number});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * GET: '/profile/uid'
  static Future<dynamic> GetIntro(String uid) async {
    final token = await _getToken();

    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    // print('=============+++++++++++${uid}+++++++++++++===============');
    try {
      final response = await dio.get('/get_introdata/$uid');
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeAddressData(String uid, String idx) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    // print('=============+++++++++++${uid}+++++++++++++===============');
    try {
       final response = await dio
          .post('/residence_update', data: {'id': uid, 'data': idx});
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doLogout(String uid) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    print('=============+++++++++++${uid}+++++++++++++===============');
    try {
       final response = await dio
          .post('/account_logout', data: {'id': uid});
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeBodyData(String uid, String idx) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    // print('=============+++++++++++${uid}+++++++++++++===============');
    try {
       final response = await dio
          .post('/bodytype_update', data: {'id': uid, 'data': idx});
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeHeightData(String uid, String idx) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    // print('=============+++++++++++${uid}+++++++++++++===============');
    try {
       final response = await dio
          .post('/height_update', data: {'id': uid, 'data': idx});
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeBloodData(String uid, String blood_info) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    // print('=============+++++++++++${uid}+++++++++++++===============');
    try {
       final response = await dio
          .post('/bloodtype_update', data: {'id': uid, 'data': blood_info});
      // print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeEducation(String uid, String edu_info) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/education_update', data: {'id': uid, 'data': edu_info});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changePurpose(String uid, String idx) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/use_purpose', data: {'id': uid, 'data': idx});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeBudget(String uid, String budget) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/annualincome_update', data: {'id': uid, 'data': budget});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeHoliday(String uid, String holi) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/holiday_update', data: {'id': uid, 'data': holi});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> changeCiga(String uid, String ciga) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/smoking_update', data: {'id': uid, 'data': ciga});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

   static Future<dynamic> changeAlcohol(String uid, String alcohol) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/alcohol_update', data: {'id': uid, 'data': alcohol});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

    // * GET '/BoardList/all'

  static Future<dynamic> getBoardData(String uid) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_board_data/$uid',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> doFetchResData(String uid) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_res_board/$uid',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> doFetchDetailData(String dataValue) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_res_detail/$dataValue',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> postBoardReply(String uid, String id, String message, String res_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/post_board_data', data: {'board_id': id, 'active_user_id': uid, 'res_board_content':message, 'res_user_id': res_id});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> addBoardData(String uid, String selectedItems, String board_text) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/active_board_data', data: {'uid': uid, 'created_date': selectedItems, 'board_text': board_text});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doDetailData(String res_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/add_matching_data', data: {'res_id': res_id});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doPeopleRecom(String send_id, String receiver_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    print(send_id+receiver_id);
    try {
       final response = await dio
          .post('/add_like_data', data: {'send_id': send_id, 'receiver_id' : receiver_id});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doChatting(String send_id, String receiver_id, String msg, String curtime) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/update_like_data', data: {'send_id': send_id, 'receiver_id' : receiver_id, 'msg' : msg, 'curtime' : curtime});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doMessage(String send_id, String receiver_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/update_message_data', data: {'send_id': send_id, 'receiver_id' : receiver_id});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> addLikesData(String send_id, String receiver_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    print(send_id+receiver_id);
    try {
       final response = await dio
          .post('/add_user_like', data: {'send_id': send_id, 'receiver_id' : receiver_id});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doGetCommunicateData(String user_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_communication_data/$user_id',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }
  
  static Future<dynamic> doGetPeopleData(String sub_id, String user_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_people_data/$sub_id/$user_id',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> doGetChattingData(String user_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_chatting_group/$user_id',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> doGetLikeData(String user_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_like_data/$user_id',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // handle unauthorized error
      } else {
        throw e.message; // let DioExceptions handle other errors
      }
    }
  }

  static Future<dynamic> addMatching(String receiver_id, String send_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/add_matching', data: {'send_id': send_id, 'receiver_id' : receiver_id});
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> removeMatching(String receiver_id, String send_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/remove_matching', data: {'send_id': send_id, 'receiver_id' : receiver_id});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> userReport(String receiver_id, String send_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
       final response = await dio
          .post('/user_report', data: {'send_id': send_id, 'receiver_id' : receiver_id});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
