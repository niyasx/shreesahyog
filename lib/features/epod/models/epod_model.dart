class EpodDetails {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<EPODResponseList>? responseList;

  EpodDetails(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  EpodDetails.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <EPODResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(EPODResponseList.fromJson(v));
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

class EPODResponseList {
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
  String? ewayBillNumber;
  String? ewayBillDate;
  String? grNumber;
  String? consigneeName;
  String? incoTerms;

  EPODResponseList(
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
      this.invoiceNumber,
      this.invoiceDate,
      this.ewayBillNumber,
      this.ewayBillDate,
      this.grNumber,
      this.consigneeName,
      this.incoTerms});

  EPODResponseList.fromJson(Map<String, dynamic> json) {
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
    ewayBillNumber = json['ewayBillNumber'];
    ewayBillDate = json['ewayBillDate'];
    grNumber = json['grNumber'];
    consigneeName = json['consigneeName'];
    incoTerms = json['incoTerms'];
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
    data['cityName'] = cityName;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['consigneeAddress'] = consigneeAddress;
    data['brand'] = brand;
    data['product'] = product;
    data['invoiceNumber'] = invoiceNumber;
    data['invoiceDate'] = invoiceDate;
    data['ewayBillNumber'] = ewayBillNumber;
    data['ewayBillDate'] = ewayBillDate;
    data['grNumber'] = grNumber;
    data['consigneeName'] = consigneeName;
    data['incoTerms'] = incoTerms;
    return data;
  }
}
