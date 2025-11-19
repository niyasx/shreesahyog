class TokenMappingModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<TokenMappingResponseList>? responseList;

  TokenMappingModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  TokenMappingModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <TokenMappingResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(TokenMappingResponseList.fromJson(v));
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

class TokenMappingResponseList {
  int? plantId;
  String? plantName;
  String? diNumber;
  String? division;

  TokenMappingResponseList(
      {this.plantId, this.plantName, this.diNumber, this.division});

  TokenMappingResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    diNumber = json['diNumber'];
    division = json["division"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantName'] = plantName;
    data['diNumber'] = diNumber;
    data['division'] = division;
    return data;
  }
}
