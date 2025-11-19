class PlantsForFrieghtBillModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<PlantResponseListFrBill>? responseList;

  PlantsForFrieghtBillModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  PlantsForFrieghtBillModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <PlantResponseListFrBill>[];
      json['responseList'].forEach((v) {
        responseList!.add(PlantResponseListFrBill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    data['serviceDTO'] = serviceDTO;
    data['serviceDTOList'] = serviceDTOList;
    if (responseList != null) {
      data['responseList'] = responseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlantResponseListFrBill {
  String? userId;
  String? userName;
  String? plantCode;
  String? plantName;

  PlantResponseListFrBill(
      {this.userId, this.userName, this.plantCode, this.plantName});

  PlantResponseListFrBill.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    plantCode = json['plantCode'].toString();
    plantName = json['plantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['plantCode'] = plantCode;
    data['plantName'] = plantName;
    return data;
  }
}
