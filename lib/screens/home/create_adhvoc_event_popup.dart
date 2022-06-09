import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/other_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/models/network_model/home/assest_model.dart';
import 'package:kona_ice_pos/models/network_model/home/create_event_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/create_adhoc_event/create_adhoc_event_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/home/uuid.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/loader.dart';

class CreateAdhocEvent extends StatefulWidget {
  const CreateAdhocEvent({Key? key}) : super(key: key);

  @override
  State<CreateAdhocEvent> createState() => _CreateAdhocEventState();
}

class _CreateAdhocEventState extends State<CreateAdhocEvent>
    implements AssetsResponseContractor {
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();

  late Position _currentPosition;

  String _selectedState = "",
      _selectedCity = "",
      _selectedZipcode = "",
      _selectedAddress = "";

  bool _isValidEventName = true,
      _isValidAddress = true,
      _isValidCity = true,
      _isValidZipCode = true,
      _isValidState = true,
      _isAssetSelected = true;

  List<Datum> assetList = [];

  late CreateAdhocEventPresenter _presenter;
  bool _isApiProcess = false;
  bool _isEventCreated = false;

  // ignore: prefer_typing_uninitialized_variables
  var _selectedAsset;
  var _lat;
  var _long;
  late String _currentCountry;

  _CreateAdhocEventState() {
    _presenter = CreateAdhocEventPresenter(this);
  }

  _getAssets() {
    CheckConnection().connectionState().then((value) {
      if (value!) {
        setState(() {
          _isApiProcess = true;
        });
        _presenter.getAssets();
      } else {
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _eventNameController.text = StringConstants().getDefaultEventName();
    });
    _getAssets();
    _getLocation();
  }
  @override
  void dispose() {
    super.dispose();
    _eventNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Loader(
        isCallInProgress: _isApiProcess,
        child: Dialog(
          //backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: _mainUI(),
        ));
  }

  Widget _mainUI() {
    return SizedBox(
      width: 500.0,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          CommonWidgets().popUpTopView(
            title: StringConstants.popHeading,
            onTapCloseButton: _onTapCloseButton,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: AppColors.whiteColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      const SizedBox(height: 24.0),
                      _eventName(),
                      // Address Field
                      _address(),
                      // City field
                      _city(),
                      // State field
                      _state(),
                      // ZipCode field
                      _zipCode(),
                      // Select Equipments Field
                      _dropDown(),
                      // Create Button
                      const SizedBox(height: 24.0),
                      _createButton(),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _eventName() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().textView(
              StringConstants.name,
              StyleConstants.customTextStyle(
                  fontSize: 14.0,
                  color: AppColors.textColor2,
                  fontFamily: FontConstants.montserratRegular)),
          const SizedBox(height: 5.0),
          TextField(
            controller: _eventNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: StringConstants.enterName,
              errorText:
                  _isValidEventName ? null : StringConstants.emptyEventName,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.denotiveColor4),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.denotiveColor4),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.denotiveColor4),
              ),
            ),
          ),
        ],
      );

  Widget _address() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            CommonWidgets().textView(
                StringConstants.address,
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: AppColors.textColor2,
                    fontFamily: FontConstants.montserratRegular)),
            const SizedBox(height: 5.0),
            GestureDetector(
              onTap: () {
                _googlePlaces();
              },
              child: TextField(
                scrollPhysics: const ScrollPhysics(),
                enabled: _zipCodeController.text.isEmpty ? true : false,
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: StringConstants.enterAddress,
                  errorStyle: const TextStyle(color: Colors.red),
                  errorText:
                      _isValidAddress ? null : StringConstants.emptyAddress,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor2),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor2),
                  ),
                ),
              ),
            )
          ]);

  Widget _city() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            CommonWidgets().textView(
                StringConstants.city,
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: AppColors.textColor2,
                    fontFamily: FontConstants.montserratRegular)),
            const SizedBox(height: 5.0),
            TextField(
              enabled: false,
              controller: _cityController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                enabled: _cityController.text.isEmpty ? true : false,
                hintText: StringConstants.enterCity,
                errorStyle: const TextStyle(color: Colors.red),
                errorText: _isValidCity ? null : StringConstants.emptyCity,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor2),
                ),
              ),
            )
          ]);

  Widget _state() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            CommonWidgets().textView(
                StringConstants.state,
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: AppColors.textColor2,
                    fontFamily: FontConstants.montserratRegular)),
            const SizedBox(height: 5.0),
            TextField(
              controller: _stateController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                enabled: _stateController.text.isEmpty ? true : false,
                hintText: StringConstants.enterState,
                errorStyle: const TextStyle(color: Colors.red),
                errorText: _isValidState ? null : StringConstants.emptyState,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor2),
                ),
              ),
            )
          ]);

  Widget _zipCode() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            CommonWidgets().textView(
                StringConstants.zipCode,
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: AppColors.textColor2,
                    fontFamily: FontConstants.montserratRegular)),
            const SizedBox(height: 5.0),
            TextField(
              controller: _zipCodeController,
              enabled: _zipCodeController.text.isEmpty ? true : false,
              keyboardType: TextInputType.number,
              maxLength: 5,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: StringConstants.enterZipCode,
                counterText: "",
                errorStyle: const TextStyle(color: Colors.red),
                errorText: _isValidZipCode ? null : StringConstants.emptyZipCode,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.denotiveColor4),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.denotiveColor4),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.denotiveColor4),
                ),
              ),
            )
          ]);

  Widget _dropDown() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            CommonWidgets().textView(
                StringConstants.equipment,
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: AppColors.denotiveColor4,
                    fontFamily: FontConstants.montserratRegular)),
            const SizedBox(height: 5.0),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: _isAssetSelected
                            ? AppColors.denotiveColor4
                            : AppColors.textColor5,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _equipmentDropDown(),
