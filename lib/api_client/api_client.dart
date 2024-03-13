import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({required this.baseUrl}) {
    const defaultTimeout = Duration(seconds: 30);
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: defaultTimeout,
      receiveTimeout: defaultTimeout,
      sendTimeout: defaultTimeout,
      responseType: ResponseType.json,
      headers: {"Content-Type": "application/javascript"},
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
    ));
  }

  final String baseUrl;
  late final Dio dio;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ignore: avoid_print
    print(
      'send request to URL:${options.baseUrl}${options.path} '
      'with params: ${options.queryParameters} and data: ${options.data}',
    );
    // ignore: avoid_print
    print(options.headers);

    return handler.next(options);
  }

  Future<void> _onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    switch (response.statusCode) {
      case 200:
        // ignore: avoid_print
        print(response.data.toString());
        return handler.next(response);
      default:
        throw Exception('error: status code ${response.statusCode}');
    }
  }

  Future<Response> sendPhoto({
    required String comment,
    required double latitude,
    required double longitude,
    required String photo,
  }) async {
    final fileName = photo.split('/').last;
    final formData = FormData.fromMap({
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'photo': await MultipartFile.fromFile(photo, filename: fileName),
    });

    return dio.post('/upload_photo/', data: formData);
  }
}
