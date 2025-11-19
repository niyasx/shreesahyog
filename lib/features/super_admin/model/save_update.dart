class SaveUpdate {
  String responseMessage;
  String responseCode;
  dynamic serviceDTO; // Assuming serviceDTO can be of any type
  dynamic serviceDTOList; // Assuming serviceDTOList can be of any type

  SaveUpdate({
    required this.responseMessage,
    required this.responseCode,
    required this.serviceDTO,
    required this.serviceDTOList,
  });

  factory SaveUpdate.fromJson(Map<String, dynamic> json) {
    return SaveUpdate(
      responseMessage: json['responseMessage'] ?? '',
      responseCode: json['responseCode'] ?? '',
      serviceDTO: json['serviceDTO'],
      serviceDTOList: json['serviceDTOList'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    data['serviceDTO'] = serviceDTO;
    data['serviceDTOList'] = serviceDTOList;
    return data;
  }
}
