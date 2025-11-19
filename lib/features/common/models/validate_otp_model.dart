class ValidateOtpModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;

  ValidateOtpModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList});

  ValidateOtpModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    data['serviceDTO'] = serviceDTO;
    data['serviceDTOList'] = serviceDTOList;
    return data;
  }
}
