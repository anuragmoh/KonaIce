
import 'package:flutter/material.dart';
import 'package:kona_ice_pos/common/extensions/string_extension.dart';
import 'package:kona_ice_pos/constants/database_keys.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/database/daos/event_item_dao.dart';
import 'package:kona_ice_pos/database/daos/events_dao.dart';
import 'package:kona_ice_pos/database/daos/food_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/item_categories_dao.dart';
import 'package:kona_ice_pos/database/daos/item_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_extra_items_dao.dart';
import 'package:kona_ice_pos/database/daos/saved_orders_items_dao.dart';
import 'package:kona_ice_pos/database/daos/session_dao.dart';
import 'package:kona_ice_pos/models/data_models/session.dart';
import 'package:kona_ice_pos/screens/login/login_model.dart';
import 'package:kona_ice_pos/screens/login/login_screen.dart';

class FunctionalUtils {

  static int clockInTimestamp = 0;


  static saveUserDetailInDB({required LoginResponseModel userModel}) {

    if (userModel.id != null) {
    SessionDAO()
        .insert(Session(key: DatabaseKeys.userID, value: userModel.id!));
    }

    if (userModel.firstName != null) {
      SessionDAO()
          .insert(Session(key: DatabaseKeys.firstName, value: userModel.firstName!));
    }

    if (userModel.lastName != null) {
      SessionDAO()
          .insert(Session(key: DatabaseKeys.lastName, value: userModel.lastName!));
    }

    if (userModel.email != null) {
      SessionDAO()
          .insert(Session(key: DatabaseKeys.email, value: userModel.email!));
    }

    if (userModel.phoneNum != null) {
      SessionDAO()
          .insert(Session(key: DatabaseKeys.phoneNum, value: userModel.phoneNum!));
    }

    if (userModel.numCountryCode != null) {
      SessionDAO()
          .insert(Session(key: DatabaseKeys.numCountryCode, value: userModel.numCountryCode!));
    }

    if (userModel.profileImageFileId != null) {
      SessionDAO()
          .insert(Session(key: DatabaseKeys.profileImageFileId, value: userModel.profileImageFileId!));
    }

    if (userModel.franchiseId != null) {
      SessionDAO()
          .insert(Session(key: DatabaseKeys.franchiseId, value: userModel.franchiseId!));

      if (userModel.activated != null) {
        SessionDAO()
            .insert(Session(key: DatabaseKeys.activated, value: userModel.activated! ? StringConstants.trueText : StringConstants.falseText));
      }

      saveUserDetailInDBPartA(userModel: userModel);
    }
  }

  //To avoid complexity
   static saveUserDetailInDBPartA({required LoginResponseModel userModel}) {
     if (userModel.emailVerified != null) {
       SessionDAO()
           .insert(Session(key: DatabaseKeys.emailVerified, value: userModel.emailVerified! ? StringConstants.trueText : StringConstants.falseText));
     }

     if (userModel.phoneNumberVerified != null) {
       SessionDAO()
           .insert(Session(key: DatabaseKeys.phoneNumberVerified, value: userModel.phoneNumberVerified! ? StringConstants.trueText : StringConstants.falseText));
     }

     if (userModel.timezone != null) {
       SessionDAO()
           .insert(Session(key: DatabaseKeys.timezone, value: userModel.timezone!));
     }

     if (userModel.roles != null && userModel.roles!.isNotEmpty) {
       if (userModel.roles![0].id != null) {
         SessionDAO()
             .insert(Session(
             key: DatabaseKeys.roleId, value: userModel.roles![0].id!));
       }

       if (userModel.roles![0].roleCode != null) {
         SessionDAO()
             .insert(Session(
             key: DatabaseKeys.roleCode, value: userModel.roles![0].roleCode!));
       }

       if (userModel.roles![0].id != null) {
         SessionDAO()
             .insert(Session(
             key: DatabaseKeys.roleName, value: userModel.roles![0].roleName!));
       }
     }
  }


  static Future<String> getSessionKey() async {
    String sessionKey = StringExtension.empty();
    var idObj = await SessionDAO().getValueForKey(DatabaseKeys.sessionKey);
    if (idObj != null) {
      sessionKey = idObj.value ;
    }

    return sessionKey;
  }

  static Future<String> getUserName() async {
    String userName = StringExtension.empty();
    var firstName = await SessionDAO().getValueForKey(DatabaseKeys.firstName);
    if (firstName != null) {
      userName = (userName + firstName.value + ' ') ;
    }

    var lastName = await SessionDAO().getValueForKey(DatabaseKeys.lastName);
    if (lastName != null) {
      userName = (userName + lastName.value) ;
    }

    return userName.toTitleCase();
  }

  static Future<String> getUserID() async {
    String userID = StringExtension.empty();
    var idObj = await SessionDAO().getValueForKey(DatabaseKeys.userID);
    if (idObj != null) {
      userID = idObj.value ;
    }

    return userID;
  }

  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static clearSessionData() async {
    print("getting 401 in base client");
    await SessionDAO().delete(DatabaseKeys.sessionKey);
    Navigator.of(navigatorKey.currentContext!).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  static clearAllDBData() {
     EventItemDAO().clearEventItemData;
     EventsDAO().clearEventsData();
     FoodExtraItemsDAO().clearFoodExtraItemsData();
     ItemDAO().clearItemData();
     ItemCategoriesDAO().clearItemData();
     SavedOrdersDAO().clearEventsData();
     SavedOrdersExtraItemsDAO().clearEventsData();
     SavedOrdersItemsDAO().clearEventsData();
  }


  static hideKeyboard(){
    return  FocusScope.of(navigatorKey.currentContext!).requestFocus(FocusNode());
  }
}