class ViewFreightBillLogisticsModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ViewFreighBillLogisticsResponseList>? responseList;

  ViewFreightBillLogisticsModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  ViewFreightBillLogisticsModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ViewFreighBillLogisticsResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(ViewFreighBillLogisticsResponseList.fromJson(v));
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

class ViewFreighBillLogisticsResponseList {
  String? billNo;
  String? billDate;
  double? frtNetAmount;
  double? totalTax;
  double? netAmount;
  dynamic rejectedRemark;
  String? transporterId;
  String? transporterName;
  String? status;
  String? sapRefNo;
  String? sapResponse;
  String? reSubmissionDate;
  String? billHoldUnholdDate;

  ViewFreighBillLogisticsResponseList(
      {this.billNo,
      this.billDate,
      this.frtNetAmount,
      this.totalTax,
      this.status,
      this.netAmount,
      this.rejectedRemark,
      this.transporterId,
      this.transporterName,
      this.sapRefNo,
      this.sapResponse,
      this.reSubmissionDate,
      this.billHoldUnholdDate
      });

  ViewFreighBillLogisticsResponseList.fromJson(Map<String, dynamic> json) {
    billNo = json['billNo'];
    status = json['status'];
    billDate = json['billDate'];
    frtNetAmount = json['frtNetAmount'];
    totalTax = json['totalTax'];
    netAmount = json['netAmount'];
    rejectedRemark = json['rejectedRemark'];
    transporterId = json['transporterId'];
    transporterName = json['transporterName'];
    sapRefNo = json['sapRefNo'];
    sapResponse = json['sapResponse'];
    reSubmissionDate = json['reSubmissionDate'];
    billHoldUnholdDate =json['billHoldUnholdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billNo'] = billNo;
    data['status'] = status;
    data['billDate'] = billDate;
    data['frtNetAmount'] = frtNetAmount;
    data['totalTax'] = totalTax;
    data['netAmount'] = netAmount;
    data['rejectedRemark'] = rejectedRemark;
    data['transporterId'] = transporterId;
    data['transporterName'] = transporterName;
    data['sapRefNo'] = sapRefNo;
    data['sapResponse']= sapResponse;
    data['reSubmissionDate'] =reSubmissionDate;
    data['billHoldUnholdDate'] =billHoldUnholdDate;
    return data;
  }
}
