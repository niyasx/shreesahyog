/*
class PlantListModelAdmin {
  String? responseMessage;
  dynamic responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<PlantListAdminResponseList>? responseList;

  PlantListModelAdmin(
      {this.responseMessage,
      this.responseCode,
      this.serviceDTO,
      this.serviceDTOList,
      this.responseList});

  PlantListModelAdmin.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <PlantListAdminResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(PlantListAdminResponseList.fromJson(v));
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

class PlantListAdminResponseList {
  int? plantMasterId;
  int? plantCode;
  String? plantName;
  bool? status;

  PlantListAdminResponseList(
      {this.plantMasterId, this.plantCode, this.plantName, this.status});

  PlantListAdminResponseList.fromJson(Map<String, dynamic> json) {
    plantMasterId = json['plantMasterId'];
    plantCode = json['plantCode'];
    plantName = json['plantName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantMasterId'] = plantMasterId;
    data['plantCode'] = plantCode;
    data['plantName'] = plantName;
    data['status'] = status;
    return data;
  }
}
*/

class PlantListModelAdmin {
  String? responseMessage;
  Null? responseCode;
  Null? serviceDTO;
  Null? serviceDTOList;
  List<PlantListAdminResponseList>? responseList;

  PlantListModelAdmin(
      {this.responseMessage,
        this.responseCode,
        this.serviceDTO,
        this.serviceDTOList,
        this.responseList});

  PlantListModelAdmin.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseCode = json['responseCode'];
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    if (json['responseList'] != null) {
      responseList = <PlantListAdminResponseList>[];
      json['responseList'].forEach((v) {
        responseList!.add(new PlantListAdminResponseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseMessage'] = this.responseMessage;
    data['responseCode'] = this.responseCode;
    data['serviceDTO'] = this.serviceDTO;
    data['serviceDTOList'] = this.serviceDTOList;
    if (this.responseList != null) {
      data['responseList'] = this.responseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlantListAdminResponseList {
  int? plantMasterId;
  int? plantCode;
  String? plantName;
  bool? status;
  List<DivisionList1>? divisionList;
  bool? isPlantSelected = false;

  PlantListAdminResponseList(
      {this.plantMasterId,
        this.plantCode,
        this.plantName,
        this.status,
        this.divisionList,
        this.isPlantSelected=false});

  PlantListAdminResponseList.fromJson(Map<String, dynamic> json) {
    plantMasterId = json['plantMasterId'];
    plantCode = json['plantCode'];
    plantName = json['plantName'];
    status = json['status'];
    if (json['divisionList'] != null) {
      divisionList = <DivisionList1>[];
      json['divisionList'].forEach((v) {
        divisionList!.add(new DivisionList1.fromJson(v));
      });
    }
    isPlantSelected = json['isPlantSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plantMasterId'] = this.plantMasterId;
    data['plantCode'] = this.plantCode;
    data['plantName'] = this.plantName;
    data['status'] = this.status;
    if (this.divisionList != null) {
      data['divisionList'] = this.divisionList!.map((v) => v.toJson()).toList();
    }
    data['isPlantSelected'] = this.isPlantSelected;
    return data;
  }
}

class DivisionList1 {
  String? divisionName;
  bool? isDivisionSelected;

  DivisionList1({this.divisionName, this.isDivisionSelected});

  DivisionList1.fromJson(Map<String, dynamic> json) {
    divisionName = json['divisionName'];
    isDivisionSelected = json['isDivisionSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['divisionName'] = this.divisionName;
    data['isDivisionSelected'] = this.isDivisionSelected;
    return data;
  }
}

