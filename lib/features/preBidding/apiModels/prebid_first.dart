class PreBidListModel {
  String? responseMessage;
  dynamic responseCode;
  String? serviceDTO;
  String? serviceDTOList;
  List<PreBidListResponseList>? responseList;

  PreBidListModel({
    this.responseMessage,
    this.responseCode,
    this.serviceDTO,
    this.serviceDTOList,
    this.responseList,
  });

  PreBidListModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'].toString();
    responseCode = json['responseCode'].toString();
    serviceDTO = json['serviceDTO'].toString();
    serviceDTOList = json['serviceDTOList'].toString();
    responseList = (json['responseList'] as List?)
        ?.map((dynamic e) =>
            PreBidListResponseList.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['responseMessage'] = responseMessage;
    json['responseCode'] = responseCode;
    json['serviceDTO'] = serviceDTO;
    json['serviceDTOList'] = serviceDTOList;
    json['responseList'] = responseList?.map((e) => e.toJson()).toList();
    return json;
  }
}

class PreBidListResponseList {
  String? plantId;
  String? plantName;
  int? diCount;
  String? division;

  PreBidListResponseList({
    this.plantId,
    this.plantName,
    this.diCount,
    this.division,
  });

  PreBidListResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'].toString();
    plantName = json['plantName'].toString();
    diCount = json['diCount'] as int?;
    division = json['division'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['plantId'] = plantId;
    json['plantName'] = plantName;
    json['diCount'] = diCount;
    json['division'] = division;
    return json;
  }
}
