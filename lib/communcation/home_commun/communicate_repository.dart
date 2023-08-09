import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:matching_app/communcation/home_commun/communicate_item.dart';
import 'package:matching_app/model/dio_client.dart';
import 'package:matching_app/controller/auth_repository.dart';
import 'package:matching_app/components/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunicationRepository {
  CommunicationRepository({required this.authRepo});

  final AuthRepository authRepo;
  CommunicateItemList _communicationitems = [];
  Future<CommunicateItemList> doGetCommunicateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('UserId');
    dynamic data = await DioClient.doGetCommunicateData(user_id!);

    final result = data['result'];
    if (result is List) {
      try {
        _communicationitems =
            result.map((data) => CommunicateItem.fromMap(data)).toList();
        return _communicationitems;
      } catch (e) {
        developer.log('doFetchTransaction() error=$e');
        return [];
      }
    } else {
      throw UnimplementedError;
    }
  }
}

final CommunicateProvider = Provider<CommunicationRepository>((ref) {
  return CommunicationRepository(authRepo: ref.watch(authRepositoryProvider));
});
