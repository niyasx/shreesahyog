class TokenDetailsResponseList {
  String? transporterId;
  String? transporterName;
  String? transporterMobileNumber;
  String? plantCode;
  String? plantName;
  String? tokenNumber;
  String? tokenStatus;
  String? factoryGateInTime;
  String? trNumber;
  String? modeOfTransport;
  String? truckType;
  String? truckNumber;
  num? actualVehicleCapacity;
  String? vehicleModel;
  String? ownerName;
  String? product;
  String? licenceNo;
  String? packagingType;
  String? driverName;
  String? driverMobileNumber;
  String? createdDate;
  String? updationDate;

  TokenDetailsResponseList(
      {this.transporterId,
      this.transporterName,
      this.transporterMobileNumber,
      this.plantCode,
      this.licenceNo,
      this.plantName,
      this.tokenNumber,
      this.tokenStatus,
      this.factoryGateInTime,
      this.trNumber,
      this.modeOfTransport,
      this.truckType,
      this.truckNumber,
      this.actualVehicleCapacity,
      this.vehicleModel,
      this.ownerName,
      this.product,
      this.packagingType,
      this.driverName,
      this.driverMobileNumber,
      this.createdDate,
      this.updationDate});

  TokenDetailsResponseList.fromJson(Map<String, dynamic> json) {
    transporterId = json['transporterId'];
    transporterName = json['transporterName'];
    transporterMobileNumber = json['transporterMobileNumber'];
    plantCode = json['plantCode'];
    plantName = json['plantName'];
    tokenNumber = json['tokenNumber'];
    tokenStatus = json['tokenStatus'];
    factoryGateInTime = json['factoryGateInTime'];
    trNumber = json['trNumber'];
    modeOfTransport = json['modeOfTransport'];
    truckType = json['truckType'];
    truckNumber = json['truckNumber'];
    actualVehicleCapacity = json['actualVehicleCapacity'];
    vehicleModel = json['vehicleModel'];
    ownerName = json['ownerName'];
    product = json['product'];
    packagingType = json['packagingType'];
    driverName = json['driverName'];
    driverMobileNumber = json['driverMobileNumber'];
    createdDate = json['createdDate'];
    updationDate = json['updationDate'];
    licenceNo = json['licenceNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    data['transporterMobileNumber'] = transporterMobileNumber;
    data['plantCode'] = plantCode;
    data['plantName'] = plantName;
    data['tokenNumber'] = tokenNumber;
    data['tokenStatus'] = tokenStatus;
    data['factoryGateInTime'] = factoryGateInTime;
    data['trNumber'] = trNumber;
    data['modeOfTransport'] = modeOfTransport;
    data['truckType'] = truckType;
    data['truckNumber'] = truckNumber;
    data['actualVehicleCapacity'] = actualVehicleCapacity;
    data['vehicleModel'] = vehicleModel;
    data['ownerName'] = ownerName;
    data['product'] = product;
    data['packagingType'] = packagingType;
    data['driverName'] = driverName;
    data['driverMobileNumber'] = driverMobileNumber;
    data['createdDate'] = createdDate;
    data['updationDate'] = updationDate;
    data['licenceNo'] = licenceNo;
    return data;
  }
}
