import 'dart:convert';

import 'package:shreecement/features/preBidding/apiModels/prebid_first.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/preBidding/apiModels/trans_prebid2_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class TransPrebidListApi {
  Future<dynamic> getTransPreBidList(
      List<String> division, String? diType) async {
    String url = "$baseUrl/bidding/trans/getprebid";

    try {
      String? token = await secureStorage.read("token");
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization":"Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "employeeCode": sp?.getString("employeeCode"),
            "staffCode": sp?.getString("staffCode") ?? "",
            "roleId": sp?.getString("roleId"),
            "division": division,
            "diType": diType
          }));

      final result = jsonDecode(res.body);

      return PreBidListModel.fromJson(result);
    } catch (e) {
      // print("error in prebidApi $e");
    }
  }
}

class TransPreBid2API {
  Future<TransPreBid2Model> getTransPreBid2DataFromAPI({
    required String employeeCode,
    required int roleId,
    required String plantId,
    required List<String> division,
    required String diType,
    String stateName = "",
    String stateCode = "",
    String districtName = "",
    String districtCode = "",
    String cityName = "",
    String cityCode = "",
  }) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/bidding/trans/dilist";
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "employeeCode": employeeCode,
            "roleId": roleId,
            "plantId": plantId,
            "stateName": stateName,
            "stateCode": stateCode,
            "district": districtCode,
            "districtName": districtName,
            "city": cityCode,
            "cityName": cityName,
            "updatedDI": "",
            "division": division,
            "bidStartTime": "",
            "diType": diType
          }));
      final result = jsonDecode(res.body);
      // log("Pre Bid 2 data: $result");
      return TransPreBid2Model.fromJson(result);
    } catch (err) {
      throw Exception(err);
    }
  }
}
