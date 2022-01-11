import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/network/app_exception.dart';


class BaseClient {

  static const int timeOutDuration = 20;
  Map<String, String> header = {"Content-Type": "application/json","Accept-Language" : "en-US"};


  //GET
  Future<dynamic> get(String api) async {
    var uri = Uri.parse(UrlConstants.baseUrl + api);
    try {
      var response = await http.get(uri,headers: header).timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(StringConstants.internetConnectionError, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(StringConstants.apiNotResponding, uri.toString());
    }
  }

  //POST
  Future<dynamic> post(String api, dynamic payloadObj) async {
    var uri = Uri.parse(UrlConstants.baseUrl + api);
    var payload = json.encode(payloadObj);
    try {
      var response = await http.post(uri,headers: header,body: payload).timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(StringConstants.internetConnectionError, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(StringConstants.apiNotResponding, uri.toString());
    }
  }


  //DELETE
  //OTHER

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.toString();
      case 201:
        return response.body.toString();
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:

      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException('${StringConstants.errorOccurredWithCode}: ${response.statusCode}', response.request!.url.toString());
    }
  }
}