import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class NetworkProbeService {
  NetworkProbeService()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 3),
          ),
        ),
        _httpClient = http.Client();

  final Dio _dio;
  final http.Client _httpClient;

  Future<String> probe() async {
    const String url = 'https://example.com';

    try {
      final http.Response httpRes = await _httpClient.get(Uri.parse(url));
      final Response<dynamic> dioRes = await _dio.get<dynamic>(url);
      return 'HTTP: ${httpRes.statusCode}, Dio: ${dioRes.statusCode}';
    } catch (_) {
      return 'Network probe unavailable';
    }
  }

  void dispose() {
    _httpClient.close();
    _dio.close();
  }
}
