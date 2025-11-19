import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/global.dart';

class AuthenticateAPI {
  Future<dynamic> authPostAPI(
      {required String username, required String password}) async {
    String url = "$baseUrl/users/login/authenticate";
    var res = await http.post(Uri.parse(url), body: {
      "emailId": username,
      "password": password,
    });
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return null;
    }
  }
}
