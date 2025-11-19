class RoleMasterDetailsResponse {
  String? statusCode;
  String? status;
  List<RoleMasterDetailsList>? roleMasterDetailsList;

  RoleMasterDetailsResponse(
      {this.statusCode, this.status, this.roleMasterDetailsList});

  RoleMasterDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    if (json['roleMasterDetails'] != null) {
      roleMasterDetailsList = <RoleMasterDetailsList>[];
      json['roleMasterDetails'].forEach((v) {
        roleMasterDetailsList!.add(RoleMasterDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    if (roleMasterDetailsList != null) {
      data['roleMasterDetails'] =
          roleMasterDetailsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoleMasterDetailsList {
  int? roleId;
  String? roleName;
  String? roleCategory;

  RoleMasterDetailsList({this.roleId, this.roleName, this.roleCategory});

  RoleMasterDetailsList.fromJson(Map<String, dynamic> json) {
    roleId = json['roleId'];
    roleName = json['roleName'];
    roleCategory = json['roleCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleId'] = roleId;
    data['roleName'] = roleName;
    data['roleCategory'] = roleCategory;
    return data;
  }
}
