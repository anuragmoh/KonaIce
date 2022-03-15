import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/create_adhoc_event/create_adhoc_event_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/home/assest_model.dart';
import 'package:kona_ice_pos/screens/home/create_event_model.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/date_formats.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CreateAdhocEvent extends StatefulWidget {
  const CreateAdhocEvent({Key? key}) : super(key: key);

  @override
  State<CreateAdhocEvent> createState() => _CreateAdhocEventState();
}

class _CreateAdhocEventState extends State<CreateAdhocEvent>
    implements AssetsResponseContractor {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  bool isValidEventName = true,
      isValidAddress = true,
      isValidCity = true,
      isValidZipCode = true,
      isValidState = true,
      isAssetSelected = true;

  List<Datum> assetList = [];

  late CreateAdhocEventPresenter presenter;
  bool isApiProcess = false;
  bool isEventCreated = false;

  // ignore: prefer_typing_uninitialized_variables
  var _selectedAsset;

  late Position _currentPosition;
  late String _currentCountry;

  _CreateAdhocEventState() {
    presenter = CreateAdhocEventPresenter(this);
  }

  getAssets() {
    CheckConnection().connectionState().then((value) {
      if (value!) {
        setState(() {
          isApiProcess = true;
        });
        presenter.getAssets();
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
    getAssets();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
        isCallInProgress: isApiProcess,
        child: Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: mainUI(),
        ));
  }

  Widget mainUI() {
    return SizedBox(
      width: 500.0,
      child: Column(
        children: [
          CommonWidgets().popUpTopView(
            title: StringConstants.popHeading,
            onTapCloseButton: onTapCloseButton,
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
                      eventName(),
                      // Address Field
                      address(),
                      // City field
                      city(),
                      // State field
                      state(),
                      // ZipCode field
                      zipCode(),
                      // Select Equipments Field
                      dropDown(),
                      // Create Button
                      const SizedBox(height: 24.0),
                      createButton(),
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

  Widget eventName() => Column(
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
            controller: eventNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: StringConstants.enterName,
              errorText:
                  isValidEventName ? null : StringConstants.emptyEventName,
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
        ],
      );

  Widget address() => Column(
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
            TextField(
              controller: addressController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: StringConstants.enterAddress,
                errorText: isValidAddress ? null : StringConstants.emptyAddress,
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

  Widget city() => Column(
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
              controller: cityController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: StringConstants.enterCity,
                errorText: isValidCity ? null : StringConstants.emptyCity,
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

  Widget state() => Column(
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
              controller: stateController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: StringConstants.enterState,
                errorText: isValidState ? null : StringConstants.emptyState,
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

  Widget zipCode() => Column(
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
              controller: zipCodeController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                hintText: StringConstants.enterZipCode,
                errorText: isValidZipCode ? null : StringConstants.emptyZipCode,
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

  Widget dropDown() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            CommonWidgets().textView(
                StringConstants.equipment,
                StyleConstants.customTextStyle(
                    fontSize: 14.0,
                    color: AppColors.textColor2,
                    fontFamily: FontConstants.montserratRegular)),
            const SizedBox(height: 5.0),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isAssetSelected
                            ? AppColors.textColor2
                            : AppColors.textColor5,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      equipmentDropDown(),
                      const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.arrow_drop_down_sharp, size: 20.0),
                      )
                    ],
                  ),
                )),

            // Error Message
            Visibility(
              visible: !isAssetSelected,
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

  Widget equipmentDropDown() => DropdownButton(
        hint: const Text(StringConstants.selectEquipment),
        underline: Container(),
        iconSize: 0.0,
        menuMaxHeight: 300.0,
        items: assetList.map((item) {
          return DropdownMenuItem(
            child: SizedBox(
                //width: MediaQuery.of(context).size.width * 0.35,
                child: Text(item.assetName!)),
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

  Widget createButton() => GestureDetector(
        onTap: onTapCreate,
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

  onTapCreate() {
    CheckConnection().connectionState().then((value) {
      if (value!) {
        validateData();
      } else {
        CommonWidgets().showErrorSnackBar(
            errorMessage: StringConstants.noInternetConnection,
            context: context);
      }
    });
  }

  onTapCloseButton() {
    Navigator.of(context).pop(isEventCreated);
  }

  @override
  void showAssetsError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showAssetsSuccess(response) {
    setState(() {
      isApiProcess = false;
      AssetsResponseModel responseModel = response;
      assetList.addAll(responseModel.data!);
    });
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
    });
    CommonWidgets().showErrorSnackBar(
        errorMessage: exception.message ?? StringConstants.somethingWentWrong,
        context: context);
  }

  @override
  void showSuccess(response) {
    CreateEventResponseModel responseModel = response;
    setState(() {
      isApiProcess = false;
      isEventCreated = true;
    });
    CommonWidgets().showSuccessSnackBar(
        message: responseModel.general![0].message ??
            StringConstants.eventCreatedSuccessfully,
        context: context);
    onTapCloseButton();
  }

  validateData() {
    setState(() {
      isValidEventName = eventNameController.text.isNotEmpty ? true : false;
      isValidAddress = addressController.text.isNotEmpty ? true : false;
      isValidCity = cityController.text.isNotEmpty ? true : false;
      isValidState = stateController.text.isNotEmpty ? true : false;
      isValidZipCode = zipCodeController.text.isNotEmpty ? true : false;
      isAssetSelected = _selectedAsset != null ? true : false;
    });
    if (eventNameController.text.isEmpty) {
      setState(() {
        isValidEventName = false;
      });
      return false;
    }
    if (addressController.text.isEmpty) {
      setState(() {
        isValidAddress = false;
      });
      return false;
    }
    if (cityController.text.isEmpty) {
      setState(() {
        isValidCity = false;
      });
      return false;
    }
    if (stateController.text.isEmpty) {
      setState(() {
        isValidState = false;
      });
      return false;
    }
    if (zipCodeController.text.isEmpty) {
      setState(() {
        isValidZipCode = false;
      });
      return false;
    }
    if (_selectedAsset == null) {
      setState(() {
        isAssetSelected = false;
      });
      return false;
    }
    createEvent();
  }

  createEvent() {
    CreateEventRequestModel createEventRequestModel = CreateEventRequestModel();
    createEventRequestModel.name = eventNameController.text.toString();
    createEventRequestModel.addressLine1 = addressController.text.toString();
    createEventRequestModel.addressLine2 = "";
    createEventRequestModel.city = cityController.text.toString();
    createEventRequestModel.state = stateController.text.toString();
    createEventRequestModel.zipCode = zipCodeController.text.toString();
    createEventRequestModel.startDateTime =
        int.parse(Date.getStartOfDateTimeStamp(date: DateTime.now()));
    createEventRequestModel.endDateTime =
        int.parse(Date.getEndOfDateTimeStamp(date: DateTime.now()));
    createEventRequestModel.addressLatitude = _currentPosition.latitude;
    createEventRequestModel.addressLongitude = _currentPosition.longitude;
    createEventRequestModel.country = _currentCountry;
    EventAssetsList eventAssetsList = EventAssetsList();
    eventAssetsList.assetId = _selectedAsset;
    createEventRequestModel.eventAssetsList = [eventAssetsList];
    setState(() {
      isApiProcess = true;
    });
    presenter.createEvent(createEventRequestModel);
  }

  _determinePosition() async {
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
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = placeMarks[0];
      setState(() {
        _currentCountry = "${place.country}";
      });
    } catch (e) {
      debugPrint("$e");
    }
  }
}
