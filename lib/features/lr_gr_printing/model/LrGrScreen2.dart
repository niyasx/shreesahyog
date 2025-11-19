class LrGrDetailsModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<LrGrDetailsModelResponseList>? responseList;

  LrGrDetailsModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  LrGrDetailsModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <LrGrDetailsModelResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(LrGrDetailsModelResponseList.fromJson(v));
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

class LrGrDetailsModelResponseList {
  int? plantId;
  String? plantName;
  String? division;
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
  String? brand;
  String? product;
  String? invoiceNumber;
  String? invoiceDate;
  String? dispatchedDate;
  num? invoiceAmount;
  String? ewayBillNumber;
  String? ewayBillDate;
  String? grNumber;

  LrGrDetailsModelResponseList(
      {this.plantId,
      this.plantName,
      this.division,
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
      this.brand,
      this.product,
      this.dispatchedDate,
      this.ewayBillDate,
      this.ewayBillNumber,
      this.invoiceAmount,
      this.invoiceDate,
      this.invoiceNumber,
      this.grNumber});

  LrGrDetailsModelResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    division = json['division'];
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
    brand = json['brand'];
    product = json['product'];
    invoiceNumber = json['invoiceNumber'];
    invoiceDate = json['invoiceDate'];
    dispatchedDate = json['dispatchedDate'];
    ewayBillDate = json['ewayBillDate'];
    ewayBillNumber = json['ewayBillNumber'];
    invoiceAmount = json['invoiceAmount'];
    grNumber = json['grNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantName'] = plantName;
    data['division'] = division;
    data['diType'] = diType;
    data['diNumber'] = diNumber;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['talukaId'] = talukaId;
    data['talukaName'] = talukaName;
    data['cityId'] = cityId;
    data['grNumber'] = grNumber;
    data['cityName'] = cityName;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['consigneeAddress'] = consigneeAddress;
    data['brand'] = brand;
    data['product'] = product;
    data['invoiceNumber'] = invoiceNumber;
    data['invoiceDate'] = invoiceDate;
    data['dispatchedDate'] = dispatchedDate;
    data['ewayBillDate'] = ewayBillDate;
    data['ewayBillNumber'] = ewayBillNumber;
    data['invoiceAmount'] = invoiceAmount;
    return data;
  }
}
