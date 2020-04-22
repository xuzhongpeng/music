import 'package:dio/dio.dart';

class Http {
  factory Http() => _instance;
  static final _instance = Http._singleTon();
  Http._singleTon();

  Dio _dio;
  Dio get dio => _dio;
  init() {
    _dio = new Dio();
    //添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      return options;
    }, onResponse: (Response response) async {
      return response;
    }, onError: (DioError e) async {
      return e;
    }));
  }
}
