import 'dart:convert';

import 'package:shreecement/features/biddingProcess/models/unlinked_delivery_model.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class UnlinkedDeliveriesApi {
  Future<dynamic> getUnlinkedDeliveries({required String plantId}) async {
    final queryParameters = {
      "division": sp?.getString("division1"),
      "diType": sp?.getString("diType")
    };
    final uri = Uri.https(
        domain, "/app/bidding/unlinked-Deliveries/$plantId", queryParameters);
    // String url = "$baseUrl/bidding/unlinked-Deliveries/$plantId";

    try {
      String? token = await secureStorage.read("token");
      var res = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = json.decode(res.body);
      return UnlinkedDeliveryModel.fromJson(result);
    } catch (e) {
      // // print("error in unlink delivery list $e");
    }
  }
}
