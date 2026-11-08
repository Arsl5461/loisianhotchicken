import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

class DioLoggerService {
  static Interceptor getPrettyDioLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }

  static void attachLoggerInterceptor(Dio dio) {
    dio.interceptors.clear();
    dio.interceptors.add(getPrettyDioLogger());
  }
}
