import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
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
import 'package:kona_ice_pos/utils/utils.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> implements ResponseContractor {
  int currentIndex = 0;
  bool isApiProcess = false;
  bool isPasswordVisible = true;
  bool editMode = false;
  var userName = '';
  String emailValidationMessage = "";
  String firstNameValidationMessage = "";
  String lastNameValidationMessage = "";
  String contactNumberValidationMessage = "";
  String passwordValidationMessage = "";
  bool isEmailValid = true;
  bool isFirstNameValid = true;
  bool isLastNameValid = true;
  bool isContactValid = true;
  bool isPasswordValid = true;

  MyProfileUpdateRequestModel myProfileUpdateRequestModel =
      MyProfileUpdateRequestModel();
  late UserPresenter userPresenter;
  List<MyProfileResponseModel> getMyProfile = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  _MyProfileState() {
    userPresenter = UserPresenter(this);
  }

  getMyProfileDetails() async {
    String userID = await FunctionalUtils.getUserID();

    CheckConnection().connectionState().then((value) {
      if (value == true) {
        setState(() {
          isApiProcess = true;
        });
        userPresenter.getMyProfile(userID);
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
    getMyProfileDetails();
    ServiceNotifier().increment(2);
    P2PConnectionManager.shared.updateData(
        action: StaffActionConst.showSplashAtCustomerForHomeAndSettings);

    // getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    contactNumberController.dispose();
    emailIdController.dispose();
    newPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonWidgets().dashboardTopBar(topBarComponent()),
            Expanded(child: bodyWidget()),
/*            Padding(
              padding: const EdgeInsets.only(left: 23.0,top: 15.0),
              child: changeProfileButtons(),
            ),
            SizedBox(
              height: 4.88 * SizeConfig.heightSizeMultiplier,
            ),*/
            BottomBarWidget(
              onTapCallBack: onTapBottomListItem,
              accountImageVisibility: false,
              isFromDashboard: false,
            )
            // CommonWidgets().bottomBar(false),
          ],
        ),
      ),
    );
  }

  onTapBottomListItem(int index) {
    setState(() {
      currentIndex = index;
      print('profile$index');
    });
  }

  onTapChangePassword() {
    setState(() {
      if (editMode == false) {
        editMode = true;
      } else {
        editMode = false;
      }
    });
    /* showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopupDialog(context),
    );*/
  }

  onTapCancel() {
    setState(() {
      editMode = false;
    });
  }

  onTapSaveProfile() async {
    FocusScope.of(context).unfocus();
    setState(() {
      emailIdController.text.isEmpty
          ? isEmailValid = false
          : isEmailValid = true;
      newPasswordController.text.isEmpty
          ? isPasswordValid = false
          : isPasswordValid = true;
      firstNameController.text.isEmpty
          ? isFirstNameValid = false
          : isFirstNameValid = true;
      lastNameController.text.isEmpty
          ? isLastNameValid = false
          : isLastNameValid = true;
      contactNumberController.text.isEmpty
          ? isContactValid = false
          : isContactValid = true;
    });
    myProfileUpdateRequestModel.firstName = firstNameController.text.toString();
    myProfileUpdateRequestModel.lastName = lastNameController.text.toString();
    myProfileUpdateRequestModel.email = emailIdController.text.toString();
    myProfileUpdateRequestModel.phoneNum =
        contactNumberController.text.toString();
    myProfileUpdateRequestModel.numCountryCode =
        getMyProfile[0].numCountryCode.toString();
    myProfileUpdateRequestModel.password =
        newPasswordController.text.toString();
    myProfileUpdateRequestModel.franchiseName =
        getMyProfile[0].franchiseName.toString();
    myProfileUpdateRequestModel.franchiseEmail =
        getMyProfile[0].franchiseEmail.toString();
    myProfileUpdateRequestModel.franchisePhoneNumber =
        getMyProfile[0].franchisePhoneNumber.toString();
    myProfileUpdateRequestModel.franchisePhoneNumCountryCode =
        getMyProfile[0].franchisePhoneNumCountryCode.toString();
    myProfileUpdateRequestModel.profileImageFileId = "";
    myProfileUpdateRequestModel.defaultTimezone =
        getMyProfile[0].defaultTimezone.toString();
    String userID = await FunctionalUtils.getUserID();

    if (isEmailValid && isFirstNameValid && isLastNameValid && isContactValid) {
      CheckConnection().connectionState().then((value) {
        if (value == true) {
          isApiProcess = true;
          editMode = false;
          userPresenter.updateProfile(userID, myProfileUpdateRequestModel);
        } else {
          CommonWidgets().showErrorSnackBar(
              errorMessage: StringConstants.noInternetConnection,
              context: context);
        }
      });
    }
  }

  Widget topBarComponent() {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0, right: 22.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          konaTopBarIcon(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: CommonWidgets().textWidget(
                  StringConstants.dashboard,
                  StyleConstants.customTextStyle(
                      fontSize: 16.0,
                      color: getMaterialColor(AppColors.whiteColor),
                      fontFamily: FontConstants.montserratBold)),
            ),
          ),
          CommonWidgets().profileComponent(userName),
        ],
      ),
    );
  }

  Widget konaTopBarIcon() {
    return CommonWidgets().image(
        image: AssetsConstants.topBarAppIcon,
        width: 4.03 * SizeConfig.imageSizeMultiplier,
        height: 4.03 * SizeConfig.imageSizeMultiplier);
  }

  Widget changeProfileButtons() {
    return Row(
      children: [
        Visibility(
          visible: editMode ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CommonWidgets().buttonWidget(
              StringConstants.edit,
              onTapChangePassword,
            ),
          ),
        ),
        Visibility(
          visible: editMode ? true : false,
          child: Row(
            children: [
              CommonWidgets().buttonWidgetUnFilled(
                StringConstants.cancelProfile,
                onTapCancel,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0),
                child: CommonWidgets().buttonWidget(
                  StringConstants.save,
                  onTapSaveProfile,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bodyWidget() => Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
        child: SingleChildScrollView(child: bodyWidgetComponent()),
      );

  Widget bodyWidgetComponent() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 28.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: CommonWidgets().textWidget(
                  StringConstants.myProfile,
                  StyleConstants.customTextStyle(
                      fontSize: 22.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold),
                  textAlign: TextAlign.start),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: CommonWidgets().profileImage(userName, editMode),
            ),
            const SizedBox(height: 33.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      profileDetailsComponent(
                          StringConstants.firstName,
                          "",
                          StringConstants.enterFirstName,
                          firstNameController,
                          firstNameValidationMessage,
                          firstNameValidation,
                          editMode),
                    ],
                  ),
                  profileDetailsComponent(
                      StringConstants.lastName,
                      "",
                      StringConstants.enterLastName,
                      lastNameController,
                      lastNameValidationMessage,
                      lastNameValidation,
                      editMode),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: Row(
                children: [
                  profileDetailsComponent(
                      StringConstants.contactNumber,
                      "",
                      StringConstants.enterContactNumber,
                      contactNumberController,
                      contactNumberValidationMessage,
                      phoneNumberValidation,
                      editMode),
                  profileEmailTextFiledComponent(
                      StringConstants.emailId,
                      "",
                      StringConstants.enterEmailId,
                      emailIdController,
                      editMode),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: Row(
                children: [
                  profilePasswordDetailsComponent(
                      StringConstants.password,
                      "",
                      StringConstants.password,
                      newPasswordController,
                      passwordValidationMessage,
                      passwordValidation,
                      editMode),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: changeProfileButtons(),
            ),
            const SizedBox(
              height: 340.0,
            ),
          ]);

  Widget profileDetailsComponent(
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
              StyleConstants.customTextStyle(
                  fontSize: 14.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
            child: Container(
              height: 40.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  onChanged: (value) {
                    validationMethod();
                  },
                  enabled: editMode ? true : false,
                  controller: textEditingController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: textFiledColor
                          ? AppColors.whiteColor
                          : AppColors.denotiveColor5,
                      hintText: txtHint,
                      border: InputBorder.none,
                      labelText: txtValue,
                      hintStyle: StyleConstants.customTextStyle(
                          fontSize: 15.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratRegular)),
                ),
              ),
            ),
          ),
          Text(validationMessage,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor5),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left)
        ],
      );

  Widget profilePasswordDetailsComponent(
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
              StyleConstants.customTextStyle(
                  fontSize: 14.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 0.0, right: 22.0),
            child: Container(
              height: 40.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: TextField(
                  obscureText: isPasswordVisible,
                  onChanged: (value) {
                    validationMethod();
                  },
                  enabled: editMode ? true : false,
                  controller: textEditingController,
                  decoration: InputDecoration(
                      suffixIcon: Visibility(
                        visible: editMode ? true : false,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: isPasswordVisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility)),
                      ),
                      filled: true,
                      fillColor: textFiledColor
                          ? AppColors.whiteColor
                          : AppColors.denotiveColor5,
                      hintText: txtHint,
                      border: InputBorder.none,
                      labelText: txtValue,
                      hintStyle: StyleConstants.customTextStyle(
                          fontSize: 15.0,
                          color: getMaterialColor(AppColors.textColor1),
                          fontFamily: FontConstants.montserratRegular)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: editMode ? true : false,
            child: Text(validationMessage,
                style: StyleConstants.customTextStyle(
                    fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor5),
                    fontFamily: FontConstants.montserratRegular),
                textAlign: TextAlign.left),
          )
        ],
      );

  Widget profileEmailTextFiledComponent(
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
              StyleConstants.customTextStyle(
                  fontSize: 14.0,
                  color: getMaterialColor(AppColors.textColor1),
                  fontFamily: FontConstants.montserratRegular),
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
                      color: getMaterialColor(AppColors.textColor1)
                          .withOpacity(0.2),
                      width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                    stepWidth: 0,
                    child: TextField(
                      onChanged: (value) {
                        emailValidation();
                      },
                      enabled: editMode ? true : false,
                      controller: textEditingController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: textFiledColor
                              ? AppColors.whiteColor
                              : AppColors.denotiveColor5,
                          hintText: txtHint,
                          border: InputBorder.none,
                          labelText: txtValue,
                          hintStyle: StyleConstants.customTextStyle(
                              fontSize: 15.0,
                              color: getMaterialColor(AppColors.textColor1),
                              fontFamily: FontConstants.montserratRegular)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(emailValidationMessage,
              style: StyleConstants.customTextStyle(
                  fontSize: 12.0,
                  color: getMaterialColor(AppColors.textColor5),
                  fontFamily: FontConstants.montserratRegular),
              textAlign: TextAlign.left)
        ],
      );

  emailValidation() {
    if (emailIdController.text.isEmpty) {
      setState(() {
        emailValidationMessage = StringConstants.emptyValidEmail;
      });
      return false;
    }
    if (!emailIdController.text.isValidEmail()) {
      setState(() {
        emailValidationMessage = StringConstants.enterValidEmail;
      });
      return false;
    }
    if (emailIdController.text.isValidEmail()) {
      setState(() {
        emailValidationMessage = "";
      });
      return true;
    }
  }

  firstNameValidation() {
    if (firstNameController.text.isEmpty) {
      setState(() {
        firstNameValidationMessage = StringConstants.emptyFirstName;
      });
      return false;
    } else {
      setState(() {
        firstNameValidationMessage = "";
      });
      return true;
    }
  }

  lastNameValidation() {
    if (lastNameController.text.isEmpty) {
      setState(() {
        lastNameValidationMessage = StringConstants.emptyLastName;
      });
      return false;
    } else {
      setState(() {
        lastNameValidationMessage = "";
      });

      return true;
    }
  }

  phoneNumberValidation() {
    if (contactNumberController.text.isEmpty) {
      setState(() {
        contactNumberValidationMessage = StringConstants.emptyContactNumber;
      });
      return false;
    } else {
      setState(() {
        contactNumberValidationMessage = "";
      });

      return true;
    }
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~^%]).{7,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  passwordValidation() {
    if (newPasswordController.text.isEmpty) {
      setState(() {
        passwordValidationMessage = "";
      });
      return false;
    }
    if (newPasswordController.text.length < 7 ||
        newPasswordController.text.length > 12) {
      setState(() {
        passwordValidationMessage = StringConstants.enterValidPasswordLength;
      });
      return false;
    }
    if (!validateStructure(newPasswordController.text.toString())) {
      setState(() {
        passwordValidationMessage = StringConstants.enterSpecialChar;
      });
      return false;
    }
    if (newPasswordController.text.isValidPassword()) {
      setState(() {
        passwordValidationMessage = "";
      });
      return true;
    }
  }

  @override
  void showError(GeneralErrorResponse exception) {
    setState(() {
      isApiProcess = false;
      CommonWidgets().showErrorSnackBar(
          errorMessage: exception.message ?? StringConstants.somethingWentWrong,
          context: context);
    });
  }

  @override
  void showSuccess(response) {
    if (response is MyProfileResponseModel) {
      setState(() {
        getMyProfile.clear();
        isApiProcess = false;
        getMyProfile.add(response);
        getUserDetails();
      });
    } else {
      setState(() {
        CommonWidgets().showSuccessSnackBar(
            message: StringConstants.profileUpdateSuccessfully,
            context: context);
        editMode = false;
        isApiProcess = false;
        if (isPasswordVisible == false) {
          isPasswordVisible = !isPasswordVisible;
        }
      });
      getMyProfileDetails();
    }
  }

  getUserDetails() {
    userName = getMyProfile[0].firstName.toString() +
        " " +
        getMyProfile[0].lastName.toString();
    firstNameController.text = getMyProfile[0].firstName.toString();
    lastNameController.text = getMyProfile[0].lastName.toString();
    contactNumberController.text = getMyProfile[0].phoneNum.toString();
    emailIdController.text = getMyProfile[0].email.toString();
    storeValuesInDB(
        getMyProfile[0].firstName.toString(),
        getMyProfile[0].lastName.toString(),
        getMyProfile[0].phoneNum.toString(),
        getMyProfile[0].email.toString());
  }

  storeValuesInDB(
      String firstName, String lastName, String contactNumber, String email) {
    SessionDAO().insert(Session(key: DatabaseKeys.firstName, value: firstName));
    SessionDAO().insert(Session(key: DatabaseKeys.lastName, value: lastName));
    SessionDAO().insert(Session(key: DatabaseKeys.email, value: email));
    SessionDAO()
        .insert(Session(key: DatabaseKeys.phoneNum, value: contactNumber));
  }
/*  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: CommonWidgets().textWidget(
          StringConstants.changePassword,
          StyleConstants.customTextStyle(
              fontSize: 22.0,
              color: getMaterialColor(AppColors.textColor1),
              fontFamily: FontConstants.montserratSemiBold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
              child: profileDetailsComponent(StringConstants.oldPassword, "",
                  StringConstants.oldPassword, oldPasswordController),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
              child: profileDetailsComponent(StringConstants.newPassword, "",
                  StringConstants.newPassword, newPasswordController),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 23.0, right: 23.0, bottom: 10.0),
              child: profileDetailsComponent(
                  StringConstants.confirmPassword,
                  "",
                  StringConstants.confirmPassword,
                  confirmPasswordController),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 23.0,
                    vertical: 3.90 * SizeConfig.heightSizeMultiplier),
                child: CommonWidgets().buttonWidget(
                  StringConstants.submit,
                  onTapSubmitChangePassword,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  onTapSubmitChangePassword() {
    Navigator.pop(context);
  }*/
}
