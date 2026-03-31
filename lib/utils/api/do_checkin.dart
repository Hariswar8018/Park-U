import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../api.dart';

import 'dart:io';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: Api.url),
  );

  static Future<Map<String, dynamic>> createCheckin({
    required File imageFile,
    required Map<String, dynamic> data,
    Function(int, int)? onProgress,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        ...data,
        "pic": await MultipartFile.fromFile(
          imageFile.path,
          filename: "checkin.jpg",
        ),
      });

      final response = await _dio.post(
        "/api/checkins/create",
        data: formData,
        onSendProgress: onProgress,
      );
      print_repsone(response);
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }
  static String formatDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
  }
  static Future<List<dynamic>> getCheckinsByDate(String date) async {
    try {
      final response = await _dio.get(
        "/api/checkins/by-date",
        queryParameters: {
          "date": date, // format: YYYY-MM-DD
        },
      );

      print_repsone(response);
      return response.data; // List of checkins
    } catch (e) {
      throw Exception(e);
    }
  }
  static Future<Map<String, dynamic>> checkoutCheckin({
    required int id,
    required String date,
  }) async {
    try {
      final response = await _dio.put(
        "/api/checkins/checkout",
        data: {
          "id": id,
          "date": date,
        },
      );

      print_repsone(response);

      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }
  static Future<List<dynamic>> getCheckinsByDateRange({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.post(
        "/api/checkins/by-date-range",
        data: {
          "startDate": startDate,
          "endDate": endDate,
        },
      );

      print_repsone(response);

      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  static void print_repsone(Response response){
    print(response.statusCode);
    print(response.data);
    print(response.statusMessage);
  }
}