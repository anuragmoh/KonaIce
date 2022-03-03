import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:kona_ice_pos/constants/app_colors.dart';
import 'package:kona_ice_pos/constants/font_constants.dart';
import 'package:kona_ice_pos/constants/p2p_constants.dart';
import 'package:kona_ice_pos/constants/string_constants.dart';
import 'package:kona_ice_pos/constants/style_constants.dart';
import 'package:kona_ice_pos/screens/dashboard/dashboard_screen.dart';
import 'package:kona_ice_pos/utils/p2p_utils/bonjour_utils.dart';
import 'package:kona_ice_pos/utils/common_widgets.dart';
import 'package:kona_ice_pos/utils/utils.dart';

class AvailableDeviceListScreen extends StatefulWidget {
  const AvailableDeviceListScreen({Key? key}) : super(key: key);

  @override
  _AvailableDeviceListScreenState createState() => _AvailableDeviceListScreenState();
}

class _AvailableDeviceListScreenState extends State<AvailableDeviceListScreen> {
  List<Device> deviceList = [];

  getAvailableDevice(){
    P2PConnectionManager.shared.startService(isStaffView: true);
    P2PConnectionManager.shared.getDeviceList(getBackValue);

  }

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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: getMaterialColor(AppColors.primaryColor1),
        child: bodyContainer(),
      ),
    );
  }
  Widget bodyContainer()=> Padding(
    padding: const EdgeInsets.all(60.0),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: deviceList.length,
                itemBuilder: (context,index){
                  final device = deviceList[index];
                return listView(device);
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: proceedButton(StringConstants.proceed, StyleConstants.customTextStyle(
                fontSize: 12.0,
                color: getMaterialColor(AppColors.textColor1),
                fontFamily: FontConstants.montserratBold)),
          )
        ],
      ),
    ),
  );

  Widget listView(Device device)=> Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Column(
            children: [
              Text(device.deviceName),
              Text(
                getStateName(device.state),
                style: TextStyle(
                    color: getStateColor(device.state)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _onButtonClicked(device),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(8.0),
              height: 35,
              width: 100,
              color: getButtonColor(device.state),
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
      const Divider(),
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
          color: getMaterialColor(AppColors.primaryColor2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 70.0),
          child: Align (
              alignment: Alignment.center,
              child: CommonWidgets().textWidget(buttonText, textStyle)
          ),
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
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        return "connected";
    }
  }
  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }
  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        P2PConnectionManager.shared.connectWithDevice(device);
        break;
      case SessionState.connected:
        break;
      case SessionState.connecting:
        break;
    }
  }
  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
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