/*                      const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.arrow_drop_down_sharp, size: 20.0),
                      )*/
                    ],
                  ),
                )),

            // Error Message
            Visibility(
              visible: !_isAssetSelected,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: CommonWidgets().textView(
                    StringConstants.selectEquipments,
                    StyleConstants.customTextStyle(
                        fontSize: 12.0,
                        color: AppColors.textColor5,
                        fontFamily: FontConstants.montserratRegular)),
              ),
            ),
          ]);

  Widget _equipmentDropDown() => DropdownButton(
        hint: const Text(StringConstants.selectEquipment),
        isDense: true,
        underline: Container(),
        iconSize: 20.0,
        menuMaxHeight: 300.0,
        items: assetList.map((item) {
          return DropdownMenuItem(
            child: SizedBox(
                //width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
              padding: const EdgeInsets.only(right: 230.0),
              child: Text(item.assetName!),
            )),
            value: item.id.toString(),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            _selectedAsset = newVal;
          });
        },
        value: _selectedAsset,
      );

  Widget _createButton() => GestureDetector(
        onTap: _onTapCreate,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40.0,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: AppColors.primaryColor2),
          child: Center(
              child: Text(
            StringConstants.create,
            style: StyleConstants.customTextStyle(
                fontSize: 16.0,
                color: AppColors.textColor1,
                fontFamily: FontConstants.montserratBold),
          )),
        ),
      );

  _onTapCreate() {
    CheckConnection().connectionState().then((value) {
      if (value!) {
        _validateData();
      } else {
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
      }
    });
  }

  _onTapCloseButton() {
    Navigator.of(context).pop(_isEventCreated);
  }

  @override
  void showAssetsError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showAssetsSuccess(response) {
    setState(() {
      _isApiProcess = false;
      AssetsResponseModel responseModel = response;
      assetList.addAll(responseModel.data!);
    });
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
    });
    //onTapCloseButton();
    CommonWidgets()
        .showErrorSnackBar(errorMessage: exception.message!, context: context);
  }

  @override
  void showSuccess(response) {
    CreateEventResponseModel responseModel = response;
    _updateDB();
    setState(() {
      _isApiProcess = false;
      _isEventCreated = true;
    });
    CommonWidgets().showSuccessSnackBar(
        message: responseModel.general![0].message ??
            StringConstants.eventCreatedSuccessfully,
        context: context);
    _onTapCloseButton();
  }

  _updateDB() async {
    await SessionDAO().insert(Session(
        key: DatabaseKeys.adhocEvent, value: Date.getTimeStampFromDate()));
  }

  _validateData() {
    setState(() {
      _isValidEventName = _eventNameController.text.isNotEmpty ? true : false;
      _isValidAddress = _addressController.text.isNotEmpty ? true : false;
      _isValidCity = _cityController.text.isNotEmpty ? true : false;
      _isValidState = _stateController.text.isNotEmpty ? true : false;
      _isValidZipCode = _zipCodeController.text.isNotEmpty ? true : false;
      _isAssetSelected = _selectedAsset != null ? true : false;
    });
    if (_eventNameController.text.isEmpty) {
      setState(() {
        _isValidEventName = false;
      });
      return false;
    }
    if (_addressController.text.isEmpty) {
      setState(() {
        _isValidAddress = false;
      });
      return false;
    }
    if (_cityController.text.isEmpty) {
      setState(() {
        _isValidCity = false;
      });
      return false;
    }
    if (_stateController.text.isEmpty) {
      setState(() {
        _isValidState = false;
      });
      return false;
    }
    if (_zipCodeController.text.isEmpty) {
      setState(() {
        _isValidZipCode = false;
      });
      return false;
    }
    if (_selectedAsset == null) {
      setState(() {
        _isAssetSelected = false;
      });
      return false;
    }
    _createEvent();
  }

  _createEvent() {
    CreateEventRequestModel createEventRequestModel = CreateEventRequestModel();
    createEventRequestModel.name = _eventNameController.text.toString();
    createEventRequestModel.addressLine1 = _addressController.text.toString();
    createEventRequestModel.addressLine2 = "";
    createEventRequestModel.city = _cityController.text.toString();
    createEventRequestModel.state = _stateController.text.toString();
    createEventRequestModel.zipCode = _zipCodeController.text.toString();
    createEventRequestModel.startDateTime = int.parse(Date.getTimeStamp());
    //int.parse(Date.getStartOfDateTimeStamp(date: DateTime.now()));
    createEventRequestModel.endDateTime =
        int.parse(Date.getEndOfDateTimeStamp(date: DateTime.now()));
    createEventRequestModel.addressLatitude = _lat;
    createEventRequestModel.addressLongitude = _long;
    createEventRequestModel.country = _currentCountry;
    EventAssetsList eventAssetsList = EventAssetsList();
    eventAssetsList.assetId = _selectedAsset;
    createEventRequestModel.eventAssetsList = [eventAssetsList];
    setState(() {
      _isApiProcess = true;
    });
    _presenter.createEvent(createEventRequestModel);
  }

  //get location using google places
  Future<void> _googlePlaces() async {
    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      strictbounds: false,
      context: context,
      apiKey: GoogleMapKey.googleMapKey,
      onError: onError,
      mode: Mode.overlay,
      radius: 10000000,
      //region: "US",
      language: Platform.localeName,
      decoration: InputDecoration(
        hintText: 'search address',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      sessionToken: Uuid().generateV4(),
      components: [
        Component(Component.country, "US"),
        Component(Component.country, "IN"),
        Component(Component.country, "CA"),
        Component(Component.country, "AT")
      ],
      types: [""],
      // types: ["(cities)"],
    );
    if (p != null) {
      _displayPrediction(p);
      setState(() {
        _isApiProcess = true;
      });
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    debugPrint(response.toString());
  }

  Future<void> _displayPrediction(Prediction p) async {
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: GoogleMapKey.googleMapKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId.toString());
    setState(() {
      _lat = detail.result.geometry!.location.lat;
      _long = detail.result.geometry!.location.lng;
    });
    debugPrint("Result ${detail.result.addressComponents[0].longName}");

    debugPrint(
        "Picked lat and long : ${detail.result.geometry!.location.lat} & ${detail.result.geometry!.location.lng}");
    debugPrint("Picked location: ${detail.result.formattedAddress}");
    _buildAddComponents(detail);
    setState(() {
      _isApiProcess = false;
    });
  }

  void _buildAddComponents(PlacesDetailsResponse detail) {
    for (int i = 0; i < detail.result.addressComponents.length; i++) {
      try {
        for (int j = 0;
            j < detail.result.addressComponents[i].types.length;
            i++) {
          if (detail.result.addressComponents[i].types[j] == "route") {
            setState(() {
              String route = detail.result.addressComponents[i].longName;
              debugPrint("route: $route");
            });
          }
          if (detail.result.addressComponents[i].types[j] == "locality") {
            setState(() {
              _cityController.text = detail.result.addressComponents[i].longName;
            });
            debugPrint("city: $_selectedCity");

            //Split the string to show in address
            const start = "";
            final end = _cityController.text;
            debugPrint("trimmedEnd======>: $end");
            final startIndex = detail.result.formattedAddress!.indexOf(start);
            final endIndex = detail.result.formattedAddress!.indexOf(end);
            final result = detail.result.formattedAddress!
                .substring(startIndex + start.length, endIndex)
                .trim();
            setState(() {
              String strFinal = result.substring(0, result.length - 1);
              _addressController.text = strFinal;
              debugPrint("trimmed======>: $strFinal");
            });
          }
          if (detail.result.addressComponents[i].types[j] ==
              "administrative_area_level_1") {
            setState(() {
              _stateController.text =
                  detail.result.addressComponents[i].longName;
            });

            debugPrint("state: $_selectedState");
          }
          if (detail.result.addressComponents[i].types[j] == "postal_code") {
            setState(() {
              _zipCodeController.text =
                  detail.result.addressComponents[i].longName;
            });
          }
          if (detail.result.addressComponents[i].types[j] == "country") {
            setState(() {
              _currentCountry = detail.result.addressComponents[i].longName;
              debugPrint("country: $_currentCountry");
            });
          }
        }
      } on RangeError catch (e) {
        debugPrint(e.toString());
      } catch (e) {
      }
    }
  }

  _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
      debugPrint("Location services are disabled.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    debugPrint("Get current location call");
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            forceAndroidLocationManager: true)
        .then((Position position) {
      debugPrint("Position $position");
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
        getAddressFromLatLng(
            context, _currentPosition.latitude, _currentPosition.longitude);
      });
    }).catchError((e) {
      debugPrint("Catch error $e");
    });
  }

  _getAddressFromLatLng() async {
    debugPrint("Get Address call");
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = placeMarks[0];
      debugPrint("Place data $place");
      _cityController.text = place.locality!;
      _addressController.text = place.street! + place.subLocality!;
      _stateController.text = place.administrativeArea!;
      _zipCodeController.text = place.postalCode!;
      setState(() {
        _currentCountry = place.country!;
      });
      debugPrint(place.country);
      debugPrint(place.locality);
      debugPrint(place.subLocality);
      debugPrint(place.administrativeArea);
      debugPrint(place.postalCode);
      debugPrint(place.name);
      debugPrint(place.street);
    } catch (e) {
      debugPrint("$e");
    }
  }
}

getAddressFromLatLng(context, double lat, double lng) async {
  String _host = 'https://maps.google.com/maps/api/geocode/json';
  final url =
      '$_host?key=${GoogleMapKey.googleMapKey}&language=en&latlng=$lat,$lng';
  if (lat != null && lng != null) {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      String _formattedAddress = data["results"][0]["formatted_address"];
      print("response ==== $data");
      debugPrint('URL===>$url');
      debugPrint(data["results"][0]["address_components"][6]['long_name']);
      return _formattedAddress;
    } else
      return null;
  } else
    return null;
}
