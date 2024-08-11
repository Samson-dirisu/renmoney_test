import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'exports.dart';

final networkServiceProvider = Provider<NetworkServiceImpl>((ref) {
  return NetworkServiceImpl();
});

class NetworkServiceImpl implements NetworkService {
  final Dio _dio;
  NetworkServiceImpl() : _dio = Dio() {
    final baseOptions = BaseOptions(
      baseUrl: '',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
      validateStatus: _validateStatus,
    );
    // set the options

    _dio.options = baseOptions;

    final presetHeaders = <String, String>{
      Headers.acceptHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    _dio.options.headers = presetHeaders;
    _dio.interceptors.addAll(
      [
        if (kDebugMode)
          LogInterceptor(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            error: true,
          ),
      ],
    );
  }

  @override
  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
  }) async {
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
      );

      return response;
  }

  @override
  Future<Response> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post(
      uri,
      data: data,
      queryParameters: queryParameters,
    );

    return response;
  }

  @override
  Future<Response> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.delete(
      uri,
      data: data,
      queryParameters: queryParameters,
    );

    return response;
  }

  @override
  Future<Response> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.put(
      uri,
      data: data,
      queryParameters: queryParameters,
    );

    return response;
  }

  @override
  Future<Response> formData(String uri, {required File file}) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      },
    );
    final response = await _dio.post(
      uri,
      data: formData,
    );
    return response;
  }

  /// validate the status of a request
  bool _validateStatus(int? status) {
    return status! == 200 || status == 201;
  }

  /// method to add a token or authorization on the created dio object

  void addAuthorization(String token) {
    _dio.options.headers.addAll({
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
  }

  void removeAuthorization() {
    _dio.options.headers.remove(HttpHeaders.authorizationHeader);
  }
}

extension ResponseExtension on Response {
  bool get isSuccess {
    final is200 = statusCode == HttpStatus.ok;
    final is201 = statusCode == HttpStatus.created;
    return is200 || is201;
  }
}