import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
class CreateAdhocEvent extends StatefulWidget {
  const CreateAdhocEvent({Key? key}) : super(key: key);

  @override
  State<CreateAdhocEvent> createState() => _CreateAdhocEventState();
}

class _CreateAdhocEventState extends State<CreateAdhocEvent> {


  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: mainUI(),
    );
  }

  Widget mainUI(){
    return SizedBox(
      width: 392.0,
      child: Column(
        children: [
          CommonWidgets().popUpTopView(
            title: StringConstants.popHeading,
            onTapCloseButton: onTapCloseButton,
          ),
          Container(
            color: AppColors.whiteColor,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24.0),
                  CommonWidgets().textView(StringConstants.name, StyleConstants.customTextStyle(fontSize: 14.0, color: AppColors.textColor2, fontFamily: FontConstants.montserratRegular)),
                  TextField(
                    controller: nameController,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  onTapCloseButton() {
    Navigator.of(context).pop();
  }
}
