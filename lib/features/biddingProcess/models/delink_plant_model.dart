class DeLinkPlantModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<PlantResponseList>? responseList;

  DeLinkPlantModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  DeLinkPlantModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <PlantResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(PlantResponseList.fromJson(v));
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

class PlantResponseList {
  String? userId;
  String? userName;
  String? plantCode;
  String? plantName;

  PlantResponseList(
      {this.userId, this.userName, this.plantCode, this.plantName});

  PlantResponseList.fromJson(Map<String, dynamic> json) {
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
