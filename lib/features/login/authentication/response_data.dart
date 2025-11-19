class ResponseData {
  dynamic responseMessage;
  dynamic responseCode;
  ServiceDTO? serviceDTO;
  dynamic serviceDTOList;
  String? userName;
  String? userMobileNo;
  dynamic password;
  dynamic firstTimeLogin;
  bool? enabled;
  dynamic passwordExpiryDate;
  int? roleId;
  String? roleName;
  String? emailId;
  dynamic employeeName;
  String? employeeCode;

  ResponseData(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.userName,
      this.userMobileNo,
      this.password,
      this.firstTimeLogin,
      this.enabled,
      this.passwordExpiryDate,
      this.roleId,
      this.roleName,
      this.emailId,
      this.employeeName,
      this.employeeCode});

  ResponseData.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'] != null
        ? ServiceDTO.fromJson(json['serviceDTO'])
        : null;
    serviceDTOList = json['serviceDTOList'];
    userName = json['userName'];
    userMobileNo = json['userMobileNo'];
    password = json['password'];
    firstTimeLogin = json['firstTimeLogin'];
    enabled = json['enabled'];
    passwordExpiryDate = json['passwordExpiryDate'];
    roleId = json['roleId'];
    roleName = json['roleName'];
    emailId = json['emailId'];
    employeeName = json['employeeName'];
    employeeCode = json['employeeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseMessage'] = responseMessage;
    data['responseCode'] = responseCode;
    if (serviceDTO != null) {
      data['serviceDTO'] = serviceDTO!.toJson();
    }
    data['serviceDTOList'] = serviceDTOList;
    data['userName'] = userName;
    data['userMobileNo'] = userMobileNo;
    data['password'] = password;
    data['firstTimeLogin'] = firstTimeLogin;
    data['enabled'] = enabled;
    data['passwordExpiryDate'] = passwordExpiryDate;
    data['roleId'] = roleId;
    data['roleName'] = roleName;
    data['emailId'] = emailId;
    data['employeeName'] = employeeName;
    data['employeeCode'] = employeeCode;
    return data;
  }
}

class ServiceDTO {
  String? userMobileNo;
  String? authToken;
  dynamic password;

  ServiceDTO({this.userMobileNo, this.authToken, this.password});

  ServiceDTO.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['userMobileNo'];
    authToken = json['authToken'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userMobileNo'] = userMobileNo;
    data['authToken'] = authToken;
    data['password'] = password;
    return data;
  }
}
