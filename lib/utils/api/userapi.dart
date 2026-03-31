import 'package:dio/dio.dart';
import '../../api.dart';

class UserApiService {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: Api.url),
  );

  // 🔐 LOGIN
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/api/users/login",
        data: {
          "phone": phone,
          "password": password,
        },
      );

      print_response(response);
      return response.data;

    } catch (e) {
      throw Exception(e);
    }
  }


  static Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
    String? location,
    String? bio,
    String? pic,
    String? shift,
  }) async {
    try {
      final response = await _dio.post(
        "/api/users/register",
        data: {
          "name": name,
          "phone": phone,
          "password": password,
          "location": location,
          "bio": bio,
          "pic": pic,
          "shift": shift,
        },
      );

      print_response(response);
      return response.data;

    } catch (e) {
      throw Exception(e);
    }
  }


  static Future<Map<String, dynamic>> updateUser({
    required int id,
    String? name,
    String? bio,
  }) async {
    try {
      final response = await _dio.put(
        "/api/users/update",
        data: {
          "id": id,
          "name": name,
          "bio": bio,
        },
      );

      print_response(response);
      return response.data;

    } catch (e) {
      throw Exception(e);
    }
  }

  static void print_response(Response response) {
    print(response.statusCode);
    print(response.data);
    print(response.statusMessage);
  }
}