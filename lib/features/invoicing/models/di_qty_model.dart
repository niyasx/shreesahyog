class FreightBillDiQtyModel {
  String? responseMessage;
  String? responseCode;
  ServiceDTO? serviceDTO;
  dynamic serviceDTOList;

  FreightBillDiQtyModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList});

  FreightBillDiQtyModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'] != null
        ? ServiceDTO.fromJson(json['serviceDTO'])
        : null;
    serviceDTOList = json['serviceDTOList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    if (serviceDTO != null) {
      data['serviceDTO'] = serviceDTO!.toJson();
    }
    data['serviceDTOList'] = serviceDTOList;
    return data;
  }
}

class ServiceDTO {
  dynamic userMobileNo;
  dynamic authToken;
  dynamic password;
  String? tokenNumber;
  double? plantNetWeight;
  double? plantTareWeight;
  String? diUom;
  double? plantGrossWeight;

  ServiceDTO(
      {this.userMobileNo,
      this.authToken,
      this.password,
      this.tokenNumber,
      this.plantNetWeight,
      this.plantTareWeight,
      this.diUom,
      this.plantGrossWeight});

  ServiceDTO.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['userMobileNo'];
    authToken = json['authToken'];
    password = json['password'];
    tokenNumber = json['tokenNumber'];
    plantNetWeight = json['plantNetWeight'];
    plantTareWeight = json['plantTareWeight'];
    diUom = json['diUom'];
    plantGrossWeight = json['plantGrossWeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userMobileNo'] = userMobileNo;
    data['authToken'] = authToken;
    data['password'] = password;
    data['tokenNumber'] = tokenNumber;
    data['plantNetWeight'] = plantNetWeight;
    data['plantTareWeight'] = plantTareWeight;
    data['diUom'] = diUom;
    data['plantGrossWeight'] = plantGrossWeight;
    return data;
  }
}
