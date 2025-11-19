import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/global.dart';

import '../../common/models/otpgenerationmodel.dart';

class OTPGen {
  Future<OTPGenerationResponseModel> otpPostAPI(
      {required String username, required String type}) async {
    String url = "$baseUrl/users/login/generate-otp";
    var res = await http.post(Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Content-Type": "application/json",
          "Accept": "*/*"
        },
        body: jsonEncode({
          "userName": username,
          "type": type,
        }));
    if (res.statusCode == 200) {
      final result = jsonDecode(res.body);
      return (OTPGenerationResponseModel.fromJson(result));
    } else {
      final result = jsonDecode(res.body);
      return (OTPGenerationResponseModel.fromJson(result));
    }
  }
}
