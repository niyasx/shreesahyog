class TransporterViewInvoiceModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<TransporterViewInvoiceResponseList>? responseList;

  TransporterViewInvoiceModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  TransporterViewInvoiceModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <TransporterViewInvoiceResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(TransporterViewInvoiceResponseList.fromJson(v));
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

class TransporterViewInvoiceResponseList {
  String? invoiceNo;
  String? invoiceDate;
  double? frtNetAmount;
  double? paidAmount;
  double? totalTax;
  double? netAmount;
  String? paymentStatus;

  TransporterViewInvoiceResponseList(
      {this.invoiceNo,
      this.invoiceDate,
      this.frtNetAmount,
      this.paidAmount,
      this.totalTax,
      this.netAmount,
      this.paymentStatus});

  TransporterViewInvoiceResponseList.fromJson(Map<String, dynamic> json) {
    invoiceNo = json['invoiceNo'];
    invoiceDate = json['invoiceDate'];
    frtNetAmount = json['frtNetAmount'];
    paidAmount = json['paidAmount'];
    totalTax = json['totalTax'];
    netAmount = json['netAmount'];
    paymentStatus = json['paymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceNo'] = invoiceNo;
    data['invoiceDate'] = invoiceDate;
    data['frtNetAmount'] = frtNetAmount;
    data['paidAmount'] = paidAmount;
    data['totalTax'] = totalTax;
    data['netAmount'] = netAmount;
    data['paymentStatus'] = paymentStatus;
    return data;
  }
}
