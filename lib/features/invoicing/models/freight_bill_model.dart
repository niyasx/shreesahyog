class FreightBillModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<FrieghtBillModelResponseList>? responseList;

  FreightBillModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  FreightBillModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <FrieghtBillModelResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(FrieghtBillModelResponseList.fromJson(v));
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

class FrieghtBillModelResponseList {
  String? diNo;
  String? tokenNo;
  String? invoiceNo;
  String? invoiceDate;
  String? grNo;
  String? grnMrnNo;
  String? shipTo;
  String? stateName;
  String? districtName;
  String? shipToCityId;
  String? shipToCityName;
  String? customerCityName;
  String? truckNo;
  String? unloadBy;
  int? unloadingFrt;
  int? plantId;
  double? quantity;
  double? frtAmount;
  double? frtRate;
  String? remarks;
  String? diType;
  double? shortageQty;
  double? specialFrtRate;
  double? unloadingFrtRate;
  bool? isInitiated;

  FrieghtBillModelResponseList(
      {this.diNo,
        this.tokenNo,
        this.invoiceNo,
        this.invoiceDate,
        this.grNo,
        this.grnMrnNo,
        this.shipTo,
        this.shipToCityId,
        this.shipToCityName,
        this.customerCityName,
        this.truckNo,
        this.unloadBy,
        this.unloadingFrt,
        this.plantId,
        this.stateName,
        this.districtName,
        this.quantity,
        this.frtAmount,
        this.frtRate,
        this.remarks,
        this.diType,
        this.shortageQty,
        this.specialFrtRate,
        this.unloadingFrtRate,
        this.isInitiated
      });

  FrieghtBillModelResponseList.fromJson(Map<String, dynamic> json) {
    diNo = json['diNo'];
    tokenNo = json['tokenNo'];
    invoiceNo = json['invoiceNo'];
    invoiceDate = json['invoiceDate'];
    grNo = json['grNo'];
    grnMrnNo = json['grnMrnNo'];
    shipTo = json['shipTo'];
    districtName = json['districtName'];
    stateName = json['stateName'];
    shipToCityId = json['shipToCityId'];
    shipToCityName = json['shipToCityName'];
    customerCityName = json['customerCityName'];
    truckNo = json['truckNo'];
    unloadBy = json['unloadBy'];
    unloadingFrt = json['unloadingFrt'];
    plantId = json['plantId'];
    quantity = json["quantity"];
    frtAmount = json['frtAmount'];
    frtRate = json['frtRate'];
    remarks = json['remarks'];
    diType = json['diType'];
    shortageQty = json['shortageQty'];
    specialFrtRate = json['specialFrtRate'];
    unloadingFrtRate = json['unloadingFrtRate'];
    isInitiated = json['isInitiated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['diNo'] = diNo;
    data['tokenNo'] = tokenNo;
    data['invoiceNo'] = invoiceNo;
    data['invoiceDate'] = invoiceDate;
    data['grNo'] = grNo;
    data['grnMrnNo'] = grnMrnNo;
    data['districtName'] = districtName;
    data['stateName'] = stateName;
    data['shipTo'] = shipTo;
    data['shipToCityId'] = shipToCityId;
    data['shipToCityName'] = shipToCityName;
    data['customerCityName'] = customerCityName;
    data['truckNo'] = truckNo;
    data['unloadBy'] = unloadBy;
    data['unloadingFrt'] = unloadingFrt;
    data['plantId'] = plantId;
    data['isInitiated'] = isInitiated;
    return data;
  }
}
