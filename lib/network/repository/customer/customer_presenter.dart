import '../../exception.dart';
import '../../response_contractor.dart';
import 'customer_repository.dart';

class CustomerPresenter {
  late final ResponseContractor _view;
  late CustomerRepository _customerRepository;

  CustomerPresenter(this._view) {
    _customerRepository = CustomerRepository();
  }

  void customerList(String searchText) {
    _customerRepository.customerList(searchText).then((value) {
      _view.showSuccess(value);
    }).onError((error, stackTrace) {
      _view.showError(FetchException(error).fetchErrorModel());
    });
  }
}
