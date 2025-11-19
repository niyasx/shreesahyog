class BusinessRules {
  String? responseMessage;
  dynamic responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ResponseListOfBusinessRules>? responseList;

  BusinessRules(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  BusinessRules.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ResponseListOfBusinessRules>[];
      json['responseList'].forEach((v) {
        responseList!.add(ResponseListOfBusinessRules.fromJson(v));
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

class ResponseListOfBusinessRules {
  int? plantMasterId;
  int? plantCode;
  String? plantName;
  bool? status;
  double? diGreaterThanPenalty;
  double? diLessThanPenalty;
  double? diQty;
  double? preBidIncFrtAmt;
  double? preBidDecFrtAmt;
  double? frtLowerTol;
  double? frtHigherTol;
  int? manualRebidTime;
  bool? transporterPriorityStatus;
  double? lowerLimitTsh;

  ResponseListOfBusinessRules(
      {this.plantMasterId,
      this.plantCode,
      this.plantName,
      this.status,
      this.diGreaterThanPenalty,
      this.diLessThanPenalty,
      this.diQty,
      this.preBidIncFrtAmt,
      this.preBidDecFrtAmt,
      this.frtLowerTol,
      this.frtHigherTol,
      this.manualRebidTime,
      this.transporterPriorityStatus,
      this.lowerLimitTsh});

  ResponseListOfBusinessRules.fromJson(Map<String, dynamic> json) {
    plantMasterId = json['plantMasterId'];
    plantCode = json['plantCode'];
    plantName = json['plantName'];
    status = json['status'];
    diGreaterThanPenalty = json['diGreaterThanPenalty'];
    diLessThanPenalty = json['diLessThanPenalty'];
    diQty = json['diQty'];
    preBidIncFrtAmt = json['preBidIncFrtAmt'];
    preBidDecFrtAmt = json['preBidDecFrtAmt'];
    frtLowerTol = json['frtLowerTol'];
    frtHigherTol = json['frtHigherTol'];
    manualRebidTime = json['manualRebidTime'];
    transporterPriorityStatus = json['transporterPriorityStatus'];
    lowerLimitTsh = json["lowerLimitTsh"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantMasterId'] = plantMasterId;
    data['plantCode'] = plantCode;
    data['plantName'] = plantName;
    data['status'] = status;
    data['diGreaterThanPenalty'] = diGreaterThanPenalty;
    data['diLessThanPenalty'] = diLessThanPenalty;
    data['diQty'] = diQty;
    data['preBidIncFrtAmt'] = preBidIncFrtAmt;
    data['preBidDecFrtAmt'] = preBidDecFrtAmt;
    data['frtLowerTol'] = frtLowerTol;
    data['frtHigherTol'] = frtHigherTol;
    data['manualRebidTime'] = manualRebidTime;
    return data;
  }
}
