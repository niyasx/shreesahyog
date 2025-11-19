class DeliveryTypeModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ResponseList1>? responseList;

  DeliveryTypeModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  DeliveryTypeModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ResponseList1>[];
      json['responseList'].forEach((v) {
        responseList!.add(ResponseList1.fromJson(v));
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

class ResponseList1 {
  int? deliveryMasterId;
  String? deliveryName;

  ResponseList1({this.deliveryMasterId, this.deliveryName});

  ResponseList1.fromJson(Map<String, dynamic> json) {
    deliveryMasterId = json['deliveryMasterId'];
    deliveryName = json['deliveryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliveryMasterId'] = deliveryMasterId;
    data['deliveryName'] = deliveryName;
    return data;
  }
}
