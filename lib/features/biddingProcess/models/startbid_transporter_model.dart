class StartBidTransporterModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<TransportResponseList>? responseList;

  StartBidTransporterModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  StartBidTransporterModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <TransportResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(TransportResponseList.fromJson(v));
      });
    }
  }
}

class TransportResponseList {
  int? plantId;
  String? plantName;
  String? division;
  String? diNumber;
  String? stateId;
  int? rownumber;

  TransportResponseList(
      {this.plantId,
      this.plantName,
      this.division,
      this.diNumber,
      this.stateId,
      this.rownumber});

  TransportResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    division = json['division'];
    diNumber = json['diNumber'];
    stateId = json['stateId'];
    rownumber = json['rownumber'];
  }
}
