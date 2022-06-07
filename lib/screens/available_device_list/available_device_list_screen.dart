import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/asset_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/dashboard/dashboard_screen.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/loader.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';

import '../../utils/size_configuration.dart';

class AvailableDeviceListScreen extends StatefulWidget {
  const AvailableDeviceListScreen({Key? key}) : super(key: key);

  @override
  _AvailableDeviceListScreenState createState() =>
      _AvailableDeviceListScreenState();
}

class _AvailableDeviceListScreenState extends State<AvailableDeviceListScreen> {
  List<Device> deviceList = [];

  getAvailableDevice(){
    P2PConnectionManager.shared.startService(isStaffView: true);
    P2PConnectionManager.shared.getDeviceList(getBackValue);
  }

  bool isConnectionProcess = false;

  getBackValue(dynamic value){
    setState(() {
      deviceList.clear();
      deviceList.addAll(value);
    });
    // debugPrint("It's back with value${deviceList.length}");
  }

  @override
  void initState() {
    super.initState();
    getAvailableDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(isCallInProgress: isConnectionProcess, child: mainUi(context));
  }
  Widget mainUi(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.primaryColor1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 6.77 * SizeConfig.imageSizeMultiplier,
                  bottom: 5.07 * SizeConfig.imageSizeMultiplier),
              child: icon(),
            ),
            bodyContainer(),
            // loginContainer(),
          ],
        ),
      ),
    );
  }
  Widget bodyContainer()=> Container(
    width: 360,
    height: MediaQuery.of(context).size.height * 0.65,
    color: Colors.white,
    child:  Column(
      children: [
         Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 41, vertical: 25),
          child: Text(StringConstants.allDeviceScreenHead,
            textAlign: TextAlign.center,
            style: StyleConstants.customTextStyle22MontserratSemiBold(
              color: AppColors.textColor1),),
        ),
        Expanded(
          child: deviceList.isNotEmpty ? ListView.builder(
            itemCount: deviceList.length,
            itemBuilder: (context,index){
              final device = deviceList[index];
            return listView(device);
            }) : Align(
            alignment: Alignment.center,
            child: CommonWidgets().textWidget(StringConstants.noDeviceAvailableToConnect, StyleConstants.customTextStyle20MontserratSemiBold(color: AppColors.textColor1))
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: proceedButton(StringConstants.proceed, StyleConstants.customTextStyle12MontserratBold(
              color: AppColors.textColor1)),
        )
      ],
    ) ,
  );
  Widget icon() {
    return CommonWidgets().image(
        image: AssetsConstants.konaIcon,
        width: 20.96 * SizeConfig.imageSizeMultiplier,
        height: 15.62 * SizeConfig.imageSizeMultiplier);
  }

  Widget listView(Device device)=> Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
              child:  CommonWidgets().image(
                  image: AssetsConstants.tabletIcon,
                  width:  1.56 * SizeConfig.imageSizeMultiplier,
                  height: 2.08 * SizeConfig.imageSizeMultiplier) ,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.deviceName,
                  textAlign: TextAlign.left,
                  style: StyleConstants.customTextStyle15MonsterMedium(
                      color: AppColors.textColor1),
                ),
                Text(
                  '(${getStateName(device.state)})',
                  textAlign: TextAlign.left,
                  style: StyleConstants.customTextStyle15MonsterMedium(
                  color: getStateColor(device.state))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _onButtonClicked(device),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(8.0),
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: getButtonColor(device.state),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  getButtonStateName(device.state),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 15),
        child: Divider(),
      ),
    ],
  );
  Widget proceedButton(String buttonText, TextStyle textStyle) {
    return GestureDetector(
      onTap: () {
        onTapProceedButton();
      },
      child: Container(
        width: 210,
        decoration: BoxDecoration(
          color: AppColors.primaryColor2,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 70.0),
          child: Align(
              alignment: Alignment.center,
              child: CommonWidgets().textWidget(buttonText, textStyle)),
        ),
      ),
    );
  }

  //Action Event
  onTapProceedButton() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        debugPrint('not connected');
        isConnectionProcess = false;
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        isConnectionProcess = false;
        debugPrint('connected');
        return "connected";
    }
  }
  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return AppColors.textColor5;
      case SessionState.connecting:
        return AppColors.textColor2;
      default:
        return AppColors.textColor7;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        P2PConnectionManager.shared.connectWithDevice(device);
        setState(() {
          debugPrint('state changed');
          isConnectionProcess = true;
        });
        break;
      case SessionState.connected:
        P2PConnectionManager.shared.connectWithDevice(device);
        break;
      case SessionState.connecting:
        break;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return AppColors.denotiveColor2;
      default:
        return AppColors.denotiveColor1;
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }
}
