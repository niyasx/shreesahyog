class PrebidResponseModel {
  final String responseMessage;
  final String responseCode;
  final dynamic serviceDTO; // dynamic used because it's null in your example
  final dynamic serviceDTOList; // dynamic used because it's null in your example

  PrebidResponseModel({
    required this.responseMessage,
    required this.responseCode,
    this.serviceDTO,
    this.serviceDTOList,
  });

  // Factory constructor to create an instance from JSON
  factory PrebidResponseModel.fromJson(Map<String, dynamic> json) {
    return PrebidResponseModel(
      responseMessage: json['responseMessage'],
      responseCode: json['responseCode'],
      serviceDTO: json['serviceDTO'],
      serviceDTOList: json['serviceDTOList'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'responseMessage': responseMessage,
      'responseCode': responseCode,
      'serviceDTO': serviceDTO,
      'serviceDTOList': serviceDTOList,
    };
  }
}

