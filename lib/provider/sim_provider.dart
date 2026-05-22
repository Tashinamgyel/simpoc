import 'package:flutter/material.dart';
import 'package:sim_card_code/sim_card_code.dart';
import '../service/sim_card_service.dart';

class SimProvider extends ChangeNotifier {
  final SimService service;

  SimProvider(this.service);

  bool isLoading = false;

  bool hasSimCard = false;
  int simCount = 0;
  bool isDualSim = false;
  bool isEsim = false;
  bool supportsEsim = false;

  String? simCountryCode;
  String? simOperatorName;
  String? simOperatorCode;
  String? simSerialNumber;
  String? phoneNumber;
  String? simState;
  String? networkOperatorName;
  String? networkCountryCode;
  String? networkType;
  bool isRoaming = false;
  String? deviceId;

  List<SimCardInfo> allSimInfo = [];

  Future<void> loadSimInfo() async {
    isLoading = true;
    notifyListeners();

    final data = await service.getSimData();

    hasSimCard = data['hasSimCard'];
    simCount = data['simCount'];
    isDualSim = data['isDualSim'];
    isEsim = data['isEsim'];
    supportsEsim = data['supportsEsim'];
    simCountryCode = data['simCountryCode'];
    simOperatorName = data['simOperatorName'];
    simOperatorCode = data['simOperatorCode'];
    simSerialNumber = data['simSerialNumber'];
    phoneNumber = data['phoneNumber'];
    simState = data['simState'];
    networkOperatorName = data['networkOperatorName'];
    networkCountryCode = data['networkCountryCode'];
    networkType = data['networkType'];
    isRoaming = data['isRoaming'];
    deviceId = data['deviceId'];
    allSimInfo = data['allSimInfo'] as List<SimCardInfo>? ?? [];

    isLoading = false;
    notifyListeners();
  }
}
