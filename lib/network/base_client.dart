import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/network/app_exception.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';


class BaseClient {

  static const int timeOutDuration = 20;
  Map<String, String> header = {
    "Content-Type": "application/json",
    "Accept-Language": "en-US",
    "X-Client-App": "POS-APP",
    "Timezone":DateTime.now().timeZoneName.toString(),
  };

  //GET
  Future<dynamic> get(String api) async {
    var uri = Uri.parse(UrlConstants.baseUrl + api);
    await addSessionKeyToHeader();
    debugPrint(uri.toString());
    try {
        var response = await http.get(uri, headers: header).timeout(
            const Duration(seconds: timeOutDuration));
        return _processResponse(response);

    } on GeneralApiResponseErrorException catch (error) {
      throw GeneralApiResponseErrorException(error.errorModel);
    } on Exception {
      throw GeneralApiResponseErrorException(getDefaultErrorResponse());
    }
  }

  //POST
  Future<dynamic> post(String api, dynamic payloadObj) async {
    var uri = Uri.parse(UrlConstants.baseUrl + api);
    var payload = json.encode(payloadObj);
    debugPrint("payLoad-----$payload");
    debugPrint("header $header");
    debugPrint(uri.toString());
    await addSessionKeyToHeader();
    try {
      var response = await http.post(uri, headers: header, body: payload)
          .timeout(const Duration(seconds: timeOutDuration));
      debugPrint(response.body.toString());
      return _processResponse(response);
    } on GeneralApiResponseErrorException catch (error) {
      throw GeneralApiResponseErrorException(error.errorModel);
    } on Exception {
      throw GeneralApiResponseErrorException(getDefaultErrorResponse());
    }
  }

  //put
  Future<dynamic> put(String api, dynamic payloadObj) async {
    var uri = Uri.parse(UrlConstants.baseUrl + api);
    var payload = json.encode(payloadObj);
    await addSessionKeyToHeader();
    try {
      var response = await http.put(uri, headers: header, body: payload)
          .timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on GeneralApiResponseErrorException catch (error) {
      throw GeneralApiResponseErrorException(error.errorModel);
    } on Exception {
      throw GeneralApiResponseErrorException(getDefaultErrorResponse());
    }
  }

  //DELETE
  Future<dynamic> delete(String api) async {
    var uri = Uri.parse(UrlConstants.baseUrl + api);
    await addSessionKeyToHeader();
    try {
      var response = await http.delete(uri, headers: header).timeout(
          const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on GeneralApiResponseErrorException catch (error) {
      throw GeneralApiResponseErrorException(error.errorModel);
    } on Exception {
      throw GeneralApiResponseErrorException(getDefaultErrorResponse());
    }
  }


  //OTHER
  addSessionKeyToHeader() async {
    String sessionKey = await FunctionalUtils.getSessionKey();
    debugPrint("Bearer $sessionKey");
    if (sessionKey.isNotEmpty) {
      header["Authorization"] = "Bearer $sessionKey";
    } else {
      header.remove("Authorization");
    }
  }

  dynamic _processResponse(http.Response response) {
    debugPrint("response code ${response.statusCode}");
    if (response.isOkResponse()) {
      debugPrint("Ok");
      return response.body.toString();
    } else if(response.isUnauthorizedUser()) {

      FunctionalUtils.clearSessionData();
    //   getErrorModel(response);
    } else {
      debugPrint("Not Ok");
      getErrorModel(response);
    }
  }

  getErrorModel(http.Response response) {
    var errorList = GeneralErrorList.fromRawJson(response.body.toString());
    debugPrint("ErrorList--->${errorList.general![0].toRawJson().toString()}");
    if (errorList.general != null && errorList.general?[0] != null) {
      // GeneralErrorResponse response = errorList.general![0];
      // response.message = response.message?.replaceAll(".", "");
      String value = errorList.general![0].toRawJson().toString();
      //String value = response.toRawJson().toString();
      throw GeneralApiResponseErrorException(value);
    } else {
      throw GeneralApiResponseErrorException(getDefaultErrorResponse());
    }
  }

  String getDefaultErrorResponse() {
    String defaultValue = (GeneralErrorResponse(
        message: StringConstants.somethingWentWrong)).toRawJson();
    return defaultValue.toString();
  }
}

extension on http.Response {
  bool isOkResponse() {
    return statusCode >= 200 && statusCode <= 299;
  }

  bool isUnauthorizedUser() {
    return statusCode == 401;
  }
}