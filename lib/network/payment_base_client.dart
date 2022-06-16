import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kona_ice_pos/constants/other_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/url_constants.dart';

import 'app_exception.dart';
import 'general_error_model.dart';

class PaymentBaseClient {
  static const int timeOutDuration = 20;
  Map<String, String> header = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "Bearer ${PaymentConstants.secreteKey}"
  };

  Future<dynamic> post(String api, dynamic payloadObj) async {
    var uri = Uri.parse(UrlConstants.paymentBaseUrl + api);
    debugPrint(uri.toString());
    final body = {
      "card[number]": "4111111111111111",
      "card[cvc]": "123",
      "card[exp_month]": "12",
      "card[exp_year]": "22"
    };

    var payload = json.encode(payloadObj);

    // await addSessionKeyToHeader();
    debugPrint(body.toString());

    try {
      var response = await http
          .post(
            uri,
            headers: header,
            body: payloadObj,
            encoding: Encoding.getByName("utf-8"),
          )
          .timeout(const Duration(seconds: timeOutDuration));
      debugPrint(response.body.toString());
      return _processResponse(response);
    } on GeneralApiResponseErrorException catch (error) {
      throw GeneralApiResponseErrorException(error.errorModel);
    } on Exception {
      throw GeneralApiResponseErrorException(getDefaultErrorResponse());
    }
  }

  String getDefaultErrorResponse() {
    String defaultValue =
        (GeneralErrorResponse(message: StringConstants.somethingWentWrong))
            .toRawJson();
    return defaultValue.toString();
  }

  dynamic _processResponse(http.Response response) {
    debugPrint("response code ${response.statusCode}");
    if (response.isOkResponse()) {
      debugPrint("Ok");
      return response.body.toString();
    } else if (response.isUnauthorizedUser()) {
      // FunctionalUtils.clearSessionData();
      //   getErrorModel(response);
    } else {
      debugPrint("Not Ok");
      // getErrorModel(response);
    }
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
