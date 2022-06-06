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
  String emailValidationMessage = "",
      firstNameValidationMessage = "",
      lastNameValidationMessage = "",
      contactNumberValidationMessage = "",
      passwordValidationMessage = "";
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

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    contactNumberController.dispose();
    emailIdController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
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
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: mainUi(context));
  }

  Widget mainUi(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColors.textColor3.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonWidgets().dashboardTopBar(topBarComponent()),
            Expanded(child: bodyWidget()),
            BottomBarWidget(
              onTapCallBack: onTapBottomListItem,
              accountImageVisibility: false,
              isFromDashboard: false,
            )
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
                  StyleConstants.customTextStyle16MontserratBold(
                      color: AppColors.whiteColor)),
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
        color: AppColors.textColor3.withOpacity(0.1),
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
                  StyleConstants.customTextStyle22MontserratBold(
                      color: AppColors.textColor1),
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
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: AppColors.textColor1.withOpacity(0.2), width: 2)),
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
                      hintStyle: StyleConstants.customTextStyle15MonsterRegular(
                          color: AppColors.textColor1)),
                ),
              ),
            ),
          ),
          Text(validationMessage,
              style: StyleConstants.customTextStyle12MonsterRegular(
                  color: AppColors.textColor5),
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
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                      color: AppColors.textColor1.withOpacity(0.2), width: 2)),
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
                      hintStyle: StyleConstants.customTextStyle15MonsterRegular(
                          color: AppColors.textColor1)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: editMode ? true : false,
            child: Text(validationMessage,
                style: StyleConstants.customTextStyle12MonsterRegular(
                    color: AppColors.textColor5),
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
                          hintStyle:
                              StyleConstants.customTextStyle15MonsterRegular(
                                  color: AppColors.textColor1)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(emailValidationMessage,
              style: StyleConstants.customTextStyle12MonsterRegular(
                  color: AppColors.textColor5),
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
}
