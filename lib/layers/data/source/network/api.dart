import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Api {
  Future<R> getData<R>(
      {required String endpoint,
      Map<String, dynamic> params,
      String method,
      FormData? data});
  Future<void> setData();
}

class ApiImpl implements Api {
  final Dio dio;

  ApiImpl() : dio = Dio() {
    final baseUrl = dotenv.env['BASE_URL'];
    print('Base URL: $baseUrl'); // Debug print

    dio.options = BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add logging interceptor
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
    ));
  }
  @override
  Future<R> getData<R>(
      {required String endpoint,
      Map<String, dynamic>? params,
      FormData? data,
      String method = 'GET'}) async {
    try {
      // Ensure the URL is properly formatted

      print('Method: $method');
      print('Headers: ${dio.options.headers}');
      print('Parameters: $params');

      Response response;
      if (method == 'POST') {
        response = await dio.post(
          endpoint,
          data: params ?? data,
          options: Options(
            validateStatus: (status) => status != null && status < 500,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest', // Add this for Laravel API
            },
          ),
        );
      } else {
        response = await dio.get(
          endpoint,
          queryParameters: params,
          options: Options(
            validateStatus: (status) => status != null && status < 500,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest', // Add this for Laravel API
            },
          ),
        );
      }

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Request failed with status: ${response.statusCode}, message: ${response.statusMessage}\nResponse data: ${response.data}',
        );
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      print('Error Status: ${e.response?.statusCode}');
      rethrow;
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> setData() {
    // Implement the logic to set data to the network
    throw UnimplementedError();
  }
}
