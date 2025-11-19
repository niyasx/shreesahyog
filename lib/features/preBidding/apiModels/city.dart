class citymodel {
  String? responseMessage;
  dynamic responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ResponseList>? responseList;

  citymodel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  citymodel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(ResponseList.fromJson(v));
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

class ResponseList {
  String? city;
  String? cityName;

  ResponseList({this.city, this.cityName});

  ResponseList.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    cityName = json['cityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['cityName'] = cityName;
    return data;
  }
}
