class UomModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ResponseList>? responseList;

  UomModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  UomModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(ResponseList.fromJson(v));
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

class ResponseList {
  int? uomMasterId;
  String? uomName;

  ResponseList({this.uomMasterId, this.uomName});

  ResponseList.fromJson(Map<String, dynamic> json) {
    uomMasterId = json['uomMasterId'];
    uomName = json['uomName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uomMasterId'] = uomMasterId;
    data['uomName'] = uomName;
    return data;
  }
}
