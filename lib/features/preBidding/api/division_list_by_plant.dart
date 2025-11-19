class DivisionListResponseModel {
  String? responseMessage;
  String? responseCode;
  Null? serviceDTO;
  Null? serviceDTOList;
  List<DivisionList>? responseList;

  DivisionListResponseModel(
      {this.responseMessage,
        this.responseCode,
        this.serviceDTO,
        this.serviceDTOList,
        this.responseList});

  DivisionListResponseModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <DivisionList>[];
      json['responseList'].forEach((v) {
        responseList!.add(DivisionList.fromJson(v));
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

class DivisionList {
  int? plantCode;
  String? employeeOrTransporterCode;
  List<String>? divisionList;

  DivisionList(
      {this.plantCode, this.employeeOrTransporterCode, this.divisionList});

  DivisionList.fromJson(Map<String, dynamic> json) {
    plantCode = json['plantCode'];
    employeeOrTransporterCode = json['employeeOrTransporterCode'];
    divisionList = json['divisionList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantCode'] = plantCode;
    data['employeeOrTransporterCode'] = employeeOrTransporterCode;
    data['divisionList'] = divisionList;
    return data;
  }
}

