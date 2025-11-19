class TransPreBid2Model {
  String? responseMessage;
  dynamic responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<TransPreBid2ModelResponseList>? responseList;

  TransPreBid2Model(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  TransPreBid2Model.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <TransPreBid2ModelResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(TransPreBid2ModelResponseList.fromJson(v));
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

class TransPreBid2ModelResponseList {
  int? plantId;
  String? plantName;
  String? diNumber;
  String? division;
  String? diType;
  String? stateId;
  String? stateName;
  String? districtId;
  String? districtName;
  String? cityId;
  String? cityName;
  String? customerName;
  String? brand;
  String? product;
  double? diQty;
  String? diSto;
  double? frtRate;

  TransPreBid2ModelResponseList(
      {this.plantId,
      this.plantName,
      this.diNumber,
      this.division,
      this.diType,
      this.stateId,
      this.stateName,
      this.districtId,
      this.districtName,
      this.cityId,
      this.cityName,
      this.customerName,
      this.brand,
      this.product,
      this.diQty,
      this.diSto,
      this.frtRate});

  TransPreBid2ModelResponseList.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantName = json['plantName'];
    diNumber = json['diNumber'];
    division = json['division'];
    diType = json['diType'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    customerName = json['customerName'];
    brand = json['brand'];
    product = json['product'];
    diQty = json['diQty'];
    diSto = json['diSto'];
    frtRate = json['frtRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantName'] = plantName;
    data['diNumber'] = diNumber;
    data['division'] = division;
    data['diType'] = diType;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['customerName'] = customerName;
    data['brand'] = brand;
    data['product'] = product;
    data['diQty'] = diQty;
    data['diSto'] = diSto;
    data['frtRate'] = frtRate;
    return data;
  }
}
