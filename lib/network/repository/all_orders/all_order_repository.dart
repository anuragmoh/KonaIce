import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/network/base_client.dart';
import 'package:kona_ice_pos/screens/all_orders/all_order_model.dart';

class AllOrderRepository{
  BaseClient baseClient = BaseClient();

  Future<AllOrderResponse> getOrderSync(orderStatus, eventId, offset, lastSync ) {
    return baseClient.get(UrlConstants.getAllOrders(orderStatus: orderStatus, eventId: eventId, offset: offset, lastSync: lastSync)).then((value){
      return allOrderResponseFromJson(value);
    });
  }
}