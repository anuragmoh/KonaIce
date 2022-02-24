import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/user/user_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile_model/my_profile_request_model.dart';
import 'package:kona_ice_pos/screens/my_profile/my_profile_model/my_profile_response_model.dart';
import 'package:kona_ice_pos/utils/bottom_bar.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/function_utils.dart';
import 'package:kona_ice_pos/utils/loader.dart';
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
  bool editMode = false;
  var userName = 'Guest';
  String emailValidationMessage = "";
  String firstNameValidationMessage = "";
  String lastNameValidationMessage = "";
  String contactNumberValidationMessage = "";
  String passwordValidationMessage = "";
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
    debugPrint('UserID$userID');
    userPresenter.getMyProfile(userID);
  }

  @override
  void initState() {
    super.initState();
    getMyProfileDetails();
    // getUserDetails();
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
            changeProfileButtons(),
            SizedBox(
              height: 4.88 * SizeConfig.heightSizeMultiplier,
            ),
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
    print('mode$editMode');
    /* showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopupDialog(context),
    );*/
  }

  onTapCancel() {
    setState(() {
      editMode = false;
    });

    print(editMode);
  }

  onTapSaveProfile() async {
    setState(() {
      editMode = false;
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
    userPresenter.updateProfile(userID, myProfileUpdateRequestModel);
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
            padding: const EdgeInsets.only(left: 23.0, top: 15.0),
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
              Padding(
                padding: const EdgeInsets.only(left: 23.0, top: 15.0),
                child: CommonWidgets().buttonWidgetUnFilled(
                  StringConstants.cancel,
                  onTapCancel,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, top: 15.0),
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

  Widget bodyWidget() =>
      Container(
        color: getMaterialColor(AppColors.textColor3).withOpacity(0.1),
        child: SingleChildScrollView(child: bodyWidgetComponent()),
      );

  Widget bodyWidgetComponent() =>
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 23.0, vertical: 28.0),
              child: CommonWidgets().textWidget(
                  StringConstants.myProfile,
                  StyleConstants.customTextStyle(
                      fontSize: 22.0,
                      color: getMaterialColor(AppColors.textColor1),
                      fontFamily: FontConstants.montserratBold),
                  textAlign: TextAlign.start),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 23.0, vertical: 29.0),
              child: CommonWidgets().profileImage(userName),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 25.0, horizontal: 24.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      profileDetailsComponent(
                          StringConstants.firstName,
                          "",
                          StringConstants.enterFirstName,
                          firstNameController,
                          firstNameValidationMessage,firstNameValidation),
                    ],
                  ),
                  profileDetailsComponent(
                      StringConstants.lastName,
                      "",
                      StringConstants.enterLastName,
                      lastNameController,
                      lastNameValidationMessage,lastNameValidation),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Row(
                children: [
                  profileDetailsComponent(
                      StringConstants.contactNumber,
                      "",
                      StringConstants.enterContactNumber,
                      contactNumberController,
                      contactNumberValidationMessage,phoneNumberValidation),
                  profileEmailTextFiledComponent(StringConstants.emailId, "",
                      StringConstants.enterEmailId, emailIdController),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Row(
                children: [
                  profileDetailsComponent(
                      StringConstants.password,
                      "",
                      StringConstants.enterContactNumber,
                      newPasswordController,
                      passwordValidationMessage,passwordValidation),
                ],
              ),
            )
          ]);

  Widget profileDetailsComponent(String txtName,
      String txtValue,
      String txtHint,
      TextEditingController textEditingController,
      String validationMessage, Function validationMethod) =>
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
                      fillColor: AppColors.whiteColor,
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

  Widget profileEmailTextFiledComponent(String txtName, String txtValue,
      String txtHint, TextEditingController textEditingController) =>
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
                  color: AppColors.whiteColor,
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
                          fillColor: AppColors.whiteColor,
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
        firstNameValidationMessage = "Please Enter First Name";
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
        lastNameValidationMessage = "Please Enter Last Name";
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
        contactNumberValidationMessage = "Please Enter Contact Number";
      });
      return false;
    } else {
      setState(() {
        contactNumberValidationMessage = "";
      });

      return true;
    }
  }

  passwordValidation() {
    if (newPasswordController.text.isEmpty) {
      setState(() {
        passwordValidationMessage = "Please Enter Password";
      });
      return false;
    } else {
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
        isApiProcess = false;
        getMyProfile.add(response);
        getUserDetails();
      });
    } else {}
  }

  getUserDetails() {
    firstNameController.text = getMyProfile[0].firstName.toString();
    lastNameController.text = getMyProfile[0].lastName.toString();
    contactNumberController.text = getMyProfile[0].phoneNum.toString();
    emailIdController.text = getMyProfile[0].email.toString();
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
