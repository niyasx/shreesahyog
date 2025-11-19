class ProfileModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<ProfileResponseList>? responseList;

  ProfileModel(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <ProfileResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(ProfileResponseList.fromJson(v));
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

class ProfileResponseList {
  String? userId;
  String? userName;
  int? plantCode;
  String? plantName;

  ProfileResponseList(
      {this.userId, this.userName, this.plantCode, this.plantName});

  ProfileResponseList.fromJson(Map<String, dynamic> json) {
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
}
