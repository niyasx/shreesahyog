// class PreBid2Model {
//   String? responseMessage;
//   String? responseCode;
//   String? serviceDTO;
//   String? serviceDTOList;
//   String? bidStartTime;
//   List<PreBid2ModelResponseList>? responseList;

//   PreBid2Model({
//     this.responseMessage,
//     this.responseCode,
//     this.serviceDTO,
//     this.serviceDTOList,
//     this.bidStartTime,
//     this.responseList,
//   });

//   PreBid2Model.fromJson(Map<String, dynamic> json) {
//     responseMessage = json['responseMessage'].toString().trim();
//     responseCode = json['responseCode'].toString().trim();
//     serviceDTO = json['serviceDTO'].toString().trim();
//     serviceDTOList = json['serviceDTOList'].toString().trim();
//     serviceDTOList = json['bidStartTime'].toString().trim();
//     responseList = (json['responseList'] as List?)
//         ?.map((dynamic e) =>
//             PreBid2ModelResponseList.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['responseMessage'] = responseMessage;
//     json['responseCode'] = responseCode;
//     json['serviceDTO'] = serviceDTO;
//     json['serviceDTOList'] = serviceDTOList;
//     json['responseList'] = responseList?.map((e) => e.toJson()).toList();
//     return json;
//   }
// }

// class PreBid2ModelResponseList {
//   int? plantId;
//   String? plantName;
//   String? materialFrtGrp;
//   String? diType;
//   DateTime? diNumberDate;
//   String? diNumber;
//   String? stateId;
//   String? stateName;
//   String? districtId;
//   String? districtName;
//   String? talukaId;
//   String? talukaName;
//   String? cityId;
//   String? cityName;
//   String? customerId;
//   String? customerName;
//   String? consigneeAddress;
//   String? shipToCityId;
//   String? shipToCityName;
//   String? shipToDistrictId;
//   String? shipToDistrictName;
//   String? brand;
//   String? product;
//   double? diQty;
//   String? diUom;
//   String? frtTerms;
//   String? frtType;
//   double? frtRate;
//   double? basicFrtAmount;
//   double? specialFrt;
//   double? unloadingFrt;
//   double? extFrt;
//   String? diSto;
//   String? soBiddingRemarks;
//   String? routeId;
//   double? kilometers;
//   String? routeDescription;
//   String? dieselPmt;
//   String? freightPmt;
//   String? diStatus;
//   String? datacreatedDate;
//   String? dataupdationDate;
//   String? transporterId;
//   String? transporterName;
//   String? tokenNumber;
//   double? newFrtAmount;
//   String? newFrtRemarks;
//   bool? processed;
//   int? rebidFrequency;
//   DateTime? lastprocessedTime;
//   DateTime? nextProcessingTime;
//   String? updatedBy;

//   PreBid2ModelResponseList({
//     this.plantId,
//     this.plantName,
//     this.materialFrtGrp,
//     this.diType,
//     this.diNumberDate,
//     this.diNumber,
//     this.stateId,
//     this.stateName,
//     this.districtId,
//     this.districtName,
//     this.talukaId,
//     this.talukaName,
//     this.cityId,
//     this.cityName,
//     this.customerId,
//     this.customerName,
//     this.consigneeAddress,
//     this.shipToCityId,
//     this.shipToCityName,
//     this.shipToDistrictId,
//     this.shipToDistrictName,
//     this.brand,
//     this.product,
//     this.diQty,
//     this.diUom,
//     this.frtTerms,
//     this.frtType,
//     this.frtRate,
//     this.basicFrtAmount,
//     this.specialFrt,
//     this.unloadingFrt,
//     this.extFrt,
//     this.diSto,
//     this.soBiddingRemarks,
//     this.routeId,
//     this.kilometers,
//     this.routeDescription,
//     this.dieselPmt,
//     this.freightPmt,
//     this.diStatus,
//     this.datacreatedDate,
//     this.dataupdationDate,
//     this.transporterId,
//     this.transporterName,
//     this.tokenNumber,
//     this.newFrtAmount,
//     this.newFrtRemarks,
//     this.processed,
//     this.rebidFrequency,
//     this.lastprocessedTime,
//     this.nextProcessingTime,
//     this.updatedBy,
//   });

