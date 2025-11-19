class MaterialFrtGroupModel {
  String? responseMessage;
  dynamic responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ResponseList>? responseList;

  MaterialFrtGroupModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  MaterialFrtGroupModel.fromJson(Map<String, dynamic> json) {
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
  int? segmentId;
  String? frtGroupCode;
  String? frtGroupName;
  String? division;
  String? divisionCode;

  ResponseList(
      {this.segmentId,
      this.frtGroupCode,
      this.frtGroupName,
      this.division,
      this.divisionCode});

  ResponseList.fromJson(Map<String, dynamic> json) {
    segmentId = json['segmentId'];
    frtGroupCode = json['frtGroupCode'];
    frtGroupName = json['frtGroupName'];
    division = json['division'];
    divisionCode = json['divisionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['segmentId'] = segmentId;
    data['frtGroupCode'] = frtGroupCode;
    data['frtGroupName'] = frtGroupName;
    data['division'] = division;
    data['divisionCode'] = divisionCode;
    return data;
  }
}
