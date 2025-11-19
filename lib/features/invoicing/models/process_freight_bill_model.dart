class ProcessFreightBillModel {
  String? responseMessage;
  String? responseCode;
  ServiceDTO? serviceDTO;
  dynamic serviceDTOList;
  dynamic responseList;

  ProcessFreightBillModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  ProcessFreightBillModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'] != null
        ? ServiceDTO.fromJson(json['serviceDTO'])
        : null;
    serviceDTOList = json['serviceDTOList'];
    responseList = json['responseList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    if (serviceDTO != null) {
      data['serviceDTO'] = serviceDTO!.toJson();
    }
    data['serviceDTOList'] = serviceDTOList;
    data['responseList'] = responseList;
    return data;
  }
}

class ServiceDTO {
  dynamic userMobileNo;
  dynamic authToken;
  dynamic password;
  String? billNo;
  String? billDate;
  int? plantId;
  double? frtNetAmount;
  double? deductedAmount;
  double? netAmount;
  List<DiDetails>? diDetails;
  double? utgst;
  double? igst;
  double? cgst;
  double? sgst;

  ServiceDTO(
      {this.userMobileNo,
      this.authToken,
      this.password,
      this.billNo,
      this.billDate,
      this.plantId,
      this.frtNetAmount,
      this.deductedAmount,
      this.netAmount,
      this.diDetails,
      this.utgst,
      this.igst,
      this.cgst,
      this.sgst});

  ServiceDTO.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['userMobileNo'];
    authToken = json['authToken'];
    password = json['password'];
    billNo = json['billNo'];
    billDate = json['billDate'];
    plantId = json['plantId'];
    frtNetAmount = json['frtNetAmount'];
    deductedAmount = json['deductedAmount'];
    netAmount = json['netAmount'];
    if (json['diDetails'] != null) {
      diDetails = <DiDetails>[];
      json['diDetails'].forEach((v) {
        diDetails!.add(DiDetails.fromJson(v));
      });
    }
    utgst = json['utgst'];
    igst = json['igst'];
    cgst = json['cgst'];
    sgst = json['sgst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userMobileNo'] = userMobileNo;
    data['authToken'] = authToken;
    data['password'] = password;
    data['billNo'] = billNo;
    data['billDate'] = billDate;
    data['plantId'] = plantId;
    data['frtNetAmount'] = frtNetAmount;
    data['deductedAmount'] = deductedAmount;
    data['netAmount'] = netAmount;
    if (diDetails != null) {
      data['diDetails'] = diDetails!.map((v) => v.toJson()).toList();
    }
    data['utgst'] = utgst;
    data['igst'] = igst;
    data['cgst'] = cgst;
    data['sgst'] = sgst;
    return data;
  }
}

class DiDetails {
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
  double? deductedAmount;
  bool? isInitiated;
  String? grnAndMrnNo;
  double? frtAmount;
  double? tollTax;
  double? other;
  double? kata;
  double? grossWeight;
  double? tareWeight;
  double? totalDiQuantity;
  double? netWeight;
  double? tyreAmount;
  String? grNumber;
  double? frtNetAmount;
  double? netAmount;
  double? totalAmount;
  double? igst;
  double? cgst;
  double? sgst;
  double? specialFrtRate;
  double? unloadingFrtRate;
  String? uom;

  DiDetails(
      {this.billDetailsId,
      this.billNo,
      this.billDate,
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
      this.deductedAmount,
      this.isInitiated,
      this.grnAndMrnNo,
      this.frtAmount,
      this.tollTax,
      this.other,
      this.kata,
      this.grossWeight,
      this.tareWeight,
      this.totalDiQuantity,
      this.netWeight,
      this.tyreAmount,
      this.grNumber,
      this.frtNetAmount,
      this.netAmount,
      this.totalAmount,
      this.igst,
      this.cgst,
      this.sgst,
      this.specialFrtRate,
      this.unloadingFrtRate,
      this.uom});

  DiDetails.fromJson(Map<String, dynamic> json) {
    billDetailsId = json['billDetailsId'];
    billNo = json['billNo'];
    billDate = json['billDate'];
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
    isInitiated = json['isInitiated'];
    grnAndMrnNo = json['grnAndMrnNo'];
    frtAmount = json['frtAmount'];
    tollTax = json['tollTax'];
    other = json['other'];
    kata = json['kata'];
    grossWeight = json['grossWeight'];
    tareWeight = json['tareWeight'];
    totalDiQuantity = json['totalDiQuantity'];
    netWeight = json['netWeight'];
    tyreAmount = json['tyreAmount'];
    grNumber = json['grNumber'];
    frtNetAmount = json['frtNetAmount'];
    netAmount = json['netAmount'];
    totalAmount = json['totalAmount'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    igst = json['igst'];
    specialFrtRate = json['specialFrtRate'];
    unloadingFrtRate = json['unloadingFrtRate'];
    uom = json['uom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billDetailsId'] = billDetailsId;
    data['billNo'] = billNo;
    data['billDate'] = billDate;
    data['diNo'] = diNo;
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
    data['deductedAmount'] = deductedAmount;
    data['isInitiated'] = isInitiated;
    data['grnAndMrnNo'] = grnAndMrnNo;
    data['frtAmount'] = frtAmount;
    data['tollTax'] = tollTax;
    data['other'] = other;
    data['kata'] = kata;
    data['grossWeight'] = grossWeight;
    data['tareWeight'] = tareWeight;
    data['totalDiQuantity'] = totalDiQuantity;
    data['netWeight'] = netWeight;
    data['tyreAmount'] = tyreAmount;
    data['grNumber'] = grNumber;
    data['frtNetAmount'] = frtNetAmount;
    data['netAmount'] = netAmount;
    data['totalAmount'] = totalAmount;
    data['cgst'] = cgst;
    data['sgst'] = sgst;
    data['uom'] = uom;
    return data;
  }
}
