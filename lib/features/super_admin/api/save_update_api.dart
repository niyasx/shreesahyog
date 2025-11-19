import 'dart:convert';
import 'package:get/get.dart';
import 'package:shreecement/features/super_admin/model/save_update.dart';

import '../../../global.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../common/screens/token_expire.dart';

Future<SaveUpdate> saveUpdateApi(
    List<int> districtList, String? stateCode, String? transporterCode) async {
  String url = "$baseUrl/master/saveTransporterDistrictMapping";

  try {
    String? token = await secureStorage.read("token");
    var res = await http.post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode({
          "transporterCode": transporterCode,
          // "roleId": sp?.getString("roleId"),
          "districtList": districtList,
          "stateCode": stateCode
        }));
    if (res.statusCode == 403) {
      Get.offAll(const TokenExpire());
      return SaveUpdate(responseMessage: "", responseCode: "", serviceDTO: "", serviceDTOList: "");
    }
    final result = jsonDecode(res.body);

    return SaveUpdate.fromJson(result);
  } catch (e) {
    // print("error in prebidApi $e");
  }
  return SaveUpdate(responseMessage: "", responseCode: "", serviceDTO: "", serviceDTOList: "");

}
