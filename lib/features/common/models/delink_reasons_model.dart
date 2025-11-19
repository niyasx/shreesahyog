class DelinkReason {
  String? reasonCode;
  String? reasonDesc;

  DelinkReason({required this.reasonCode, required this.reasonDesc});

  factory DelinkReason.fromJson(Map<String, dynamic> json) {
    return DelinkReason(
      reasonCode: json['reasonCode'],
      reasonDesc: json['reasonDesc'],
    );
  }
}

class DelinkReasonListResponse {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;

  List<DelinkReason>? responseList;

  DelinkReasonListResponse(
      {required this.responseMessage,
      required this.responseCode,
      required this.responseList,
      this.serviceDTO,
      this.serviceDTOList});

  factory DelinkReasonListResponse.fromJson(Map<String, dynamic> json) {
    var responseList = json['responseList'] as List;
    List<DelinkReason> reasons = responseList
        .map((reasonJson) => DelinkReason.fromJson(reasonJson))
        .toList();

    return DelinkReasonListResponse(
      responseMessage: json['responseMessage'],
      responseCode: json['responseCode'],
      serviceDTO: json['serviceDTO'],
      serviceDTOList: json['serviceDTOList'],
      responseList: reasons,
    );
  }
}
