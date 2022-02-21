import 'package:flutter/material.dart';
import 'package:kona_ice_pos/utils/dialog/confirmation_dialog.dart';

class DialogHelper{
  static confirmationDialog(context, onTapYes,onTapNo) => showDialog(context: context, builder: (context)=> ConfirmationDialog(onTapYes: onTapYes, onTapNo: onTapNo));

}