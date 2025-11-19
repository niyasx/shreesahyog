class DeleteApiResponse {
  final String responseMessage;
  final String responseCode;
  final dynamic serviceDTO;
  final dynamic serviceDTOList;

  DeleteApiResponse({
    required this.responseMessage,
    required this.responseCode,
    this.serviceDTO,
    this.serviceDTOList,
  });

  // Factory constructor to create an ApiResponse object from JSON
  factory DeleteApiResponse.fromJson(Map<String, dynamic> json) {
    return DeleteApiResponse(
      responseMessage: json['responseMessage'] ?? '',
      responseCode: json['responseCode'] ?? '',
      serviceDTO: json['serviceDTO'], // Assuming null can be a valid value
      serviceDTOList:
          json['serviceDTOList'], // Assuming null can be a valid value
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'responseMessage': responseMessage,
      'responseCode': responseCode,
      'serviceDTO': serviceDTO,
      'serviceDTOList': serviceDTOList,
    };
  }
}
