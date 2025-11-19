class TransporterBid2Model {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<TransporterBid2ModelResponseList>? responseList;

  TransporterBid2Model(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  TransporterBid2Model.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <TransporterBid2ModelResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(TransporterBid2ModelResponseList.fromJson(v));
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

class TransporterBid2ModelResponseList {
  int? plantId;
  String? bidLotId;
  String? plantName;
  String? materialFrtGrp;
  String? division;
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
  num? basicFrtAmount;
  dynamic bidRate;
  String? diSto;
  String? soBiddingRemarks;
  String? bidRemark;
  String? routeId;
  num? kilometers;
  String? routeDescription;
  num? newFrtAmount;
  DateTime? startTime;
  DateTime? endTime;
  double? lowerLimitAmt;
  String? salesOrderNo;
  String? diClubReferenceNo;
  String? diClubRemarks;
  
  // Static counter to track how many instances have been created
  static int counter = 0;
  
  TransporterBid2ModelResponseList({
    this.plantId,
    this.lowerLimitAmt,
    this.bidLotId,
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
    this.basicFrtAmount,
    this.bidRate,
    this.diSto,
    this.soBiddingRemarks,
    this.bidRemark,
    this.routeId,
    this.kilometers,
    this.routeDescription,
    this.newFrtAmount,
    this.startTime,
    this.endTime,
    this.salesOrderNo,
    this.diClubReferenceNo,
    this.diClubRemarks
  });

  static void resetCounter() {
    counter = 0;
    print("Counter reset to 0");
  }
  
  TransporterBid2ModelResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    bidLotId = json['bidLotId'];
    lowerLimitAmt = json['lowerLimitAmt'];
    plantName = json['plantName'];
    materialFrtGrp = json['materialFrtGrp'];
    division = json['division'];
    diType = json['diType'];
    diDate = json['diDate'];
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
    basicFrtAmount = json['basicFrtAmount'];
    bidRate = json['bidRate'];
    diSto = json['diSto'];
    soBiddingRemarks = json['soBiddingRemarks'];
    bidRemark = json['bidRemark'];
    routeId = json['routeId'];
    kilometers = json['kilometers'];
    routeDescription = json['routeDescription'];
    newFrtAmount = json['newFrtAmount'];
    
    try {
      startTime = json['startTime'] != null ? DateTime.parse(json['startTime']) : null;
      endTime = json['endTime'] != null ? DateTime.parse(json['endTime']) : null;
    } catch (e) {
      print("Error parsing dates: $e");
      startTime = null;
      endTime = null;
    }
    
    salesOrderNo = json['salesOrderNo'];
    diClubReferenceNo = json['diClubReferenceNo'];
    diClubRemarks = json['diClubRemarks'];
    
   
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['bidLotId'] = bidLotId;
    data['lowerLimitAmt'] = lowerLimitAmt;
    data['plantName'] = plantName;
    data['materialFrtGrp'] = materialFrtGrp;
    data['division'] = division;
    data['diType'] = diType;
    data['diDate'] = diDate;
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
    data['basicFrtAmount'] = basicFrtAmount;
    data['bidRate'] = bidRate;
    data['diSto'] = diSto;
    data['soBiddingRemarks'] = soBiddingRemarks;
    data['bidRemark'] = bidRemark;
    data['routeId'] = routeId;
    data['kilometers'] = kilometers;
    data['routeDescription'] = routeDescription;
    data['newFrtAmount'] = newFrtAmount;
    data['startTime'] = startTime?.toIso8601String();
    data['endTime'] = endTime?.toIso8601String();
    data['salesOrderNo'] = salesOrderNo;
    data['diClubReferenceNo'] = diClubReferenceNo;
    data['diClubRemarks'] = diClubRemarks;
    return data;
  }
}

class BidDetailsPayload {
  final String? diNumber;
  final num? bidRate;
  final String? transporterId;
  final String? createdBy;
  final String? bidLotId;
  final bool? resultProcessed;

  BidDetailsPayload({
    this.diNumber,
    this.bidRate,
    this.transporterId,
    this.createdBy,
    this.bidLotId,
    this.resultProcessed,
  });

  Map<String, dynamic> toJson() {
    return {
      'diNumber': diNumber,
      'bidRate': bidRate,
      'transporterId': transporterId,
      'createdBy': createdBy,
      'bidLotId': bidLotId,
      'resultProcessed': resultProcessed,
    };
  }
}
