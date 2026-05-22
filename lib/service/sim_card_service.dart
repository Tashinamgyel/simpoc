import 'package:sim_card_code/sim_card_code.dart';

class SimService {
  Future<Map<String, dynamic>> getSimData() async {

    final results = await Future.wait([
      SimCardManager.hasSimCard,
      SimCardManager.simCount,
      SimCardManager.isDualSim,
      SimCardManager.isEsim,
      SimCardManager.supportsEsim,
      SimCardManager.simCountryCode,
      SimCardManager.simOperatorName,
      SimCardManager.simOperatorCode,
      SimCardManager.simSerialNumber,
      SimCardManager.phoneNumber,
      SimCardManager.simState,
      SimCardManager.networkOperatorName,
      SimCardManager.networkCountryCode,
      SimCardManager.networkType,
      SimCardManager.isRoaming,
      SimCardManager.deviceId,
      SimCardManager.allSimInfo,
    ]);

    return {
      'hasSimCard': results[0],
      'simCount': results[1],
      'isDualSim': results[2],
      'isEsim': results[3],
      'supportsEsim': results[4],
      'simCountryCode': results[5],
      'simOperatorName': results[6],
      'simOperatorCode': results[7],
      'simSerialNumber': results[8],
      'phoneNumber': results[9],
      'simState': (results[10] as SimState).name,
      'networkOperatorName': results[11],
      'networkCountryCode': results[12],
      'networkType': results[13],
      'isRoaming': results[14],
      'deviceId': results[15],
      'allSimInfo': results[16],
    };
  }
}