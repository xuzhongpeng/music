import 'package:dio/dio.dart';

class Http {
  factory Http() => _instance;
  static final _instance = Http._singleTon();
  Http._singleTon();

  Dio _dio;
  Dio get dio => _dio;
  init() {
    _dio = new Dio();
    _dio.options = BaseOptions(headers: {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.70 Safari/537.36",
      "Host": "music.jsososo.com",
    });
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
