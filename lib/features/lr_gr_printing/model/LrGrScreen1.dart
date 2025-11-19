class LrGrTransporterModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<LrGrTransportResponseList>? responseList;

  LrGrTransporterModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  LrGrTransporterModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <LrGrTransportResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(LrGrTransportResponseList.fromJson(v));
      });
    }
  }
}

class LrGrTransportResponseList {
  int? plantId;
  String? plantName;
  String? division;
  String? invoiceCount;
  // String? stateId;
  int? rownumber;

  LrGrTransportResponseList(
      {this.plantId,
      this.plantName,
      this.division,
      // this.diNumber,
      this.invoiceCount,
      this.rownumber});

  LrGrTransportResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    division = json['division'];
    invoiceCount = json['invoiceCount'];
    // stateId = json['stateId'];
    rownumber = json['rownumber'];
  }
}
