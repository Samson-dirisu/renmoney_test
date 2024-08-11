import 'package:renmoney_test/core/exception/api_exception.dart';

abstract class ApiResponse<T> {
  const ApiResponse();

  R when<R>({
    required R Function(Successful<T> successful) successful,
    required R Function(Error<T> error) error,
  });
}

class Successful<T> extends ApiResponse<T> {
  final T? data;
  Successful({this.data}) : super();

  @override
  R when<R>({
    required R Function(Successful<T> successful) successful,
    required R Function(Error<T> error) error,
  }) {
    return successful(this);
  }
}

class Error<T> extends ApiResponse<T> {
  final ApiException error;
  Error({required this.error}) : super();

  @override
  R when<R>({
    required R Function(Successful<T> successful) successful,
    required R Function(Error<T> error) error,
  }) {
    return error(this);
  }
}