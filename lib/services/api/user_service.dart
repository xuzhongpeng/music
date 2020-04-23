import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music/config/http.dart';

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
}
