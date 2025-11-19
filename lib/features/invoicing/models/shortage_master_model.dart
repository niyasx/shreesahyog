class ShortageMasterModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ShortageMasterResponseList>? responseList;

  ShortageMasterModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  ShortageMasterModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ShortageMasterResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(ShortageMasterResponseList.fromJson(v));
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

class ShortageMasterResponseList {
  int? shortageMasterId;
  String? divisionType;
  String? stateName;
  String? product;
  String? uom;
  int? ratePerUnitQuantity;
  String? fromDate;
  String? toDate;
  String? oldToDate;
  int? waiveOffQuantity;
  int? cmtLooseWaiveOff;
  int? cmtLooseRatio;
  String? createdDate;
  String? createdBy;
  String? modifiedDate;
  String? modifiedBy;
  bool? updated;
  String? stateCode;
  int? productId;
  int? uomId;

  ShortageMasterResponseList(
      {this.shortageMasterId,
      this.divisionType,
      this.stateName,
      this.product,
      this.uom,
      this.ratePerUnitQuantity,
      this.fromDate,
      this.toDate,
      this.oldToDate,
      this.waiveOffQuantity,
      this.cmtLooseWaiveOff,
      this.cmtLooseRatio,
      this.createdDate,
      this.createdBy,
      this.modifiedDate,
      this.modifiedBy,
      this.updated,
      this.productId,
      this.stateCode,
      this.uomId});

  ShortageMasterResponseList.fromJson(Map<String, dynamic> json) {
    shortageMasterId = json['shortageMasterId'];
    divisionType = json['divisionType'];
    stateName = json['stateName'];
    product = json['product'];
    uom = json['uom'];
    ratePerUnitQuantity = json['ratePerUnitQuantity'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    oldToDate = json['oldToDate'];
    waiveOffQuantity = json['waiveOffQuantity'];
    cmtLooseWaiveOff = json['cmtLooseWaiveOff'];
    cmtLooseRatio = json['cmtLooseRatio'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    modifiedDate = json['modifiedDate'];
    modifiedBy = json['modifiedBy'];
    updated = json['updated'];
    productId = json['productId'];
    uomId = json['uomId'];
    stateCode = json['stateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shortageMasterId'] = shortageMasterId;
    data['divisionType'] = divisionType;
    data['stateName'] = stateName;
    data['product'] = product;
    data['uom'] = uom;
    data['ratePerUnitQuantity'] = ratePerUnitQuantity;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['oldToDate'] = oldToDate;
    data['waiveOffQuantity'] = waiveOffQuantity;
    data['cmtLooseWaiveOff'] = cmtLooseWaiveOff;
    data['cmtLooseRatio'] = cmtLooseRatio;
    data['createdDate'] = createdDate;
    data['createdBy'] = createdBy;
    data['modifiedDate'] = modifiedDate;
    data['modifiedBy'] = modifiedBy;
    data['updated'] = updated;
    data['stateCode'] = stateCode;
    data['uomId'] = uomId;
    data['productId'] = productId;
    return data;
  }
}
