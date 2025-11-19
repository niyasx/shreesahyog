import 'dart:typed_data';

class GenerateInvoiceResponseModel {
  String? responseMessage;
  dynamic responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  Uint8List? byteOfFile;
  dynamic sapRefNo;

  GenerateInvoiceResponseModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.byteOfFile,
      this.sapRefNo});

  GenerateInvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    byteOfFile = json['byteOfFile'];
    sapRefNo = json['sapRefNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    data['serviceDTO'] = serviceDTO;
    data['serviceDTOList'] = serviceDTOList;
    data['byteOfFile'] = byteOfFile;
    data['sapRefNo'] = sapRefNo;
    return data;
  }
}
