class DIPendencyResponseListModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<PendingDIResponseList>? responseList;

  DIPendencyResponseListModel(
      {this.responseMessage,
        this.responseCode,
        this.serviceDTO,
        this.serviceDTOList,
        this.responseList});

  DIPendencyResponseListModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <PendingDIResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(PendingDIResponseList.fromJson(v));
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

class PendingDIResponseList {
  String? diNumber;
  String? diDate;
  int? days;
  int? diQty;
  String? brand;
  String? category;
  String? product;
  String? materialFrtGrpName;
  String? bagType;
  String? consignorName;
  String? consignorAddress;
  String? customerName;
  String? cityName;
  String? talukaName;
  String? districtName;
  String? stateName;
  String? frtTerms;
  String? incoTerms;
  double? frtRate;
  int? bidRate;
  double? newFrtAmount;
  String? tokenNumber;
  String? truckNumber;
  String? truckStatus;
  String? soBiddingRemarks;
  String? transporterName;
  String? transporterId;
  String? salesOrderNo;

  PendingDIResponseList(
      {this.diNumber,
        this.diDate,
        this.days,
        this.diQty,
        this.brand,
        this.category,
        this.product,
        this.materialFrtGrpName,
        this.bagType,
        this.consignorName,
        this.consignorAddress,
        this.customerName,
        this.cityName,
        this.talukaName,
        this.districtName,
        this.stateName,
        this.frtTerms,
        this.incoTerms,
        this.frtRate,
        this.bidRate,
        this.newFrtAmount,
        this.tokenNumber,
        this.truckNumber,
        this.truckStatus,
        this.soBiddingRemarks,
        this.transporterName,
        this.transporterId,
        this.salesOrderNo});

  PendingDIResponseList.fromJson(Map<String, dynamic> json) {
    diNumber = json['diNumber'];
    diDate = json['diDate'];
    days = json['days'];
    diQty = json['diQty'];
    brand = json['brand'];
    category = json['category'];
    product = json['product'];
    materialFrtGrpName = json['materialFrtGrpName'];
    bagType = json['bagType'];
    consignorName = json['consignorName'];
    consignorAddress = json['consignorAddress'];
    customerName = json['customerName'];
    cityName = json['cityName'];
    talukaName = json['talukaName'];
    districtName = json['districtName'];
    stateName = json['stateName'];
    frtTerms = json['frtTerms'];
    incoTerms = json['incoTerms'];
    frtRate = json['frtRate'];
    bidRate = json['bidRate'];
    newFrtAmount = json['newFrtAmount'];
    tokenNumber = json['tokenNumber'];
    truckNumber = json['truckNumber'];
    truckStatus = json['truckStatus'];
    soBiddingRemarks = json['soBiddingRemarks'];
    transporterName = json['transporterName'];
    transporterId = json['transporterId'];
    salesOrderNo = json['salesOrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diNumber'] = diNumber;
    data['diDate'] = diDate;
    data['days'] = days;
    data['diQty'] = diQty;
    data['brand'] = brand;
    data['category'] = category;
    data['product'] = product;
    data['materialFrtGrpName'] = materialFrtGrpName;
    data['bagType'] = bagType;
    data['consignorName'] = consignorName;
    data['consignorAddress'] = consignorAddress;
    data['customerName'] = customerName;
    data['cityName'] = cityName;
    data['talukaName'] = talukaName;
    data['districtName'] = districtName;
    data['stateName'] = stateName;
    data['frtTerms'] = frtTerms;
    data['incoTerms'] = incoTerms;
    data['frtRate'] = frtRate;
    data['bidRate'] = bidRate;
    data['newFrtAmount'] = newFrtAmount;
    data['tokenNumber'] = tokenNumber;
    data['truckNumber'] = truckNumber;
    data['truckStatus'] = truckStatus;
    data['soBiddingRemarks'] = soBiddingRemarks;
    data['transporterName'] = transporterName;
    data['transporterId'] = transporterId;
    data['salesOrderNo'] = salesOrderNo;
    return data;
  }
}
