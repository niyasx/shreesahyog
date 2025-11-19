class GetDIPendencyCategoryModel {
  String? responseMessage;
  String? responseCode;
  Null? serviceDTO;
  Null? serviceDTOList;
  List<ResponseList>? responseList;

  GetDIPendencyCategoryModel(
      {this.responseMessage,
        this.responseCode,
        this.serviceDTO,
        this.serviceDTOList,
        this.responseList});

  GetDIPendencyCategoryModel.fromJson(Map<String, dynamic> json) {
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
  int? srNo;
  String? category;

  ResponseList({this.srNo, this.category});

  ResponseList.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['srNo'] = srNo;
    data['category'] = category;
    return data;
  }
}
