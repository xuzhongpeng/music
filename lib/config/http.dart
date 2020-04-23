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
      print('请求url: ${options.baseUrl}${options.path}');
      print('请求参数：data:');
      print(options.data.toString());
      print('请求参数：queryParameters:');
      print(options.queryParameters.toString());
      print('请求参数：header:');
      print(options.headers.toString());
      return options;
    }, onResponse: (Response response) async {
      print(response.data);
      return response;
    }, onError: (DioError e) async {
      print(e.toString());
      return e;
    }));
  }
}
