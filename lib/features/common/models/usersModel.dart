// class UsersModel {
//   dynamic userName;
//   dynamic mobileNumber;
//   dynamic emailId;
//   dynamic status;
//   dynamic roleName;
//   dynamic roleId;
//   dynamic stateName;
//   dynamic districtName;
//   dynamic cityName;
//   dynamic postalCode;
//   dynamic employeeCode;
//   dynamic employeeName;
//   dynamic createdBy;
//   dynamic updatedBy;

//   UsersModel(
//       {this.userName,
//         this.mobileNumber,
//         this.emailId,
//         this.status,
//         this.roleName,
//         this.roleId,
//         this.stateName,
//         this.districtName,
//         this.cityName,
//         this.postalCode,
//         this.employeeCode,
//         this.employeeName,
//         this.createdBy,
//         this.updatedBy});

//   UsersModel.fromJson(Map<dynamic, dynamic> json) {
//     userName = json['userName'];
//     mobileNumber = json['mobileNumber'];
//     emailId = json['emailId'];
//     status = json['status'];
//     roleName = json['roleName'];
//     roleId = json['roleId'];
//     stateName = json['stateName'];
//     districtName = json['districtName'];
//     cityName = json['cityName'];
//     postalCode = json['postalCode'];
//     employeeCode = json['employeeCode'];
//     employeeName = json['employeeName'];
//     createdBy = json['createdBy'];
//     updatedBy = json['updatedBy'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['userName'] = userName;
//     data['mobileNumber'] = mobileNumber;
//     data['emailId'] = emailId;
//     data['status'] = status;
//     data['roleName'] = roleName;
//     data['roleId'] = roleId;
//     data['stateName'] = stateName;
//     data['districtName'] = districtName;
//     data['cityName'] = cityName;
//     data['postalCode'] = postalCode;
//     data['employeeCode'] = employeeCode;
//     data['employeeName'] = employeeName;
//     data['createdBy'] = createdBy;
//     data['updatedBy'] = updatedBy;
//     return data;
//   }
// }

/*class UsersModel {
  String? userName;
  String? mobileNumber;
  String? emailId;
  bool? status;
  String? roleName;
  int? roleId;
  dynamic stateName;
  dynamic districtName;
  dynamic cityName;
  dynamic postalCode;
  int? employeeCode;
  String? employeeName;
  dynamic createdBy;
  dynamic updatedBy;
  int? supplierCode;
  dynamic supplierName;
  int? staffCode;
  bool? reportAccess;
  List<UserPlantMappedList>? userPlantMappedList;

  UsersModel(
      {this.userName,
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
      this.reportAccess,
      this.userPlantMappedList});

  UsersModel.fromJson(Map<dynamic, dynamic> json) {
    userName = json['userName'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    status = json['status'];
    roleName = json['roleName'];
    roleId = json['roleId'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    cityName = json['cityName'];
    postalCode = json['postalCode'];
    employeeCode = json['employeeCode'];
    employeeName = json['employeeName'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    supplierCode = json['supplierCode'];
    supplierName = json['supplierName'];
    staffCode = json['staffCode'];
    reportAccess = json['reportAccess'];
    if (json['userPlantMappedList'] != null) {
      userPlantMappedList = <UserPlantMappedList>[];
      json['userPlantMappedList'].forEach((v) {
        userPlantMappedList!.add(UserPlantMappedList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['mobileNumber'] = mobileNumber;
    data['emailId'] = emailId;
    data['status'] = status;
    data['roleName'] = roleName;
    data['roleId'] = roleId;
    data['stateName'] = stateName;
    data['districtName'] = districtName;
    data['cityName'] = cityName;
    data['postalCode'] = postalCode;
    data['employeeCode'] = employeeCode;
    data['employeeName'] = employeeName;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['supplierCode'] = supplierCode;
    data['supplierName'] = supplierName;
    data['staffCode'] = staffCode;
    data['reportAccess'] = reportAccess;
    if (userPlantMappedList != null) {
      data['userPlantMappedList'] =
          userPlantMappedList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserPlantMappedList {
  String? userId;
  String? userName;
  int? plantCode;
  String? plantName;

  UserPlantMappedList(
      {this.userId, this.userName, this.plantCode, this.plantName});

  UserPlantMappedList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    plantCode = json['plantCode'];
    plantName = json['plantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['plantCode'] = plantCode;
    data['plantName'] = plantName;
    return data;
  }
}*/
class UsersModel {
  String? userName;
  String? mobileNumber;
  String? emailId;
  bool? status;
  String? roleName;
  int? roleId;
  dynamic stateName;
  dynamic districtName;
  dynamic cityName;
  dynamic postalCode;
  int? employeeCode;
  String? employeeName;
  dynamic createdBy;
  dynamic updatedBy;
  int? supplierCode;
  dynamic supplierName;
  int? staffCode;
  bool? reportAccess;
  final List<UserPlantMappedList> userPlantMappedList;

  UsersModel({
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
    this.reportAccess,
    required this.userPlantMappedList,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
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
      reportAccess: json['reportAccess'],
      userPlantMappedList: (json['userPlantMappedList'] as List)
          .map((e) => UserPlantMappedList.fromJson(e))
          .toList(),
    );
  }
}

class UserPlantMappedList {
  final String userId;
  final String userName;
  final int plantCode;
  final String plantName;
  final List<dynamic> divisionList;

  UserPlantMappedList({
    required this.userId,
    required this.userName,
    required this.plantCode,
    required this.plantName,
    required this.divisionList,
  });

  factory UserPlantMappedList.fromJson(Map<String, dynamic> json) {
    return UserPlantMappedList(
      userId: json['userId'],
      userName: json['userName'],
      plantCode: json['plantCode'],
      plantName: json['plantName'],
      divisionList: json['divisionList'],
    );
  }
}
