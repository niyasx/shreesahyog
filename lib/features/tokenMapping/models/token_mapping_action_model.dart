class TokenMappingActionModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<TokenMappingActionResponseList>? responseList;

  TokenMappingActionModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  TokenMappingActionModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <TokenMappingActionResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(TokenMappingActionResponseList.fromJson(v));
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

class TokenMappingActionResponseList {
  num? plantId;
  String? plantName;
  String? materialFrtGrp;
  String? diType;
  String? diNumber;
  String? stateId;
  String? stateName;
  String? districtId;
  String? districtName;
  String? talukaId;
  String? talukaName;
  String? cityId;
  String? cityName;
  String? customerId;
  String? customerName;
  String? consigneeAddress;
  String? shipToCityId;
  String? shipToCityName;
  String? shipToDistrictId;
  String? shipToDistrictName;
  String? brand;
  String? product;
  num? diQty;
  String? diUom;
  dynamic frtTerms;
  dynamic frtType;
  String? soBiddingRemarks;
  String? transporterId;
  String? transporterName;
  String? tokenNumber;
  dynamic newFrtAmount;
  double? winFrtAmount;
  String? reasonForDiAllotment;
  String? remainingTime;
  String? payerBlock;

  TokenMappingActionResponseList(
      {this.plantId,
      this.plantName,
      this.materialFrtGrp,
      this.diType,
      this.diNumber,
      this.stateId,
      this.stateName,
      this.districtId,
      this.districtName,
      this.talukaId,
      this.talukaName,
      this.cityId,
      this.cityName,
      this.customerId,
      this.customerName,
      this.consigneeAddress,
      this.shipToCityId,
      this.shipToCityName,
      this.shipToDistrictId,
      this.shipToDistrictName,
      this.brand,
      this.product,
      this.diQty,
      this.diUom,
      this.frtTerms,
      this.frtType,
      this.soBiddingRemarks,
      this.transporterId,
      this.transporterName,
      this.tokenNumber,
      this.newFrtAmount,
      this.winFrtAmount,
      this.remainingTime,
      this.reasonForDiAllotment,
      this.payerBlock});

  TokenMappingActionResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    materialFrtGrp = json['materialFrtGrp'];
    diType = json['diType'];
    diNumber = json['diNumber'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    talukaId = json['talukaId'];
    talukaName = json['talukaName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    consigneeAddress = json['consigneeAddress'];
    shipToCityId = json['shipToCityId'];
    shipToCityName = json['shipToCityName'];
    shipToDistrictId = json['shipToDistrictId'];
    shipToDistrictName = json['shipToDistrictName'];
    brand = json['brand'];
    product = json['product'];
    diQty = json['diQty'];
    diUom = json['diUom'];
    frtTerms = json['frtTerms'];
    frtType = json['frtType'];
    soBiddingRemarks = json['soBiddingRemarks'];
    transporterId = json['transporterId'];
    transporterName = json['transporterName'];
    tokenNumber = json['tokenNumber'];
    newFrtAmount = json['newFrtAmount'];
    winFrtAmount = json['winFrtAmount'];
    remainingTime = json['remainingTime'];
    reasonForDiAllotment = json['reasonForDiAllotment'];
    payerBlock = json['payerBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantName'] = plantName;
    data['materialFrtGrp'] = materialFrtGrp;
    data['diType'] = diType;
    data['diNumber'] = diNumber;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['talukaId'] = talukaId;
    data['talukaName'] = talukaName;
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['consigneeAddress'] = consigneeAddress;
    data['shipToCityId'] = shipToCityId;
    data['shipToCityName'] = shipToCityName;
    data['shipToDistrictId'] = shipToDistrictId;
    data['shipToDistrictName'] = shipToDistrictName;
    data['brand'] = brand;
    data['product'] = product;
    data['diQty'] = diQty;
    data['diUom'] = diUom;
    data['frtTerms'] = frtTerms;
    data['frtType'] = frtType;
    data['soBiddingRemarks'] = soBiddingRemarks;
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    data['tokenNumber'] = tokenNumber;
    data['newFrtAmount'] = newFrtAmount;
    data['winFrtAmount'] = winFrtAmount;
    data['payerBlock'] = payerBlock;
    return data;
  }
}
