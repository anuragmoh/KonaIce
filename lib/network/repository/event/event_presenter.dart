import 'package:kona_ice_pos/network/repository/event/event_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class EventPresenter{
  late ResponseContractor _view;
  late EventRepository _eventRepository;

  EventPresenter(this._view) {
    _eventRepository = EventRepository();
  }

}