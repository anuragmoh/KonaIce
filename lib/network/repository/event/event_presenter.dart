import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/event/event_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class EventPresenter{
   late final ResponseContractor _view;
  late EventRepository _eventRepository;

  EventPresenter(this._view) {
    _eventRepository = EventRepository();
  }

  void deleteOrder({required String orderId}){
    _eventRepository.deleteOrder(orderId: orderId).then((value) => _view.showSuccess(value)).onError((error, stackTrace) => _view.showError(FetchException(error).fetchErrorModel()));
  }

}