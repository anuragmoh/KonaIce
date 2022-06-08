import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/models/network_model/my_profile_model/my_profile_request_model.dart';
import 'package:kona_ice_pos/models/network_model/my_profile_model/my_profile_response_model.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/user/user_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/utils/ServiceNotifier.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> implements ResponseContractor {
  int _currentIndex = 0;
  bool _isApiProcess = false;
  bool _isPasswordVisible = true;
  bool _editMode = false;
  var _userName = '';
  String _emailValidationMessage = "",
      _firstNameValidationMessage = "",
      _lastNameValidationMessage = "",
      _contactNumberValidationMessage = "",
      _passwordValidationMessage = "";
  bool _isEmailValid = true;
  bool _isFirstNameValid = true;
  bool _isLastNameValid = true;
  bool _isContactValid = true;
  bool _isPasswordValid = true;

  MyProfileUpdateRequestModel _myProfileUpdateRequestModel =
      MyProfileUpdateRequestModel();
  late UserPresenter _userPresenter;
  List<MyProfileResponseModel> _getMyProfile = [];

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  _MyProfileState() {
    _userPresenter = UserPresenter(this);
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactNumberController.dispose();
    _emailIdController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  _getMyProfileDetails() async {
    String userID = await FunctionalUtils.getUserID();

    CheckConnection().connectionState().then((value) {
      if (value == true) {
        setState(() {
          _isApiProcess = true;
        });
        _userPresenter.getMyProfile(userID);
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
    _getMyProfileDetails();
    ServiceNotifier().increment(2);
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);

    // getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: _isApiProcess, child: _mainUi(context));
  }

  Widget _mainUi(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.textColor3.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonWidgets().dashboardTopBar(_topBarComponent()),
            Expanded(child: _bodyWidget()),
            BottomBarWidget(
              onTapCallBack: _onTapBottomListItem,
              accountImageVisibility: false,
              isFromDashboard: false,
            )
          ],
        ),
      ),
    );
  }

  _onTapBottomListItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _onTapChangePassword() {
    setState(() {
      if (_editMode == false) {
        _editMode = true;
      } else {
        _editMode = false;
      }
    });
  }

  _onTapCancel() {
    setState(() {
      _editMode = false;
    });
  }

  _onTapSaveProfile() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _setBoolVars();
    });
    _getMyProfileDetailsToUpdate();
    String userID = await FunctionalUtils.getUserID();

    _callUpdateProfile(userID);
  }

  void _setBoolVars() {
    _emailIdController.text.isEmpty ? _isEmailValid = false : _isEmailValid = true;
    _newPasswordController.text.isEmpty
        ? _isPasswordValid = false
        : _isPasswordValid = true;
    _firstNameController.text.isEmpty
        ? _isFirstNameValid = false
        : _isFirstNameValid = true;
    _lastNameController.text.isEmpty
        ? _isLastNameValid = false
        : _isLastNameValid = true;
    _contactNumberController.text.isEmpty
        ? _isContactValid = false
        : _isContactValid = true;
  }

  void _getMyProfileDetailsToUpdate() {
    _myProfileUpdateRequestModel.firstName = _firstNameController.text.toString();
    _myProfileUpdateRequestModel.lastName = _lastNameController.text.toString();
    _myProfileUpdateRequestModel.email = _emailIdController.text.toString();
    _myProfileUpdateRequestModel.phoneNum =
        _contactNumberController.text.toString();
    _myProfileUpdateRequestModel.numCountryCode =
        _getMyProfile[0].numCountryCode.toString();
    _myProfileUpdateRequestModel.password =
        _newPasswordController.text.toString();
    _myProfileUpdateRequestModel.franchiseName =
        _getMyProfile[0].franchiseName.toString();
    _myProfileUpdateRequestModel.franchiseEmail =
        _getMyProfile[0].franchiseEmail.toString();
    _myProfileUpdateRequestModel.franchisePhoneNumber =
        _getMyProfile[0].franchisePhoneNumber.toString();
    _myProfileUpdateRequestModel.franchisePhoneNumCountryCode =
        _getMyProfile[0].franchisePhoneNumCountryCode.toString();
    _myProfileUpdateRequestModel.profileImageFileId = "";
    _myProfileUpdateRequestModel.defaultTimezone =
        _getMyProfile[0].defaultTimezone.toString();
  }

  void _callUpdateProfile(String userID) {
    if (_isEmailValid && _isFirstNameValid && _isLastNameValid && _isContactValid) {
      CheckConnection().connectionState().then((value) {
        if (value == true) {
          _isApiProcess = true;
          _editMode = false;
          _userPresenter.updateProfile(userID, _myProfileUpdateRequestModel);
        } else {
          CommonWidgets().showErrorSnackBar(
              errorMessage: StringConstants.noInternetConnection,
              context: context);
        }
      });
    }
  }

  Widget _topBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0, right: 22.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _konaTopBarIcon(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: CommonWidgets().textWidget(
                  StringConstants.dashboard,
                  StyleConstants.customTextStyle16MontserratBold(
                      color: AppColors.whiteColor)),
            ),
          ),
          CommonWidgets().profileComponent(_userName),
        ],
      ),
    );
  }

  Widget _konaTopBarIcon() {
    return CommonWidgets().image(
        image: AssetsConstants.topBarAppIcon,
        width: 4.03 * SizeConfig.imageSizeMultiplier,
        height: 4.03 * SizeConfig.imageSizeMultiplier);
  }

  Widget _changeProfileButtons() {
    return Row(
      children: [
        Visibility(
          visible: _editMode ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CommonWidgets().buttonWidget(
              StringConstants.edit,
              _onTapChangePassword,
            ),
          ),
        ),
        _buildVisibility(),
      ],
    );
  }

  Visibility _buildVisibility() {
    return Visibility(
      visible: _editMode ? true : false,
      child: Row(
        children: [
          CommonWidgets().buttonWidgetUnFilled(
            StringConstants.cancelProfile,
            _onTapCancel,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23.0),
            child: CommonWidgets().buttonWidget(
              StringConstants.save,
              _onTapSaveProfile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() => Container(
        color: AppColors.textColor3.withOpacity(0.1),
        child: SingleChildScrollView(child: _bodyWidgetComponent()),
      );

  Widget _bodyWidgetComponent() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 28.0),
            _buildPadding(),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: CommonWidgets().profileImage(_userName, _editMode),
            ),
            const SizedBox(height: 33.0),
            _buildPadding2(),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: Row(
                children: [
                  _profileDetailsComponent(
                      StringConstants.contactNumber,
                      "",
                      StringConstants.enterContactNumber,
                      _contactNumberController,
                      _contactNumberValidationMessage,
                      _phoneNumberValidation,
                      _editMode),
                  _profileEmailTextFiledComponent(
                      StringConstants.emailId,
                      "",
                      StringConstants.enterEmailId,
                      _emailIdController,
                      _editMode),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            _buildPadding3(),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: _changeProfileButtons(),
            ),
            const SizedBox(
              height: 340.0,
            ),
          ]);

  Padding _buildPadding3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0),
      child: Row(
        children: [
          _profilePasswordDetailsComponent(
              StringConstants.password,
              "",
              StringConstants.password,
              _newPasswordController,
              _passwordValidationMessage,
              _passwordValidation,
              _editMode),
        ],
      ),
    );
  }

  Padding _buildPadding2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0),
      child: Row(
        children: [
          Column(
            children: [
              _profileDetailsComponent(
                  StringConstants.firstName,
                  "",
                  StringConstants.enterFirstName,
                  _firstNameController,
                  _firstNameValidationMessage,
                  _firstNameValidation,
                  _editMode),
            ],
          ),
          _profileDetailsComponent(
              StringConstants.lastName,
              "",
              StringConstants.enterLastName,
              _lastNameController,
              _lastNameValidationMessage,
              _lastNameValidation,
              _editMode),
        ],
      ),
    );
  }

  Padding _buildPadding() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0),
      child: CommonWidgets().textWidget(
          StringConstants.myProfile,
          StyleConstants.customTextStyle22MontserratBold(
              color: AppColors.textColor1),
          textAlign: TextAlign.start),
    );
  }

  Widget _profileDetailsComponent(
          String txtName,
          String txtValue,
          String txtHint,
          TextEditingController textEditingController,
          String validationMessage,
          Function validationMethod,
          bool textFiledColor) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().textWidget(
              txtName,
              StyleConstants.customTextStyle14MonsterRegular(
                  color: AppColors.textColor1),
              textAlign: TextAlign.left),
          _buildEditModePadding(validationMethod, textEditingController,
              textFiledColor, txtHint, txtValue),
          Text(validationMessage,
              style: StyleConstants.customTextStyle12MonsterRegular(
                  color: AppColors.textColor5),
              textAlign: TextAlign.left)
        ],
      );

  Padding _buildEditModePadding(
      Function validationMethod,
      TextEditingController textEditingController,
      bool textFiledColor,
      String txtHint,
      String txtValue) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
      child: Container(
        height: 40.0,
        width: 300.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
                color: AppColors.textColor1.withOpacity(0.2), width: 2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: TextField(
            onChanged: (value) {
              validationMethod();
            },
            enabled: _editMode ? true : false,
            controller: textEditingController,
            decoration: InputDecoration(
                filled: true,
                fillColor: textFiledColor
                    ? AppColors.whiteColor
                    : AppColors.denotiveColor5,
                hintText: txtHint,
                border: InputBorder.none,
                labelText: txtValue,
                hintStyle: StyleConstants.customTextStyle15MonsterRegular(
                    color: AppColors.textColor1)),
          ),
        ),
      ),
    );
  }

  Widget _profilePasswordDetailsComponent(
          String txtName,
          String txtValue,
          String txtHint,
          TextEditingController textEditingController,
          String validationMessage,
          Function validationMethod,
          bool textFiledColor) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().textWidget(
              txtName,
              StyleConstants.customTextStyle14MonsterRegular(
                  color: AppColors.textColor1),
              textAlign: TextAlign.left),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
            child: _buildContainer(validationMethod, textEditingController,
                textFiledColor, txtHint, txtValue),
          ),
          Visibility(
            visible: _editMode ? true : false,
            child: Text(validationMessage,
                style: StyleConstants.customTextStyle12MonsterRegular(
                    color: AppColors.textColor5),
                textAlign: TextAlign.left),
          )
        ],
      );

  Container _buildContainer(
      Function validationMethod,
      TextEditingController textEditingController,
      bool textFiledColor,
      String txtHint,
      String txtValue) {
    return Container(
      height: 40.0,
      width: 300.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
              color: AppColors.textColor1.withOpacity(0.2), width: 2)),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: _buildTextField(validationMethod, textEditingController,
            textFiledColor, txtHint, txtValue),
      ),
    );
  }

  TextField _buildTextField(
      Function validationMethod,
      TextEditingController textEditingController,
      bool textFiledColor,
      String txtHint,
      String txtValue) {
    return TextField(
      obscureText: _isPasswordVisible,
      onChanged: (value) {
        validationMethod();
      },
      enabled: _editMode ? true : false,
      controller: textEditingController,
      decoration: InputDecoration(
          suffixIcon: Visibility(
            visible: _editMode ? true : false,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: _isPasswordVisible
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility)),
          ),
          filled: true,
          fillColor:
              textFiledColor ? AppColors.whiteColor : AppColors.denotiveColor5,
          hintText: txtHint,
          border: InputBorder.none,
          labelText: txtValue,
          hintStyle: StyleConstants.customTextStyle15MonsterRegular(
              color: AppColors.textColor1)),
    );
  }

  Widget _profileEmailTextFiledComponent(
          String txtName,
          String txtValue,
          String txtHint,
          TextEditingController textEditingController,
          bool textFiledColor) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().textWidget(
              txtName,
              StyleConstants.customTextStyle14MonsterRegular(
                  color: AppColors.textColor1),
              textAlign: TextAlign.left),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
            child: Container(
              height: 40.0,
              width: 300.0,
              decoration: BoxDecoration(
                  color: textFiledColor
                      ? AppColors.whiteColor
                      : AppColors.denotiveColor5,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: AppColors.textColor1.withOpacity(0.2), width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                    stepWidth: 0,
                    child: TextField(
                      onChanged: (value) {
                        _emailValidation();
                      },
                      enabled: _editMode ? true : false,
                      controller: textEditingController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: textFiledColor
                              ? AppColors.whiteColor
                              : AppColors.denotiveColor5,
                          hintText: txtHint,
                          border: InputBorder.none,
                          labelText: txtValue,
                          hintStyle:
                              StyleConstants.customTextStyle15MonsterRegular(
                                  color: AppColors.textColor1)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(_emailValidationMessage,
              style: StyleConstants.customTextStyle12MonsterRegular(
                  color: AppColors.textColor5),
              textAlign: TextAlign.left)
        ],
      );

  _emailValidation() {
    if (_emailIdController.text.isEmpty) {
      setState(() {
        _emailValidationMessage = StringConstants.emptyValidEmail;
      });
      return false;
    }
    if (!_emailIdController.text.isValidEmail()) {
      setState(() {
        _emailValidationMessage = StringConstants.enterValidEmail;
      });
      return false;
    }
    if (_emailIdController.text.isValidEmail()) {
      setState(() {
        _emailValidationMessage = "";
      });
      return true;
    }
  }

  _firstNameValidation() {
    if (_firstNameController.text.isEmpty) {
      setState(() {
        _firstNameValidationMessage = StringConstants.emptyFirstName;
      });
      return false;
    } else {
      setState(() {
        _firstNameValidationMessage = "";
      });
      return true;
    }
  }

  _lastNameValidation() {
    if (_lastNameController.text.isEmpty) {
      setState(() {
        _lastNameValidationMessage = StringConstants.emptyLastName;
      });
      return false;
    } else {
      setState(() {
        _lastNameValidationMessage = "";
      });

      return true;
    }
  }

  _phoneNumberValidation() {
    if (_contactNumberController.text.isEmpty) {
      setState(() {
        _contactNumberValidationMessage = StringConstants.emptyContactNumber;
      });
      return false;
    } else {
      setState(() {
        _contactNumberValidationMessage = "";
      });

      return true;
    }
  }

  bool _validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~^%]).{7,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  _passwordValidation() {
    if (_newPasswordController.text.isEmpty) {
      setState(() {
        _passwordValidationMessage = "";
      });
      return false;
    }
    if (_newPasswordController.text.length < 7 ||
        _newPasswordController.text.length > 12) {
      setState(() {
        _passwordValidationMessage = StringConstants.enterValidPasswordLength;
      });
      return false;
    }
    if (!_validateStructure(_newPasswordController.text.toString())) {
      setState(() {
        _passwordValidationMessage = StringConstants.enterSpecialChar;
      });
      return false;
    }
    if (_newPasswordController.text.isValidPassword()) {
      setState(() {
        _passwordValidationMessage = "";
      });
      return true;
    }
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      _isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    if (response is MyProfileResponseModel) {
      setState(() {
        _getMyProfile.clear();
        _isApiProcess = false;
        _getMyProfile.add(response);
        _getUserDetails();
      });
    } else {
      setState(() {
        CommonWidgets().showSuccessSnackBar(
            message: StringConstants.profileUpdateSuccessfully,
            context: context);
        _editMode = false;
        _isApiProcess = false;
        if (_isPasswordVisible == false) {
          _isPasswordVisible = !_isPasswordVisible;
        }
      });
      _getMyProfileDetails();
    }
  }

  _getUserDetails() {
    _userName = _getMyProfile[0].firstName.toString() +
        " " +
        _getMyProfile[0].lastName.toString();
    _firstNameController.text = _getMyProfile[0].firstName.toString();
    _lastNameController.text = _getMyProfile[0].lastName.toString();
    _contactNumberController.text = _getMyProfile[0].phoneNum.toString();
    _emailIdController.text = _getMyProfile[0].email.toString();
    _storeValuesInDB(
        _getMyProfile[0].firstName.toString(),
        _getMyProfile[0].lastName.toString(),
        _getMyProfile[0].phoneNum.toString(),
        _getMyProfile[0].email.toString());
  }

  _storeValuesInDB(
      String firstName, String lastName, String contactNumber, String email) {
    SessionDAO().insert(Session(key: DatabaseKeys.firstName, value: firstName));
    SessionDAO().insert(Session(key: DatabaseKeys.lastName, value: lastName));
    SessionDAO().insert(Session(key: DatabaseKeys.email, value: email));
    SessionDAO()
        .insert(Session(key: DatabaseKeys.phoneNum, value: contactNumber));
  }
}
