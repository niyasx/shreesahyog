class TransporterListResponse {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<TransporterList>? transporterList;

  TransporterListResponse(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.transporterList});

  TransporterListResponse.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      transporterList = <TransporterList>[];
      json['responseList'].forEach((v) {
        transporterList!.add(TransporterList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    data['serviceDTO'] = serviceDTO;
    data['serviceDTOList'] = serviceDTOList;
    if (transporterList != null) {
      data['responseList'] = transporterList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransporterList {
  int? transporterMasterId;
  String? supplier;
  String? bpGrouping;
  String? supplierAccountGroup;
  String? name;
  String? firstName;
  String? lastName;
  String? middleName;
  String? legalEntity;
  String? permanentAccountNumber;
  String? street;
  String? houseNumber;
  String? district;
  String? differentCity;
  String? postalCode;
  String? city;
  String? country;
  String? state;
  String? mobileNumber;
  String? emailId;
  String? gstn;
  String? taxRegime;
  bool? status;

  TransporterList(
      {this.transporterMasterId,
      this.supplier,
      this.bpGrouping,
      this.supplierAccountGroup,
      this.name,
      this.firstName,
      this.lastName,
      this.middleName,
      this.legalEntity,
      this.permanentAccountNumber,
      this.street,
      this.houseNumber,
      this.district,
      this.differentCity,
      this.postalCode,
      this.city,
      this.country,
      this.state,
      this.mobileNumber,
      this.emailId,
      this.gstn,
      this.taxRegime,
      this.status});

  TransporterList.fromJson(Map<String, dynamic> json) {
    transporterMasterId = json['transporterMasterId'];
    supplier = json['supplier'];
    bpGrouping = json['bpGrouping'];
    supplierAccountGroup = json['supplierAccountGroup'];
    name = json['name'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    legalEntity = json['legalEntity'];
    permanentAccountNumber = json['permanentAccountNumber'];
    street = json['street'];
    houseNumber = json['houseNumber'];
    district = json['district'];
    differentCity = json['differentCity'];
    postalCode = json['postalCode'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    gstn = json['gstn'];
    taxRegime = json['taxRegime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['transporterMasterId'] = transporterMasterId;
    data['supplier'] = supplier;
    data['bpGrouping'] = bpGrouping;
    data['supplierAccountGroup'] = supplierAccountGroup;
    data['name'] = name;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['middleName'] = middleName;
    data['legalEntity'] = legalEntity;
    data['permanentAccountNumber'] = permanentAccountNumber;
    data['street'] = street;
    data['houseNumber'] = houseNumber;
    data['district'] = district;
    data['differentCity'] = differentCity;
    data['postalCode'] = postalCode;
    data['city'] = city;
    data['country'] = country;
    data['state'] = state;
    data['mobileNumber'] = mobileNumber;
    data['emailId'] = emailId;
    data['gstn'] = gstn;
    data['taxRegime'] = taxRegime;
    data['status'] = status;
    return data;
  }
}
