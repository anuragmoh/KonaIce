import 'package:kona_ice_pos/network/exception.dart';
import 'general_error_model.dart';

abstract class ResponseContractor{
  void showSuccess(dynamic response);
  void showError(GeneralErrorResponse exception);
}