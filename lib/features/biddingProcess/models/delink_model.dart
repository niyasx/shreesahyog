class DeLinkModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<DeLinkResponseList>? responseList;

  DeLinkModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  DeLinkModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <DeLinkResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(DeLinkResponseList.fromJson(v));
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

class DeLinkResponseList {
  int? plantId;
  String? plantName;
  String? diNumber;
  String? stateId;
  String? stateName;
  String? districtId;
  String? districtName;
  String? cityId;
  String? cityName;
  String? transporterId;
  String? transporterName;
  String? tokenNumber;
  dynamic diUnlinkReason;
  bool? unlinkStatus;
  String? updationDate;
  String? updatedBy;
  String? diStatus;

  DeLinkResponseList(
      {this.plantId,
      this.plantName,
      this.diNumber,
      this.stateId,
      this.stateName,
      this.districtId,
      this.districtName,
      this.cityId,
      this.cityName,
      this.transporterId,
      this.transporterName,
      this.tokenNumber,
      this.diUnlinkReason,
      this.unlinkStatus,
      this.updationDate,
      this.updatedBy,
      this.diStatus});

  DeLinkResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    diNumber = json['diNumber'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    transporterId = json['transporterId'];
    transporterName = json['transporterName'];
    tokenNumber = json['tokenNumber'];
    diUnlinkReason = json['diUnlinkReason'];
    unlinkStatus = json['unlinkStatus'];
    updationDate = json['updationDate'];
    updatedBy = json['updatedBy'];
    diStatus = json ['diStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantName'] = plantName;
    data['diNumber'] = diNumber;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    data['tokenNumber'] = tokenNumber;
    data['diUnlinkReason'] = diUnlinkReason;
    data['unlinkStatus'] = unlinkStatus;
    data['updationDate'] = updationDate;
    data['updatedBy'] = updatedBy;
    data['diStatus'] = diStatus;
    return data;
  }
}
