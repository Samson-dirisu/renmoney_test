import 'dart:io';
import 'package:dio/dio.dart';


/// custom exception class for handling exceptions in the api_client
class ApiException implements Exception {
  ApiException(this.message, {this.code});

  final String message;
  final int? code;

  // ignore: prefer_constructors_over_static_methods, type_annotate_public_apis
  static ApiException getException(err) {
    if (err is SocketException) {
      return InternetConnectException(kInternetConnectionError, 0);
    } else if (err is DioException) {
      switch (err.type) {
        case DioExceptionType.cancel:
          return OtherExceptions(
              kRequestCancelledError, err.response?.statusCode);
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionError:
          return InternetConnectException(
              kTimeOutError, err.response?.statusCode ?? 0);

        case DioExceptionType.badResponse:
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          switch (err.response?.statusCode) {
            case 500:
              return InternalServerException(
                  statusCode: err.response?.statusCode);
            case 404:
            case 502:
              return InternalServerException(
                  statusCode: err.response?.statusCode);
            case 400:
              return OtherExceptions(
                  kBadRequestError, err.response?.statusCode);
            case 403:
            case 401:
              return UnAuthorizedException(
                  statusCode: err.response?.statusCode);
            case 413:
              return OtherExceptions(kFileTooLarge, err.response?.statusCode);
            case 409:
              return OtherExceptions(
                  err.response?.data['message'], err.response?.statusCode);
            default:
              // default exception error message
              return OtherExceptions(
                  err.response?.data['message'], err.response?.statusCode);
          }
      }
    } else {
      return OtherExceptions(kDefaultError, 0);
    }
  }
}

class OtherExceptions implements ApiException {
  OtherExceptions(this.newMessage, this.statusCode);

  final String newMessage;
  final int? statusCode;

  @override
  String toString() => message;

  @override
  String get message => newMessage;

  @override
  int? get code => statusCode;
}

class FormatException implements ApiException {
  @override
  String toString() => message;

  @override
  int? get code => null;

  @override
  String get message => kFormatError;
}

class InternetConnectException implements ApiException {
  InternetConnectException(this.newMessage, this.statusCode);

  final String newMessage;
  final int statusCode;

  @override
  String toString() => message;

  @override
  String get message => newMessage;

  @override
  int? get code => statusCode;
}

class InternalServerException implements ApiException {
  final int? statusCode;

  InternalServerException({required this.statusCode});
  @override
  String toString() {
    return message;
  }

  @override
  String get message => kServerError;

  @override
  int? get code => statusCode;
}

class UnAuthorizedException implements ApiException {
  final int? statusCode;

  UnAuthorizedException({required this.statusCode});
  @override
  String toString() {
    return message;
  }

  @override
  String get message => kUnAuthorizedError;

  @override
  int? get code => statusCode;
}

class CacheException implements Exception {
  CacheException(this.message, this.statusCode) : super();

  String message;
  final int? statusCode;

  @override
  String toString() {
    return message;
  }
}

// exceptions messages
const kInternetConnectionError = 'No internet connection, try again.';
const kTimeOutError =
    'Connection timeout. Please check your internet connection.';
const kServerError = 'Something went wrong, try again.';
const kFormatError = 'Unable to process data at this time.';
const kUnAuthorizedError = 'Session expired, please login to proceed.';
const kDefaultError = 'Oops something went wrong!';
const kBadRequestError = 'Bad request, please try again.';
const kFileTooLarge = 'File too large.';
const kNotFoundError = 'An error occured, please try again.';
const kRequestCancelledError = 'Request to server was cancelled.';