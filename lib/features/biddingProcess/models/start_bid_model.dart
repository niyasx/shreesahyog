class StartBidModel {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<StartBidResponseItem>? responseList;

  StartBidModel({
    this.responseMessage,
    this.responseCode,
    this.serviceDTO,
    this.serviceDTOList,
    this.responseList,
  });

  StartBidModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'] as String?;
    responseCode = json['responseCode'] as String?;
    serviceDTO = json['serviceDTO'];
    serviceDTOList = json['serviceDTOList'];
    responseList = (json['responseList'] as List?)
        ?.map((dynamic e) =>
            StartBidResponseItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['responseMessage'] = responseMessage;
    json['responseCode'] = responseCode;
    json['serviceDTO'] = serviceDTO;
    json['serviceDTOList'] = serviceDTOList;
    json['responseList'] = responseList?.map((e) => e.toJson()).toList();
    return json;
  }
}

class StartBidResponseItem {
  String? diType;
  String? division;
  int? plantId;
  String? plantName;
  String? scheduledBidTime;
  int? unlinkedDelivery;
  int? deliveries;
  String? bidStatus;
  int? timeForBiddingInMinutes;
  int? reBidTimeInHours;

  StartBidResponseItem(
      {this.diType,
      this.division,
      this.plantId,
      this.plantName,
      this.scheduledBidTime,
      this.unlinkedDelivery,
      this.deliveries,
      this.bidStatus,
      this.timeForBiddingInMinutes,
      this.reBidTimeInHours});

  StartBidResponseItem.fromJson(Map<String, dynamic> json) {
    diType = json['diType'] as String?;
    division = json['division'] as String?;
    plantId = json['plantId'] as int?;
    plantName = json['plantName'] as String?;
    scheduledBidTime = json['scheduledBidTime'];
    unlinkedDelivery = json['unlinkedDelivery'] as int?;
    deliveries = json['deliveries'] as int?;
    bidStatus = json['bidStatus'];
    timeForBiddingInMinutes = json['timeForBiddingInMinutes'];
    reBidTimeInHours = json['reBidTimeInHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['diType'] = diType;
    json['division'] = division;
    json['plantId'] = plantId;
    json['plantName'] = plantName;
    json['scheduledBidTime'] = scheduledBidTime;
    json['unlinkedDelivery'] = unlinkedDelivery;
    json['deliveries'] = deliveries;
    json['bidStatus'] = bidStatus;
    json['timeForBiddingInMinutes'] = timeForBiddingInMinutes;
    json['reBidTimeInHours'] = reBidTimeInHours;
    return json;
  }
}
