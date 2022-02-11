import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/network/general_error_model.dart';
import 'package:kona_ice_pos/network/repository/customer/customer_presenter.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

import 'customer_model.dart';

class SearchCustomers extends StatefulWidget {
  Function onTapCustomer;
   SearchCustomers({required this.onTapCustomer, Key? key}) : super(key: key);

  @override
  _SearchCustomersState createState() => _SearchCustomersState();
}

class _SearchCustomersState extends State<SearchCustomers>
    implements ResponseContractor{

  late CustomerPresenter customerPresenter;

  _SearchCustomersState() {
    customerPresenter = CustomerPresenter(this);
  }

  bool isApiProcess = false;

  List<CustomerDetails> customerList = [];
  TextEditingController searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isApiProcess, child: searchCustomerContainer(context));
    //return searchCustomerContainer(context);
  }

  Widget searchCustomerContainer(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cancelButton(),
              clearButton(),
            ],
          ),
          searchTextField(),
          Expanded(child: searchedCustomerList())
        ]
    );
  }

  Widget searchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: SizedBox(
        height: 3.3*SizeConfig.heightSizeMultiplier,
        child: TextField(
          controller: searchFieldController,
          style: StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor1),
              fontFamily: FontConstants.montserratMedium),
          decoration: InputDecoration(
              hintText: StringConstants.searchCustomerNameORNum,
              hintStyle: StyleConstants.customTextStyle(fontSize: 12.0, color: getMaterialColor(AppColors.textColor2),
                  fontFamily: FontConstants.montserratMedium),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.5),
                borderSide: BorderSide(color: getMaterialColor(AppColors.primaryColor1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.5),
                borderSide: BorderSide(color: getMaterialColor(AppColors.primaryColor1)),
              ),
              contentPadding: const EdgeInsets.only(left: 15.0),
              suffixIcon: Icon(Icons.search, size: 24.0, color: getMaterialColor(AppColors.primaryColor1),)
          ),
          onChanged: onChangeSearchText,
        ),
      ),
    );
  }

  Widget searchedCustomerList() {
    return ListView.separated(
        itemCount: customerList.length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 1.0,
            color: getMaterialColor(AppColors.textColor2),
          );
        },
        itemBuilder:(context, index) {
          return buildSearchedCustomerTile(index);
        }
    );
  }

  Widget buildSearchedCustomerTile(int index) {
    return ListTile(
      horizontalTitleGap: 5.0,
      dense: true,
      leading: CircleAvatar(
        radius: 1.5 * SizeConfig.imageSizeMultiplier,
        backgroundImage: const NetworkImage('https://picsum.photos/id/237/200/300'),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().textWidget(customerList[index].getFullName(),
                StyleConstants.customTextStyle(fontSize: 12.0,
                    color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
            Visibility(
              visible: (customerList[index].phoneNum ?? '').isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: CommonWidgets().textWidget(customerList[index].phoneNum!,
                    StyleConstants.customTextStyle(fontSize: 12.0,
                        color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratRegular)),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        onTapCustomerName(index);
      },
    );
  }

  Widget clearButton() {
    return GestureDetector(
      onTap: onTapClearButton,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: CommonWidgets().textWidget(StringConstants.clear, StyleConstants.customTextStyle(
            fontSize: 9.0, color: getMaterialColor(AppColors.textColor5), fontFamily: FontConstants.montserratSemiBold)
        ),
      ),
    );
  }

  Widget cancelButton() {
    return GestureDetector(
      onTap: onTapCancelButton,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: CommonWidgets().textWidget(StringConstants.cancel, StyleConstants.customTextStyle(
            fontSize: 9.0, color: getMaterialColor(AppColors.textColor5), fontFamily: FontConstants.montserratSemiBold)
        ),
      ),
    );
  }

  //Action events
  onTapCustomerName(int index) {
      widget.onTapCustomer(customerList[index]);
  }

  onChangeSearchText(String? inputText) {
    if ((inputText ?? '').length > 2 && (inputText ?? '').length % 2 != 0 && (inputText ?? '').isNotEmpty) {
      customerListAPI(searchText: inputText!);
    }
    // } else if ((inputText ?? '').length < 3 ) {
    //   setState(() {
    //     customerList.clear();
    //   });
    // }
  }

  onTapCancelButton() {
    widget.onTapCustomer(null);
  }

  onTapClearButton() {
    setState(() {
      searchFieldController.text = '';
      customerList.clear();
    });
  }



  //API Call

  customerListAPI({required String searchText}) {
    setState(() {
      isApiProcess = true;
    });

    customerPresenter.customerList(searchText);
  }

  @override
  void showError(GeneralErrorResponse exception) {
    // TODO: implement showError
    setState(() {
      isApiProcess = false;
      CommonWidgets().showErrorSnackBar(errorMessage: exception.message ?? StringConstants.somethingWentWrong, context: context);
    });
  }

  @override
  void showSuccess(response) {
    // TODO: implement showSuccess
    List<CustomerDetails> list = response;
    setState(() {
      isApiProcess = false;
      customerList.clear();
      customerList.addAll(list);
    });
  }
}
