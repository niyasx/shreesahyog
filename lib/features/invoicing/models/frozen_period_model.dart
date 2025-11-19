class FrozenPeriodModel {
  String? responseMessage;
  String? responseCode;
  ServiceDTO? serviceDTO;
  dynamic serviceDTOList;

  FrozenPeriodModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList});

  FrozenPeriodModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'] != null
        ?  ServiceDTO.fromJson(json['serviceDTO'])
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
  int? id;
  String? frozenPeriod;
  String? fyLastDate;

  ServiceDTO(
      {this.userMobileNo,
      this.authToken,
      this.password,
      this.id,
      this.frozenPeriod,
      this.fyLastDate
      });

  ServiceDTO.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['userMobileNo'];
    authToken = json['authToken'];
    password = json['password'];
    id = json['id'];
    frozenPeriod = json['frozenPeriod'];
    fyLastDate =json["fyLastDate"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userMobileNo'] = userMobileNo;
    data['authToken'] = authToken;
    data['password'] = password;
    data['id'] = id;
    data['frozenPeriod'] = frozenPeriod;
    data["fyLastDate"] = fyLastDate;
    return data;
  }
}
