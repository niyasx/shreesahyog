// class UnlinkedDeliveryModel {
//   String? responseMessage;
//   String? responseCode;
//   dynamic serviceDTO;
//   dynamic serviceDTOList;
//   List<UnlinkedResponseList>? responseList;

//   UnlinkedDeliveryModel(
//       {this.responseMessage,
//       this.responseCode,
//       this.serviceDTO,
//       this.serviceDTOList,
//       this.responseList});

//   UnlinkedDeliveryModel.fromJson(Map<String, dynamic> json) {
//     responseMessage = json['responseMessage'];
//     responseCode = json['responseCode'];
//     serviceDTO = json['serviceDTO'];
//     serviceDTOList = json['serviceDTOList'];
//     if (json['responseList'] != null) {
//       responseList = <UnlinkedResponseList>[];
//       json['responseList'].forEach((v) {
//         responseList!.add(UnlinkedResponseList.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['responseMessage'] = responseMessage;
//     data['responseCode'] = responseCode;
//     data['serviceDTO'] = serviceDTO;
//     data['serviceDTOList'] = serviceDTOList;
//     if (responseList != null) {
//       data['responseList'] = responseList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class UnlinkedResponseList {
//   String? diNumber;
//   String? customerName;
//   String? shipToCityName;
//   double? diQty;
//   double? frtAmount;
//   String? transporterName;

//   UnlinkedResponseList(
//       {this.diNumber,
//       this.customerName,
//       this.shipToCityName,
//       this.diQty,
//       this.frtAmount,
//       this.transporterName});

//   UnlinkedResponseList.fromJson(Map<String, dynamic> json) {
//     diNumber = json['diNumber'];
//     customerName = json['customerName'];
//     shipToCityName = json['shipToCityName'];
//     diQty = json['diQty'];
//     frtAmount = json['frtAmount'];
//     transporterName = json['transporterName'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['diNumber'] = diNumber;
//     data['customerName'] = customerName;
//     data['shipToCityName'] = shipToCityName;
//     data['diQty'] = diQty;
//     data['frtAmount'] = frtAmount;
//     data['transporterName'] = transporterName;
//     return data;
//   }
// }

class UnlinkedDeliveryModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<UnlinkedResponseList>? responseList;

  UnlinkedDeliveryModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  UnlinkedDeliveryModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <UnlinkedResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(UnlinkedResponseList.fromJson(v));
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

class UnlinkedResponseList {
  String? diNumber;
  String? customerName;
  String? shipToCityName;
  double? diQty;
  num? frtAmount;
  String? transporterName;
  num? extraHours;
  String? remarksForExtraTime;
  String? remarksPenalityWaiveOff;
  String? extendExtraHoursRequestedDate;
  String? diStatus;
  String? cityName;

  UnlinkedResponseList(
      {this.diNumber,
      this.customerName,
      this.shipToCityName,
      this.diQty,
      this.frtAmount,
      this.transporterName,
      this.extraHours,
      this.remarksForExtraTime,
      this.remarksPenalityWaiveOff,
      this.extendExtraHoursRequestedDate,
      this.diStatus,
      this.cityName,
      });

  UnlinkedResponseList.fromJson(Map<String, dynamic> json) {
    diNumber = json['diNumber'];
    customerName = json['customerName'];
    shipToCityName = json['shipToCityName'];
    diQty = json['diQty'];
    frtAmount = json['frtAmount'];
    transporterName = json['transporterName'];
    extraHours = json['extraHours'];
    remarksForExtraTime = json['remarksForExtraTime'];
    remarksPenalityWaiveOff = json['remarksPenalityWaiveOff'];
    extendExtraHoursRequestedDate = json['extendExtraHoursRequestedDate'];
    diStatus = json['diStatus'];
    cityName = json['cityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['diNumber'] = diNumber;
    data['customerName'] = customerName;
    data['shipToCityName'] = shipToCityName;
    data['diQty'] = diQty;
    data['frtAmount'] = frtAmount;
    data['transporterName'] = transporterName;
    data['extraHours'] = extraHours;
    data['remarksForExtraTime'] = remarksForExtraTime;
    data['remarksPenalityWaiveOff'] = remarksPenalityWaiveOff;
    data['extendExtraHoursRequestedDate'] = extendExtraHoursRequestedDate;
    data['diStatus'] = diStatus;
    data['cityName'] = cityName;
    return data;
  }
}
