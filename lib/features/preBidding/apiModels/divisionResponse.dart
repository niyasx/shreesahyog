class DivisionModel {
  String? statusCode;
  String? status;
  List<String>? divisionlist;

  DivisionModel({this.statusCode, this.status, this.divisionlist});

  DivisionModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    divisionlist = json['divisionlist'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['divisionlist'] = divisionlist;
    return data;
  }
}
