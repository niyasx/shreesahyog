class OtherLinkResponseModel {
  String? responseMessage;
  String? responseCode;
  String? successUrl;

  OtherLinkResponseModel(
      {this.responseMessage, this.responseCode, this.successUrl});

  OtherLinkResponseModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    successUrl = json['successUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    data['successUrl'] = successUrl;
    return data;
  }
}
