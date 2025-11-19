class OTPGenerationResponseModel {
  String? responseMessage;
  String? responseCode;
  ServiceDTO? serviceDTO;
  dynamic serviceDTOList;

  OTPGenerationResponseModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList});

  OTPGenerationResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? userMobileNo;
  String? authToken;
  String? password;

  ServiceDTO({this.userMobileNo, this.authToken, this.password});

  ServiceDTO.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['userMobileNo'];
    authToken = json['authToken'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userMobileNo'] = userMobileNo;
    data['authToken'] = authToken;
    data['password'] = password;
    return data;
  }
}
