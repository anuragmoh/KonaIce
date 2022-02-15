
import 'package:kona_ice_pos/screens/event_menu/order_model/order_request_model.dart';
import 'package:kona_ice_pos/screens/payment/pay_order_model/pay_order_request_model.dart';

import '../../exception.dart';
import '../../response_contractor.dart';
import 'order_repository.dart';

class OrderPresenter {
  late OrderResponseContractor _view;
  late OrderRepository _orderRepository;

  OrderPresenter(this._view) {
    _orderRepository = OrderRepository();
  }

  void placeOrder(PlaceOrderRequestModel placeOrderRequestModel) {
    _orderRepository
        .placeOrder(placeOrderRequestModel: placeOrderRequestModel)
        .then((value){
      _view.showSuccessForPlaceOrder(value);
    }).onError((error, stackTrace){
      _view.showErrorForPlaceOrder(FetchException(error.toString()).fetchErrorModel());
    });
  }

  void payOrder(PayOrderRequestModel payOrderRequestModel) {
    _orderRepository
        .payOrder(payOrderRequestModel: payOrderRequestModel)
        .then((value){
      print("Success ----- $value}");
      _view.showSuccess(value);
    }).onError((error, stackTrace){
      print("Errror ----- ${error.toString()}");
      _view.showError(FetchException(error.toString()).fetchErrorModel());
    });
  }
}