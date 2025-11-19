class ValidateFreightLogisticsModel {
  String? responseMessage;
  String? responseCode;
  ServiceDTO? serviceDTO;
  dynamic serviceDTOList;

  ValidateFreightLogisticsModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList});

  ValidateFreightLogisticsModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'] != null
        ? ServiceDTO.fromJson(json['serviceDTO'])
        : null;
    serviceDTOList = json['serviceDTOList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    if (serviceDTO != null) {
      data['serviceDTO'] = serviceDTO!.toJson();
    }
    data['serviceDTOList'] = serviceDTOList;
    return data;
  }
}

class ServiceDTO {
  dynamic userMobileNo;
  dynamic authToken;
  dynamic password;
  String? billNo;
  String? approvedOrRejectetRemarks;
  String? billStatus;
  String? billDate;
  double? frtNetAmount;
  double? netAmount;
  double? sgst;
  double? cgst;
  double? igst;
  String? transporterId;
  String? transporterName;
  int? plantCode;
  List<LogisticApprovalDiList>? logisticApprovalDiList;

  ServiceDTO(
      {this.userMobileNo,
      this.authToken,
      this.password,
      this.billNo,
      this.billDate,
      this.frtNetAmount,
      this.netAmount,
      this.sgst,
      this.cgst,
      this.igst,
      this.transporterId,
      this.transporterName,
      this.plantCode,
      this.billStatus,
      this.logisticApprovalDiList,
      this.approvedOrRejectetRemarks});

