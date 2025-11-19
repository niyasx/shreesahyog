class District {
  String? responseMessage;
  dynamic responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<DistrictResponseList>? responseList;

  District(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  District.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <DistrictResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(DistrictResponseList.fromJson(v));
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

class DistrictResponseList {
  String? district;
  String? districtName;
  bool? isSelected;

  DistrictResponseList(
      {this.district, this.districtName, this.isSelected = false});

  DistrictResponseList.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    districtName = json['districtName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district'] = district;
    data['districtName'] = districtName;
    return data;
  }
}
