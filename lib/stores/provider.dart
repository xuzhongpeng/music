/*
 * @Author: xuzhongpeng
 * @email: xuzhongpeng@foxmail.com
 * @Date: 2019-08-15 21:10:44
 * @LastEditors  : xuzhongpeng
 * @LastEditTime : 2019-12-24 19:31:23
 * @Description: 本地使用GmProvider建立model
 */
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'dart:async';

class MuProvider extends ChangeNotifier {
  //重写notifyListeners目的是在initState中调用
  //notifyListeners不会报错
  @override
  void notifyListeners() {
    scheduleMicrotask(() {
      try {
        super.notifyListeners();
      } catch (e) {
        throw ("provider 出问题了");
      }
    });
  }
}
