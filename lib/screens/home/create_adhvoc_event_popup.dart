import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/assets/assets_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/screens/home/assest_model.dart';
import 'package:kona_ice_pos/utils/check_connectivity.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';

class CreateAdhocEvent extends StatefulWidget {
  const CreateAdhocEvent({Key? key}) : super(key: key);

  @override
  State<CreateAdhocEvent> createState() => _CreateAdhocEventState();
}

class _CreateAdhocEventState extends State<CreateAdhocEvent> implements AssetsResponseContractor{
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  List<Datum> assetList = [];

  late AssetsPresenter presenter;
  bool isApiProcess = false;
  var _selectedAsset;

  _CreateAdhocEventState(){
    presenter = AssetsPresenter(this);
  }

  getAssets(){
    CheckConnection().connectionState().then((value){
      if(value!){
        setState(() {
          isApiProcess = true;
        });
        presenter.getAssets();
      }else{
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
  }



  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                      CommonWidgets().textView(
                          StringConstants.name,
                          StyleConstants.customTextStyle(
                              fontSize: 14.0,
                              color: AppColors.textColor2,
                              fontFamily: FontConstants.montserratRegular)),
                      const SizedBox(height: 5.0),
                      TextField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: StringConstants.enterName,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.textColor2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.textColor2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.textColor2),
                            ),
                        ),
                      ),
                      // Address Field
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
                        decoration: const InputDecoration(
                          hintText: StringConstants.enterAddress,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                        ),
                      ),
                      // City field
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
                        decoration: const InputDecoration(
                          hintText: StringConstants.enterCity,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                        ),
                      ),
                      // State field
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
                        decoration: const InputDecoration(
                          hintText: StringConstants.enterState,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                        ),
                      ),
                      // ZipCode field
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
                        decoration: const InputDecoration(
                          hintText: StringConstants.enterZipCode,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor2),
                          ),
                        ),
                      ),
                      // Select Equipments Field
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
                              border: Border.all(color: AppColors.textColor2,width: 1.0),
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                equipmentDropDown(),
                                const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child:  Icon(Icons.arrow_drop_down_sharp,size: 20.0),
                                )
                              ],
                            ),
                          )),
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

  Widget equipmentDropDown()=>DropdownButton(
    hint: const Text(StringConstants.selectEquipment),
    underline:Container(),
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
      debugPrint(_selectedAsset);
    },
    value: _selectedAsset,
  );
  
  Widget createButton()=> GestureDetector(
    onTap: onTapCreate,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      decoration: const BoxDecoration(
        borderRadius:  BorderRadius.all(Radius.circular(20.0)),
        color: AppColors.primaryColor2
      ),
      child: Center(child: Text(StringConstants.create,style: StyleConstants.customTextStyle(fontSize: 16.0, color: AppColors.textColor1, fontFamily: FontConstants.montserratBold),)),
    ),
  ) ;
  onTapCreate(){
    debugPrint("Create click");
  }

  onTapCloseButton() {
    Navigator.of(context).pop();
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
    debugPrint("${assetList[0].assetName}");
  }

  @override
  void showError(GeneralErrorResponse exception) {
    // TODO: implement showError
  }

  @override
  void showSuccess(response) {
    // TODO: implement showSuccess
  }



}
