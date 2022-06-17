import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/network/app_exception.dart';

import 'general_error_model.dart';

class FetchException implements Exception {
  final dynamic _errorModel;

  FetchException([this._errorModel]);

  GeneralErrorResponse fetchErrorModel() {
    if (_errorModel == null) {
      return GeneralErrorResponse(message: StringConstants.somethingWentWrong);
    }

    String model = StringConstants.somethingWentWrong;

    if (_errorModel is GeneralApiResponseErrorException) {
      model = (_errorModel as GeneralApiResponseErrorException)
          .errorModel
          .toString()
          .replaceFirst("Exception: ", "", 0);
      return GeneralErrorResponse.fromRawJson(model);
    }

    return GeneralErrorResponse(message: model);
  }
}
