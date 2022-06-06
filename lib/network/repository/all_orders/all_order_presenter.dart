import 'package:kona_ice_pos/models/network_model/all_order/refund_payment_model.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/all_orders/all_order_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class AllOrderPresenter {
  late final ResponseContractor _view;
  late AllOrderRepository _repository;

  AllOrderPresenter(this._view) {
    _repository = AllOrderRepository();
  }

  getSyncOrder(
      {required String orderStatus,
      required String eventId,
      required int offset,
      required int lastSync}) {
    _repository
        .getOrderSync(orderStatus, eventId, offset, lastSync)
        .then((value) => _view.showSuccess(value))
        .onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }

  void refundPayment(
      String orderId, RefundPaymentModel refundPaymentModel) {
    _repository
        .refundPayment(orderId, refundPaymentModel)
        .then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }
}