//   PreBid2ModelResponseList.fromJson(Map<String, dynamic> json) {
//     plantId = json['plantId'];
//     plantName = json['plantName'];
//     materialFrtGrp = json['materialFrtGrp'];
//     diType = json['diType'];
//     diNumberDate = json['diNumberDate'];
//     diNumber = json['diNumber'];
//     stateId = json['stateId'];
//     stateName = json['stateName'];
//     districtId = json['districtId'];
//     districtName = json['districtName'];
//     talukaId = json['talukaId'];
//     talukaName = json['talukaName'];
//     cityId = json['cityId'];
//     cityName = json['cityName'];
//     customerId = json['customerId'];
//     customerName = json['customerName'];
//     consigneeAddress = json['consigneeAddress'];
//     shipToCityId = json['shipToCityId'];
//     shipToCityName = json['shipToCityName'];
//     shipToDistrictId = json['shipToDistrictId'];
//     shipToDistrictName = json['shipToDistrictName'];
//     brand = json['brand'];
//     product = json['product'];
//     diQty = json['diQty'];
//     diUom = json['diUom'];
//     frtTerms = json['frtTerms'];
//     frtType = json['frtType'];
//     frtRate = json['frtRate'];
//     basicFrtAmount = json['basicFrtAmount'];
//     specialFrt = json['specialFrt'];
//     unloadingFrt = json['unloadingFrt'];
//     extFrt = json['extFrt'];
//     diSto = json['diSto'];
//     soBiddingRemarks = json['soBiddingRemarks'];
//     routeId = json['routeId'];
//     kilometers = json['kilometers'];
//     routeDescription = json['routeDescription'];
//     dieselPmt = json['dieselPmt'];
//     freightPmt = json['freightPmt'];
//     diStatus = json['diStatus'];
//     datacreatedDate = json['datacreatedDate'];
//     dataupdationDate = json['dataupdationDate'];
//     transporterId = json['transporterId'];
//     transporterName = json['transporterName'];
//     tokenNumber = json['tokenNumber'];
//     newFrtAmount = json['newFrtAmount'];
//     newFrtRemarks = json['newFrtRemarks'];
//     processed = json['processed'];
//     rebidFrequency = json['rebidFrequency'];
//     lastprocessedTime = json['lastprocessedTime'];
//     nextProcessingTime = json['nextProcessingTime'];
//     updatedBy = json['updatedBy'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> json = <String, dynamic>{};
//     json['plantId'] = plantId;
//     json['plantName'] = plantName;
//     json['materialFrtGrp'] = materialFrtGrp;
//     json['diType'] = diType;
//     json['diNumberDate'] = diNumberDate;
//     json['diNumber'] = diNumber;
//     json['stateId'] = stateId;
//     json['stateName'] = stateName;
//     json['districtId'] = districtId;
//     json['districtName'] = districtName;
//     json['talukaId'] = talukaId;
//     json['talukaName'] = talukaName;
//     json['cityId'] = cityId;
//     json['cityName'] = cityName;
//     json['customerId'] = customerId;
//     json['customerName'] = customerName;
//     json['consigneeAddress'] = consigneeAddress;
//     json['shipToCityId'] = shipToCityId;
//     json['shipToCityName'] = shipToCityName;
//     json['shipToDistrictId'] = shipToDistrictId;
//     json['shipToDistrictName'] = shipToDistrictName;
//     json['brand'] = brand;
//     json['product'] = product;
//     json['diQty'] = diQty;
//     json['diUom'] = diUom;
//     json['frtTerms'] = frtTerms;
//     json['frtType'] = frtType;
//     json['frtRate'] = frtRate;
//     json['basicFrtAmount'] = basicFrtAmount;
//     json['specialFrt'] = specialFrt;
//     json['unloadingFrt'] = unloadingFrt;
//     json['extFrt'] = extFrt;
//     json['diSto'] = diSto;
//     json['soBiddingRemarks'] = soBiddingRemarks;
//     json['routeId'] = routeId;
//     json['kilometers'] = kilometers;
//     json['routeDescription'] = routeDescription;
//     json['dieselPmt'] = dieselPmt;
//     json['freightPmt'] = freightPmt;
//     json['diStatus'] = diStatus;
//     json['datacreatedDate'] = datacreatedDate;
//     json['dataupdationDate'] = dataupdationDate;
//     json['transporterId'] = transporterId;
//     json['transporterName'] = transporterName;
//     json['tokenNumber'] = tokenNumber;
//     json['newFrtAmount'] = newFrtAmount;
//     json['newFrtRemarks'] = newFrtRemarks;
//     json['processed'] = processed;
//     json['rebidFrequency'] = rebidFrequency;
//     json['lastprocessedTime'] = lastprocessedTime;
//     json['nextProcessingTime'] = nextProcessingTime;
//     json['updatedBy'] = updatedBy;
//     return json;
//   }
// }

class PreBid2Model {
  String? responseMessage;
  dynamic responseCode;
  ServiceDTO? serviceDTO;
  dynamic serviceDTOList;
  List<PreBid2ModelResponseList>? responseList;

