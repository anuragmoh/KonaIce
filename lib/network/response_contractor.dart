import 'package:kona_ice_pos/network/exception.dart';
import 'general_error_model.dart';

abstract class ResponseContractor{
  void showSuccess(dynamic response);
  void showError(GeneralErrorResponse exception);
}

abstract class ClockInOutResponseContractor extends ResponseContractor{
  void showSuccessForUpdateClockIN(dynamic response);
  void showErrorForUpdateClockIN(GeneralErrorResponse exception);
}

abstract class OrderResponseContractor extends ResponseContractor {
  void showSuccessForPlaceOrder(dynamic response);
  void showErrorForPlaceOrder(GeneralErrorResponse exception);
}

abstract class SyncResponseContractor extends ResponseContractor{
  void showSyncSuccess(dynamic response);
  void showSyncError(GeneralErrorResponse exception);
}