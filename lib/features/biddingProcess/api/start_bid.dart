import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/biddingProcess/models/start_bid_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class StartBidApi {
  Future<dynamic> getStartBidData({String? division, String? ditype}) async {
    final queryParameters = {
      'empCode': sp?.getString("employeeCode") ?? "",
      'division': division,
      'diType': ditype
    };
    final uri = Uri.https(
      domain,
      "/app/bidding/plant-wiseDi-Logistics",
      queryParameters,
    );

    try {

      String? token = await secureStorage.read("token");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      // log("Start Bid Data:  $result");
      return StartBidModel.fromJson(result);
    } catch (e) {
    }
  }
}
