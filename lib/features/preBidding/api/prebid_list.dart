import 'dart:convert';

import 'package:shreecement/features/preBidding/apiModels/prebid_first.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class PrebidListApi {
  Future<dynamic> getPreBidList(List<String> division, String? diType,String pageType) async {
    String url = "$baseUrl/bidding/getprebid";

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
            "employeeCode": sp?.getString("employeeCode"),
            "roleId": sp?.getString("roleId"),
            "division": division,
            "diType": diType,
            "pageType":pageType
          }));

      final result = jsonDecode(res.body);

      return PreBidListModel.fromJson(result);
    } catch (e) {
      // print("error in prebidApi $e");
    }
  }
}
