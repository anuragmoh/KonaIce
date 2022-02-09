import 'package:kona_ice_pos/constants/url_constants.dart';
import 'package:kona_ice_pos/screens/event_menu/search_customer/customer_model.dart';

import '../../base_client.dart';

class CustomerRepository {
  BaseClient baseClient = BaseClient();

  Future<List<CustomerDetails>> customerList(searchText){
    return baseClient.get(UrlConstants.getCustomerList(searchText: searchText)).then((value){
      return customerDetailsFromJson(value);
    });
  }
}