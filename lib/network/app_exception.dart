import 'package:kona_ice_pos/network/general_error_model.dart';

class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;
  final GeneralErrorResponse? errorModel;

  AppException([this.message, this.prefix, this.url, this.errorModel]);
}

class AppException1 implements Exception {
  final String? errorModel;
  AppException1([this.errorModel]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad Request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Api not responded in time', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'UnAuthorized request', url);
}

class GeneralApiResponseErrorException extends AppException1 {
  GeneralApiResponseErrorException([String? errorModel]) : super(errorModel);
}
