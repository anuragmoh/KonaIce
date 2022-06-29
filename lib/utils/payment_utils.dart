import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class PaymentUtilsContractor {
  void paymentSuccess(dynamic response);
  void paymentFailed(dynamic response);
  void paymentStatus(dynamic response);
  void getPaymentToken(dynamic response);
}

class PaymentUtils {
  static const MethodChannel _cardPaymentChannel =
      MethodChannel("com.mobisoft.konaicepos/cardPayment");

  PaymentUtils._privateConstructor();
  late PaymentUtilsContractor _view;

  static final PaymentUtils shared = PaymentUtils._privateConstructor();

  getPaymentUtilsContractor(PaymentUtilsContractor view) {
    _view = view;
    _cardPaymentChannel.setMethodCallHandler((call) async {
      debugPrint("init state setMethodCallHandler ${call.method}");
      if (call.method == "paymentSuccess") {
        debugPrint("Payment Success!");
        _view.paymentSuccess(call.arguments.toString());
      } else if (call.method == "paymentFailed") {
        debugPrint("Payment Failed!");
        _view.paymentFailed("");
      } else if (call.method == "paymentStatus") {
        _view.paymentStatus(call.arguments.toString());
      } else if (call.method == "getPaymentToken") {
        _view.getPaymentToken(call.arguments.first);
      }
    });
  }

  static performPayment(Map<String, Object> details) async {
    await _cardPaymentChannel.invokeListMethod('performCardPayment', details);
  }

  static getToken(Map<String, Object> details) async {
    await _cardPaymentChannel.invokeListMethod('getPaymentToken', details);
  }
}
