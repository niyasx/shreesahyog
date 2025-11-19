class TokenMappingLinkListModel {
  int? plantId;
  String? materialFrtGrpName;
  String? plantName;
  String? materialFrtGrp;
  String? division;
  String? modeOfTranport;
  String? diType;
  String? diDate;
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
  String? frtTerms;
  String? frtType;
  num? frtRate;
  num? basicFrtAmount;
  num? specialFrt;
  num? unloadingFrt;
  num? extFrt;
  String? diSto;
  String? soBiddingRemarks;
  String? routeId;
  num? kilometers;
  String? routeDescription;
  String? dieselPmt;
  String? freightPmt;
  String? bidStatus;
  String? salesOrderNo;
  String? diStatus;
  String? createdDate;
  String? dataUpdationDate;
  String? transporterId;
  String? transporterName;
  String? tokenNumber;
  num? newFrtAmount;
  double? winFrtAmount;
  String? newFrtRemarks;
  String? reasonForDiAllotment;
  bool? processed;
  num? rebidFrequency;
  String? lastProcessedTime;
  String? nextProcessedTime;
  String? updationDate;
  String? updatedBy;
  String? updatedByJob;

  TokenMappingLinkListModel(
      {this.plantId,
      this.winFrtAmount,
      this.plantName,
      this.materialFrtGrp,
      this.division,
      this.diType,
      this.diDate,
      this.diNumber,
      this.stateId,
      this.stateName,
      this.districtId,
      this.districtName,
      this.talukaId,
      this.talukaName,
      this.cityId,
      this.modeOfTranport,
      this.cityName,
      this.customerId,
      this.customerName,
      this.consigneeAddress,
      this.materialFrtGrpName,
      this.shipToCityId,
      this.salesOrderNo,
      this.shipToCityName,
      this.shipToDistrictId,
      this.shipToDistrictName,
      this.brand,
      this.product,
      this.diQty,
      this.diUom,
      this.frtTerms,
      this.frtType,
      this.frtRate,
      this.basicFrtAmount,
      this.specialFrt,
      this.unloadingFrt,
      this.extFrt,
      this.diSto,
      this.soBiddingRemarks,
      this.routeId,
      this.kilometers,
      this.routeDescription,
      this.dieselPmt,
      this.freightPmt,
      this.bidStatus,
      this.diStatus,
      this.createdDate,
      this.dataUpdationDate,
      this.transporterId,
      this.transporterName,
      this.tokenNumber,
      this.newFrtAmount,
      this.newFrtRemarks,
      this.reasonForDiAllotment,
      this.processed,
      this.rebidFrequency,
      this.lastProcessedTime,
      this.nextProcessedTime,
      this.updationDate,
      this.updatedBy,
      this.updatedByJob});

  TokenMappingLinkListModel.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    materialFrtGrp = json['materialFrtGrp'];
    division = json['division'];
    diType = json['diType'];
    diDate = json['diDate'];
    diNumber = json['diNumber'];
    materialFrtGrpName = json['materialFrtGrpName'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    talukaId = json['talukaId'];
    talukaName = json['talukaName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    modeOfTranport = json['modeOfTranport'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    consigneeAddress = json['consigneeAddress'];
    shipToCityId = json['shipToCityId'];
    shipToCityName = json['shipToCityName'];
    shipToDistrictId = json['shipToDistrictId'];
    shipToDistrictName = json['shipToDistrictName'];
    winFrtAmount = json['winFrtAmount'];
    brand = json['brand'];
    product = json['product'];
    diQty = json['diQty'];
    diUom = json['diUom'];
    frtTerms = json['frtTerms'];
    frtType = json['frtType'];
    frtRate = json['frtRate'];
    basicFrtAmount = json['basicFrtAmount'];
    specialFrt = json['specialFrt'];
    unloadingFrt = json['unloadingFrt'];
    extFrt = json['extFrt'];
    diSto = json['diSto'];
    soBiddingRemarks = json['soBiddingRemarks'];
    routeId = json['routeId'];
    kilometers = json['kilometers'];
    routeDescription = json['routeDescription'];
    dieselPmt = json['dieselPmt'];
    freightPmt = json['freightPmt'];
    salesOrderNo = json['salesOrderNo'];
    bidStatus = json['bidStatus'];
    diStatus = json['diStatus'];
    createdDate = json['createdDate'];
    dataUpdationDate = json['dataUpdationDate'];
    transporterId = json['transporterId'];
    transporterName = json['transporterName'];
    tokenNumber = json['tokenNumber'];
    newFrtAmount = json['newFrtAmount'];
    newFrtRemarks = json['newFrtRemarks'];
    reasonForDiAllotment = json['reasonForDiAllotment'];
    processed = json['processed'];
    rebidFrequency = json['rebidFrequency'];
    lastProcessedTime = json['lastProcessedTime'];
    nextProcessedTime = json['nextProcessedTime'];
    updationDate = json['updationDate'];
    updatedBy = json['updatedBy'];
    updatedByJob = json['updatedByJob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantName'] = plantName;
    data['materialFrtGrp'] = materialFrtGrp;
    data['division'] = division;
    data['diType'] = diType;
    data['diDate'] = diDate;
    data['diNumber'] = diNumber;
    data['modeOfTranport'] = modeOfTranport;
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
    data['materialFrtGrpName'] = materialFrtGrpName;
    data['brand'] = brand;
    data['product'] = product;
    data['diQty'] = diQty;
    data['diUom'] = diUom;
    data['frtTerms'] = frtTerms;
    data['frtType'] = frtType;
    data['frtRate'] = frtRate;
    data['basicFrtAmount'] = basicFrtAmount;
    data['specialFrt'] = specialFrt;
    data['unloadingFrt'] = unloadingFrt;
    data['extFrt'] = extFrt;
    data['diSto'] = diSto;
    data['soBiddingRemarks'] = soBiddingRemarks;
    data['routeId'] = routeId;
    data['kilometers'] = kilometers;
    data['routeDescription'] = routeDescription;
    data['dieselPmt'] = dieselPmt;
    data['freightPmt'] = freightPmt;
    data['bidStatus'] = bidStatus;
    data['diStatus'] = diStatus;
    data['createdDate'] = createdDate;
    data['dataUpdationDate'] = dataUpdationDate;
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    data['tokenNumber'] = tokenNumber;
    data['newFrtAmount'] = newFrtAmount;
    data['newFrtRemarks'] = newFrtRemarks;
    data['reasonForDiAllotment'] = reasonForDiAllotment;
    data['processed'] = processed;
    data['salesOrderNo'] = salesOrderNo;
    data['rebidFrequency'] = rebidFrequency;
    data['lastProcessedTime'] = lastProcessedTime;
    data['nextProcessedTime'] = nextProcessedTime;
    data['updationDate'] = updationDate;
    data['updatedBy'] = updatedBy;
    data['winFrtAmount'] = winFrtAmount;
    data['updatedByJob'] = updatedByJob;
    return data;
  }
}
