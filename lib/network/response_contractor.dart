import 'package:kona_ice_pos/network/exception.dart';

abstract class ResponseContractor{
  void showSuccess(dynamic response);
  void showError(FetchException exception);
}