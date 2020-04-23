import 'package:dio/dio.dart';
import 'package:music/config/http.dart';
import 'package:music/entities/q/user_detail.dart';

import '../urls.dart';

class UserService {
  static Future<Map> getVersions() async {
    Response res = await Http().dio.get('${Urls.base}/music/getVersions');
    if (res != null && res.data != null) {
      print(res.data);
      if (res.data['code'] == '200' &&
          res.data['msg'] is List &&
          res.data['msg'].length > 0) {
        return res.data['msg'].first;
      }
      return null;
    } else {
      return null;
    }
  }

  static Future<void> getInfo(Creator creator) async {
    Response res = await Http().dio.post('${Urls.base}/music/getInfo',
        data: creator.toJson(),
        options: Options(
            contentType: "application/x-www-form-urlencoded;charset=utf-8"));
    if (res != null && res.data != null) {
      print(res.data);
      if (res.data['code'] == '200') {
        return print(res.data['msg']);
      }
      return null;
    } else {
      return null;
    }
  }
}
