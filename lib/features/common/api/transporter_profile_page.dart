import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../global.dart';
import '../../../main.dart';

Future<void> addSPOCUser({
  required String createdBy,
  required String emailId,
  required String mobileNumber,
  required int roleId,
  required String roleName,
  required String stateName,
  required int supplierCode,
  required String supplierName,
  required String userName,
  required bool status,
  required List<Map<String, String>> userPlantMappedList,
}) async {
  try {
    String? token = await secureStorage.read("token");
    final uri = Uri.parse("$baseUrl/users/staff-user");
    var response = await http.post(
      uri,
      body: jsonEncode({
        "createdBy": createdBy,
        "emailId": emailId,
        "mobileNumber": mobileNumber,
        "roleId": roleId,
        "roleName": roleName,
        "stateName": stateName,
        "supplierCode": supplierCode,
        "supplierName": supplierName,
        "userName": userName,
        "status": status,
        "userPlantMappedList": userPlantMappedList,
      }),
      headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    );
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.defaultDialog(
        title: 'Success',
        content: Text(result["responseMessage"]),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    } else {
      Get.defaultDialog(
        title: 'Abort',
        content: Text(result["responseMessage"]),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    }

    return result;
  } catch (err) {
    // throw Exception(err);
  }
}

Future<void> updateSPOCUser({
  required String updatedBy,
  required String emailId,
  required String mobileNumber,
  required int roleId,
  required String roleName,
  required String stateName,
  required int supplierCode,
  required String supplierName,
  required String userName,
  required bool status,
  required String empCode,
  required List<Map<String, String>> userPlantMappedList,
}) async {
  try {
    String? token = await secureStorage.read("token");
    final uri = Uri.parse("$baseUrl/users/staff-user");
    var response = await http.put(
      uri,
      body: jsonEncode({
        "updatedBy": updatedBy,
        "emailId": emailId,
        "mobileNumber": mobileNumber,
        "roleId": roleId,
        "roleName": roleName,
        "stateName": stateName,
        "supplierCode": supplierCode,
        "supplierName": supplierName,
        "userName": userName,
        "status": status,
        "employeeCode": empCode,
        "userPlantMappedList": userPlantMappedList,
      }),
      headers: {
        "Authorization":"Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    );
    final result = jsonDecode(response.body);

    return result;
  } catch (err) {
    // throw Exception(err);
  }
}
