class SPOCUserList {
  String? userName;
  String? mobileNumber;
  String? emailId;
  bool? status;
  String? roleName;
  int? roleId;
  String? stateName;
  String? districtName;
  String? cityName;
  String? postalCode;
  int? employeeCode;
  String? employeeName;
  String? createdBy;
  String? updatedBy;
  int? supplierCode;
  String? supplierName;
  int? staffCode;
  List<UserPlant>? userPlantMappedList;

  SPOCUserList({
    this.userName,
    this.mobileNumber,
    this.emailId,
    this.status,
    this.roleName,
    this.roleId,
    this.stateName,
    this.districtName,
    this.cityName,
    this.postalCode,
    this.employeeCode,
    this.employeeName,
    this.createdBy,
    this.updatedBy,
    this.supplierCode,
    this.supplierName,
    this.staffCode,
    this.userPlantMappedList,
  });

  factory SPOCUserList.fromJson(Map<String, dynamic> json) {
    return SPOCUserList(
      userName: json['userName'],
      mobileNumber: json['mobileNumber'],
      emailId: json['emailId'],
      status: json['status'],
      roleName: json['roleName'],
      roleId: json['roleId'],
      stateName: json['stateName'],
      districtName: json['districtName'],
      cityName: json['cityName'],
      postalCode: json['postalCode'],
      employeeCode: json['employeeCode'],
      employeeName: json['employeeName'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      supplierCode: json['supplierCode'],
      supplierName: json['supplierName'],
      staffCode: json['staffCode'],
      userPlantMappedList: (json['userPlantMappedList'] as List<dynamic>)
          .map((plant) => UserPlant.fromJson(plant))
          .toList(),
    );
  }
}

class UserPlant {
  String? userId;
  String? userName;
  int? plantCode;
  String? plantName;

  UserPlant({
    this.userId,
    this.userName,
    this.plantCode,
    this.plantName,
  });

  factory UserPlant.fromJson(Map<String, dynamic> json) {
    return UserPlant(
      userId: json['userId'],
      userName: json['userName'],
      plantCode: json['plantCode'],
      plantName: json['plantName'],
    );
  }
}
