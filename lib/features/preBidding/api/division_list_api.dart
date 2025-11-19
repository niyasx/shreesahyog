import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/preBidding/api/division_list_by_plant.dart';
import 'package:shreecement/features/preBidding/apiModels/divisionResponse.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class DivisionListApi {
  Future<DivisionModel> getDivisionListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/divisions-list";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    // if (res.statusCode == 200) {
    final result = json.decode(res.body);
    // print(res.body);
    // print(DivisionModel.fromJson(result));
    return DivisionModel.fromJson(result);
    //   } else {
    // throw Exception(
    // "Failed to load division list. Status code: ${res.statusCode}")
//  }
  }

  //new changes 10 april
  Future<DivisionListResponseModel> getDivisionListFromAPIForGenerateBill({String? plantId}) async {
    // final dynamic  queryParameters = {
    //   "plantId": plantId,
    //   "transporterId": sp?.getString("employeeCode") ?? ""
    // };
    // Fetch from SharedPreferences if plantId is not provided
    String? finalPlantId = plantId ?? sp?.getString("selectedPlantValue");
    String transporterId = sp?.getString("employeeCode") ?? "";

    final dynamic queryParameters = {
      // Send "isEmpty" if no valid plant is selected
      "plantId": (finalPlantId == null || finalPlantId.isEmpty || finalPlantId == "Select Plant")
          ? "isEmpty"
          : finalPlantId,
      "transporterId": transporterId,
    };
  String? token = await secureStorage.read("token");
    final uri =
    Uri.https(domain, "/app/master/getDivisionByPlantIdAndEmployeeOrTransporterId", queryParameters);
    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    final result = json.decode(res.body);
    return DivisionListResponseModel.fromJson(result);
  }



  Future<DivisionListResponseModel> getDivisionListByPlantAndTransporter() async {
    final dynamic  queryParams = {
      "transporterId": sp?.getString("employeeCode") ?? ""
    };
    String? token = await secureStorage.read("token");
    final uri =
    Uri.https(domain, "/app/master/getDivisionByPlantIdAndEmployeeOrTransporterId", queryParams);
  var res = await http.get(uri, headers: {
  "Authorization": "Bearer $token",
  "username": (sp?.getString("email")).toString(),
  "Content-Type": "application/json",
  "Accept": "*/*", // Add plant code to headers if needed
  });

  final result = json.decode(res.body);
  return DivisionListResponseModel.fromJson(result);
  }


}
