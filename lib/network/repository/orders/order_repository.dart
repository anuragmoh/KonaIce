
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/models/network_model/order_model/order_request_model.dart';
import 'package:kona_ice_pos/models/network_model/order_model/order_response_model.dart';
import 'package:kona_ice_pos/models/network_model/pay_order_model/pay_order_card_response_model.dart';
import 'package:kona_ice_pos/models/network_model/pay_order_model/pay_order_request_model.dart';
import 'package:kona_ice_pos/models/network_model/pay_order_model/pay_order_response_model.dart';
import 'package:kona_ice_pos/network/repository/payment/payreceipt_model.dart';

import '../../base_client.dart';

class OrderRepository {
  BaseClient baseClient = BaseClient();

  Future<PlaceOrderResponseModel> placeOrder(
      {required PlaceOrderRequestModel placeOrderRequestModel}) {
    return baseClient.post(UrlConstants.placeOrder, placeOrderRequestModel)
        .then((value) {
      return placeOrderResponseModelFromJson(value);
    });
  }

  Future<PayOrderResponseModel> payOrder(
      {required PayOrderRequestModel payOrderRequestModel}) {
    return baseClient.put(UrlConstants.payOrder, payOrderRequestModel).then((
        value) {
      return payOrderResponseModelFromJson(value);
    });
  }

  Future<PayReceipt> finixRecipt(
      {required PayReceipt payReceipt}) {
    return baseClient.put(UrlConstants.payOrder, payReceipt).then((
        value) {
      return payReceiptFromJson(value);
    });
  }

  Future<PayOrderResponseCardModel> payOrderCardMethod(
      {required PayOrderCardRequestModel payOrderCardRequestModel}) {
    return baseClient.put(UrlConstants.payOrder, payOrderCardRequestModel).then((
        value) {
      return payOrderResponseCardModelFromJson(value);
    });
  }
}
