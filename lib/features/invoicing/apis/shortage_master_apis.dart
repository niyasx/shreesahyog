import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/invoicing/models/bill_status_model.dart';
import 'package:shreecement/features/invoicing/models/brand_model.dart';
import 'package:shreecement/features/invoicing/models/deliverytype_model.dart';
import 'package:shreecement/features/invoicing/models/distribution_channel_model.dart';
import 'package:shreecement/features/invoicing/models/freight_bill_type_model.dart';
import 'package:shreecement/features/invoicing/models/material_frt_group_model.dart';
import 'package:shreecement/features/invoicing/models/plant_model_frbill.dart';
import 'package:shreecement/features/invoicing/models/product_model.dart';
import 'package:shreecement/features/invoicing/models/uom_model.dart';
import 'package:shreecement/global.dart';

import 'package:shreecement/main.dart';

class ShortageMasterApis {
  //Api for getting the product details for the product dropdown
  Future<ProductModel> getProductListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/getAllProducts";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization":"Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return ProductModel.fromJson(result);
  }

  //Api for getting the brand details for the brand dropdown
  Future<BrandModel> getBrandListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/getAllBrands";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization":"Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return BrandModel.fromJson(result);
  }

  //Api for getting the Uom details for the Uom dropdown
  Future<UomModel> getUomListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/getAllUOMs";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return UomModel.fromJson(result);
  }

  //Api for getting the deliverytype details for the deliverytype dropdown
  Future<DeliveryTypeModel> getDeliveryTypeListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/getAllDeliveryTypes";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return DeliveryTypeModel.fromJson(result);
  }

  //Api for getting the distribution channel details for the distribution channel dropdown
  Future<DistributionChannelModel> getDistributionChannelTypeListFromAPI(
      {required String diType}) async {
        String? token = await secureStorage.read("token");
    String url =
        "$baseUrl/master/getAllDistributionChannelTypes?deliveryType=$diType";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return DistributionChannelModel.fromJson(result);
  }

  //Api for getting the deliverytype details for the deliverytype dropdown
  Future<FrieghtBillTypeModel> getFreightBillTypesFromApi() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/getAllFreightBillTypes";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return FrieghtBillTypeModel.fromJson(result);
  }

  Future<PlantsForFrieghtBillModel> getPlantList() async {
    final dynamic queryParameters;
    //  print(sp?.getString("staffCode") ?? "");
    if (sp?.getString("roleName") == "TRANSPORTER_STAFF") {
      queryParameters = {
        "userId": sp?.getString("staffCode") ?? "",
        "role": sp?.getString("roleName") ?? ""
      };
    } else {
      queryParameters = {
        "userId": sp?.getString("employeeCode") ?? "",
        "role": sp?.getString("roleName") ?? ""
      };
    }
    String? token = await secureStorage.read("token");
    final uri =
        Uri.https(domain, "/app/users/getUserPlantMapping", queryParameters);
    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    final result = jsonDecode(res.body);
    // // print(result);
    return PlantsForFrieghtBillModel.fromJson(result);
  }

  //Api for getting the brand details for the brand dropdown
  Future<FreightBillStatusModel> getBillStatusListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/bill-status";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return FreightBillStatusModel.fromJson(result);
  }

  Future<MaterialFrtGroupModel> getMaterialFrtGroup(
      {required String division}) async {
        String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/matfrtgrp-list?division=$division";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return MaterialFrtGroupModel.fromJson(result);
  }
}
