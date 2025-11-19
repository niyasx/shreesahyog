class ViewFreightBillModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ViewFreighBillResponseList>? responseList;

  ViewFreightBillModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  ViewFreightBillModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ViewFreighBillResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(ViewFreighBillResponseList.fromJson(v));
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

class ViewFreighBillResponseList {
  String? billNo;
  String? billDate;
  double? frtNetAmount;
  double? deductedAmount;
  double? totalTax;
  double? netAmount;
  dynamic rejectedRemark;
  String? status;
  String? sapRefNo;
  String? sapResponse;

  ViewFreighBillResponseList(
      {this.billNo,
      this.billDate,
      this.frtNetAmount,
      this.deductedAmount,
      this.totalTax,
      this.netAmount,
      this.rejectedRemark,
      this.sapRefNo,
      this.status,
      this.sapResponse});

  ViewFreighBillResponseList.fromJson(Map<String, dynamic> json) {
    billNo = json['billNo'];
    sapRefNo = json['sapRefNo'];
    billDate = json['billDate'];
    frtNetAmount = json['frtNetAmount'];
    deductedAmount = json['deductedAmount'];
    totalTax = json['totalTax'];
    netAmount = json['netAmount'];
    rejectedRemark = json['rejectedRemark'];
    status = json['status'];
    sapResponse = json['sapResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billNo'] = billNo;
    data['sapRefNo'] = sapRefNo;
    data['billDate'] = billDate;
    data['frtNetAmount'] = frtNetAmount;
    data['deductedAmount'] = deductedAmount;
    data['totalTax'] = totalTax;
    data['netAmount'] = netAmount;
    data['rejectedRemark'] = rejectedRemark;
    data['status'] = status;
    data ['sapResponse'] = sapResponse;
    return data;
  }
}
