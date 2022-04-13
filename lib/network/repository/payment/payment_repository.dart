import 'package:flutter/cupertino.dart';
import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/network/payment_base_client.dart';
import 'package:kona_ice_pos/network/repository/payment/strip_token_model.dart';
import 'package:kona_ice_pos/network/repository/payment/stripe_payment_method_model.dart';

class PaymentRepository{

PaymentBaseClient paymentBaseClient=PaymentBaseClient();

Future<StripTokenResponseModel> getStripeToken(dynamic stripTokenRequestModel){
  return paymentBaseClient.post(UrlConstants.paymentGetToken, stripTokenRequestModel).then((value) {
    return stripTokenResponseModelFromJson(value);
  } );
}

Future<StripePaymentMethodRequestModel> getPaymentMethod(dynamic response){
  return paymentBaseClient.post(UrlConstants.paymentMethod, response).then((value) {
    return stripePaymentMethodRequestModelFromJson(value);
  } );
}
}