  ServiceDTO.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['userMobileNo'];
    authToken = json['authToken'];
    password = json['password'];
    approvedOrRejectetRemarks = json['approvedOrRejectetRemarks'];
    billNo = json['billNo'];
    billDate = json['billDate'];
    frtNetAmount = json['frtNetAmount'];
    netAmount = json['netAmount'];
    sgst = json['sgst'];
    billStatus = json['billStatus'];
    cgst = json['cgst'];
    igst = json['igst'];
    transporterId = json['transporterId'];
    plantCode = json["plantCode"];
    transporterName = json['transporterName'];
    if (json['logisticApprovalDiList'] != null) {
      logisticApprovalDiList = <LogisticApprovalDiList>[];
      json['logisticApprovalDiList'].forEach((v) {
        logisticApprovalDiList!.add(LogisticApprovalDiList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userMobileNo'] = userMobileNo;
    data['authToken'] = authToken;
    data['password'] = password;
    data['approvedOrRejectetRemarks'] = approvedOrRejectetRemarks;
    data['billNo'] = billNo;
    data['billDate'] = billDate;
    data['billStatus'] = billStatus;
    data['frtNetAmount'] = frtNetAmount;
    data['netAmount'] = netAmount;
    data['sgst'] = sgst;
    data['cgst'] = cgst;
    data['igst'] = igst;
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    if (logisticApprovalDiList != null) {
      data['logisticApprovalDiList'] =
          logisticApprovalDiList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LogisticApprovalDiList {
  int? billDetailsId;
  String? billNo;
  String? billDate;
  String? diNo;
  String? tokenNo;
  String? invoiceNo;
  String? invoiceDate;
  String? shipTo;
  String? shipToCityId;
  String? shipToCityName;
  String? customerCityName;
  String? truckNo;
  String? unloadBy;
  int? plantId;
  double? unloadingFrt;
  double? diQuantity;
  double? unloadAmount;
  String? stateName;
  String? districtName;
  String? grnAndMrnNo;
  double? frtAmount;
  double? tollTax;
  double? other;
  double? kata;
  double? grossWeight;
  double? tareWeight;
  double? netWeight;
  double? tyreAmount;
  String? grNumber;
  double? frtNetAmount;
  double? netAmount;
  double? totalAmount;
  String? transporterId;
  String? transporterName;
  double? sgst;
  double? cgst;
  double? igst;
  String? remarks;
  String? diType;
  double? shortageQty;
  double? specialFrtRate;
  double? unloadingFrtRate;
  String? uom;
  int? tokenRank;

  LogisticApprovalDiList(
      {this.billDetailsId,
      this.billNo,
      this.billDate,
      this.tokenRank,
      this.diNo,
      this.tokenNo,
      this.invoiceNo,
      this.invoiceDate,
      this.shipTo,
      this.shipToCityId,
      this.shipToCityName,
      this.customerCityName,
      this.truckNo,
      this.unloadBy,
      this.plantId,
      this.unloadingFrt,
      this.diQuantity,
      this.unloadAmount,
      this.stateName,
      this.districtName,
      this.grnAndMrnNo,
      this.frtAmount,
      this.tollTax,
      this.other,
      this.kata,
      this.grossWeight,
      this.tareWeight,
      this.netWeight,
      this.tyreAmount,
      this.grNumber,
      this.frtNetAmount,
      this.netAmount,
      this.totalAmount,
      this.transporterId,
      this.transporterName,
      this.sgst,
      this.cgst,
      this.igst,
      this.remarks,
      this.diType,
      this.specialFrtRate,
      this.unloadingFrtRate,
      this.shortageQty,
      this.uom});

  LogisticApprovalDiList.fromJson(Map<String, dynamic> json) {
    billDetailsId = json['billDetailsId'];
    billNo = json['billNo'];
    billDate = json['billDate'];
    tokenRank = json['tokenRank'];
    diNo = json['diNo'];
    tokenNo = json['tokenNo'];
    invoiceNo = json['invoiceNo'];
    invoiceDate = json['invoiceDate'];
    shipTo = json['shipTo'];
    shipToCityId = json['shipToCityId'];
    shipToCityName = json['shipToCityName'];
    customerCityName = json['customerCityName'];
    truckNo = json['truckNo'];
    unloadBy = json['unloadBy'];
    plantId = json['plantId'];
    unloadingFrt = json['unloadingFrt'];
    diQuantity = json['diQuantity'];
    unloadAmount = json['unloadAmount'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    grnAndMrnNo = json['grnAndMrnNo'];
    frtAmount = json['frtAmount'];
    tollTax = json['tollTax'];
    other = json['other'];
    kata = json['kata'];
    grossWeight = json['grossWeight'];
    tareWeight = json['tareWeight'];
    netWeight = json['netWeight'];
    tyreAmount = json['tyreAmount'];
    grNumber = json['grNumber'];
    frtNetAmount = json['frtNetAmount'];
    netAmount = json['netAmount'];
    totalAmount = json['totalAmount'];
    transporterId = json['transporterId'];
    transporterName = json['transporterName'];
    sgst = json['sgst'];
    cgst = json['cgst'];
    igst = json['igst'];
    remarks = json['remarks'];
    diType = json['diType'];
    specialFrtRate = json['specialFrtRate'];
    unloadingFrtRate = json['unloadingFrtRate'];
    shortageQty = json['shortageQty'];
    uom = json['uom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billDetailsId'] = billDetailsId;
    data['billNo'] = billNo;
    data['billDate'] = billDate;
    data['diNo'] = diNo;
    data['tokenRank'] = tokenRank;
    data['tokenNo'] = tokenNo;
    data['invoiceNo'] = invoiceNo;
    data['invoiceDate'] = invoiceDate;
    data['shipTo'] = shipTo;
    data['shipToCityId'] = shipToCityId;
    data['shipToCityName'] = shipToCityName;
    data['truckNo'] = truckNo;
    data['unloadBy'] = unloadBy;
    data['plantId'] = plantId;
    data['unloadingFrt'] = unloadingFrt;
    data['diQuantity'] = diQuantity;
    data['unloadAmount'] = unloadAmount;
    data['stateName'] = stateName;
    data['districtName'] = districtName;
    data['grnAndMrnNo'] = grnAndMrnNo;
    data['frtAmount'] = frtAmount;
    data['tollTax'] = tollTax;
    data['other'] = other;
    data['kata'] = kata;
    data['grossWeight'] = grossWeight;
    data['tareWeight'] = tareWeight;
    data['netWeight'] = netWeight;
    data['tyreAmount'] = tyreAmount;
    data['grNumber'] = grNumber;
    data['frtNetAmount'] = frtNetAmount;
    data['netAmount'] = netAmount;
    data['totalAmount'] = totalAmount;
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    data['sgst'] = sgst;
    data['cgst'] = cgst;
    data['igst'] = igst;
    data['uom'] = uom;
    return data;
  }
}
