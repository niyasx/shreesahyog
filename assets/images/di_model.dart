class DiList {
  String? statusCode;
  String? status;
  List<String>? diTypeList;

  DiList({this.statusCode, this.status, this.diTypeList});

  DiList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    diTypeList = json['diTypeList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['diTypeList'] = this.diTypeList;
    return data;
  }
}