  PreBid2Model(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  PreBid2Model.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'] != null
        ? ServiceDTO.fromJson(json['serviceDTO'])
        : null;
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <PreBid2ModelResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(PreBid2ModelResponseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    if (serviceDTO != null) {
      data['serviceDTO'] = serviceDTO!.toJson();
    }
    data['serviceDTOList'] = serviceDTOList;
    if (responseList != null) {
      data['responseList'] = responseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceDTO {
  dynamic userMobileNo;
  dynamic authToken;
  dynamic password;
  String? bidStartTime;

  ServiceDTO(
      {this.userMobileNo, this.authToken, this.password, this.bidStartTime});

  ServiceDTO.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['userMobileNo'];
    authToken = json['authToken'];
    password = json['password'];
    bidStartTime = json['bidStartTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userMobileNo'] = userMobileNo;
    data['authToken'] = authToken;
    data['password'] = password;
    data['bidStartTime'] = bidStartTime;
    return data;
  }
}

class PreBid2ModelResponseList {
  int? plantId;
  String? plantName;
  String? materialFrtGrp;
  String? diType;
  DateTime? diNumberDate;
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
  double? diQty;
  String? diUom;
  String? frtTerms;
  String? frtType;
  double? frtRate;
  double? basicFrtAmount;
  double? specialFrt;
  double? unloadingFrt;
  double? extFrt;
  String? diSto;
  String? soBiddingRemarks;
  String? routeId;
  double? kilometers;
  String? routeDescription;
  String? dieselPmt;
  String? freightPmt;
  String? diStatus;
  String? datacreatedDate;
  String? dataupdationDate;
  String? transporterId;
  String? transporterName;
  String? tokenNumber;
  double? newFrtAmount;
  String? newFrtRemarks;
  String? bidRemark;
  bool? processed;
  int? rebidFrequency;
  DateTime? lastprocessedTime;
  DateTime? nextProcessingTime;
  String? updatedBy;
  String? transporterP1;
  String? transporterP2;
  double? lowerLimitAmt;
  String? salesOrderNo;
  String? diClubReferenceNo;
  String? diClubRemarks;
  String? diClubbed;
  String? diClubbedDate;
  String? payerBlock;

  PreBid2ModelResponseList(
      {this.plantId,
      this.plantName,
      this.materialFrtGrp,
      this.diType,
      this.diNumberDate,
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
      this.diStatus,
      this.datacreatedDate,
      this.dataupdationDate,
      this.transporterId,
      this.transporterName,
      this.tokenNumber,
      this.newFrtAmount,
      this.newFrtRemarks,
      this.bidRemark,
      this.processed,
      this.rebidFrequency,
      this.lastprocessedTime,
      this.nextProcessingTime,
      this.updatedBy,
      this.transporterP1,
      this.transporterP2,
      this.lowerLimitAmt,
      this.salesOrderNo,
      this.diClubReferenceNo,
      this.diClubRemarks,
      this.diClubbed,
      this.diClubbedDate,
      this.payerBlock,
      });

  PreBid2ModelResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    materialFrtGrp = json['materialFrtGrp'];
    diType = json['diType'];
    diNumberDate = json['diNumberDate'];
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
    diStatus = json['diStatus'];
    datacreatedDate = json['datacreatedDate'];
    dataupdationDate = json['dataupdationDate'];
    transporterId = json['transporterId'];
    transporterName = json['transporterName'];
    tokenNumber = json['tokenNumber'];
    newFrtAmount = json['newFrtAmount'];
    newFrtRemarks = json['newFrtRemarks'];
    bidRemark = json ["bidRemark"];
    processed = json['processed'];
    rebidFrequency = json['rebidFrequency'];
    lastprocessedTime = json['lastprocessedTime'];
    nextProcessingTime = json['nextProcessingTime'];
    updatedBy = json['updatedBy'];
    transporterP1 = json['transporterP1'];
    transporterP2 = json['transporterP2'];
    lowerLimitAmt = json['lowerLimitAmt'];
    salesOrderNo = json ['salesOrderNo'];
    diClubReferenceNo = json["diClubReferenceNo"];
    diClubRemarks = json["diClubRemarks"];
    diClubbed = json["diClubbed"];
    diClubbedDate = json['diClubbedDate'];
    payerBlock = json ['payerBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantName'] = plantName;
    data['materialFrtGrp'] = materialFrtGrp;
    data['diType'] = diType;
    data['diNumberDate'] = diNumberDate;
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
    data['diStatus'] = diStatus;
    data['datacreatedDate'] = datacreatedDate;
    data['dataupdationDate'] = dataupdationDate;
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    data['tokenNumber'] = tokenNumber;
    data['newFrtAmount'] = newFrtAmount;
    data['newFrtRemarks'] = newFrtRemarks;
    data['bidRemark'] = bidRemark;
    data['processed'] = processed;
    data['rebidFrequency'] = rebidFrequency;
    data['lastprocessedTime'] = lastprocessedTime;
    data['nextProcessingTime'] = nextProcessingTime;
    data['updatedBy'] = updatedBy;
    data['salesOrderNo'] = salesOrderNo;
    data['diClubReferenceNo'] = diClubReferenceNo;
    data['diClubRemarks'] = diClubRemarks;
    data['diClubbed'] = diClubbed;
    data['diClubbedDate'] = diClubbedDate;
    data['payerBlock'] = payerBlock;
    return data;
  }
}
