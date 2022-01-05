import 'package:flutter/material.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/size_configuration.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class SearchCustomers extends StatefulWidget {
  Function onTapCustomer;
   SearchCustomers({required this.onTapCustomer, Key? key}) : super(key: key);

  @override
  _SearchCustomersState createState() => _SearchCustomersState();
}

class _SearchCustomersState extends State<SearchCustomers> {

  List<String> filteredCustomerNames = [];
  List<String> allCustomerNames = getCustomerNames();
  TextEditingController searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return searchCustomerContainer();
  }

  Widget searchCustomerContainer() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: clearButton()
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
              hintText: StringConstants.searchCustomerName,
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
        itemCount: filteredCustomerNames.length,
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
        child: CommonWidgets().textWidget(filteredCustomerNames[index],
            StyleConstants.customTextStyle(fontSize: 12.0,
                color: getMaterialColor(AppColors.textColor1), fontFamily: FontConstants.montserratMedium)),
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

  //Action events
  onTapCustomerName(int index) {
      widget.onTapCustomer(filteredCustomerNames[index]);
  }

  onChangeSearchText(String? inputText) {
    if ((inputText ?? '').length > 2 && (inputText ?? '').length % 2 != 0 ) {
      final searchedCustomers = allCustomerNames.where((customer) {
        final customerNameLower = customer.toLowerCase();
        final searchedTextLower = (inputText ?? '').toLowerCase();

        return customerNameLower.contains(searchedTextLower);
      }).toList();

      setState(() {
        filteredCustomerNames.clear();
        filteredCustomerNames.addAll(searchedCustomers);
      });
    } else if ((inputText ?? '').length < 3 ) {
      setState(() {
        filteredCustomerNames.clear();
      });
    }
  }

  onTapClearButton() {
    setState(() {
      searchFieldController.text = '';
      filteredCustomerNames.clear();
    });
  }
}

getCustomerNames() {
  return [
    'aValeria Adams',
    'abValentine Smith',
    'aVance Miller',
    'bValeria Adams',
    'cValentine Smith',
    'dVance Miller',
    'eValeria Adams',
    'gValentine Smith',
    'hVance Miller',
    'Valeria Adams',
    'Valentine Smith',
    'Vance Miller',
    'Vance Miller'
  ];
}
