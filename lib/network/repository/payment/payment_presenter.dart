import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/payment/payment_repository.dart';
import 'package:kona_ice_pos/network/repository/payment/strip_token_model.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class PaymentPresenter {
  late final ResponseContractor _view;
  late PaymentRepository _paymentRepository;

  PaymentPresenter(this._view) {
    _paymentRepository = PaymentRepository();
  }
  void getToken(dynamic body) {
    _paymentRepository
        .getStripeToken(body)
        .then((value) => _view.showSuccess(value))
        .onError((error, stackTrace) {
      debugPrint(error.toString());
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }

  void getPaymentMethod(dynamic body) {
    _paymentRepository
        .getPaymentMethod(body)
        .then((value) => _view.showSuccess(value))
        .onError((error, stackTrace) {
      debugPrint(error.toString());
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }
}
