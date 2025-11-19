import 'freight_bill_model.dart';

class InitiatedDIResponse {
  String? responseMessage;
  String? responseCode;
  dynamic serviceDTO;
  dynamic serviceDTOList;
  List<DeliveryItem>? responseList;

  InitiatedDIResponse({
    required this.responseMessage,
    required this.responseCode,
    required this.serviceDTO,
    required this.serviceDTOList,
    required this.responseList,
  });

  factory InitiatedDIResponse.fromJson(Map<String, dynamic> json) {
    return InitiatedDIResponse(
      responseMessage: json['responseMessage'],
      responseCode: json['responseCode'],
      serviceDTO: json['serviceDTO'],
      serviceDTOList: json['serviceDTOList'],
      responseList: json['responseList'] != null
          ? List<DeliveryItem>.from(
              json['responseList'].map((x) => DeliveryItem.fromJson(x)),
            )
          : [],
    );
  }
}

List<FrieghtBillModelResponseList>
    convertDeliveryItemsToFreightBillModelResponseList(
        List<DeliveryItem> deliveryItems) {
  return deliveryItems.map((deliveryItem) {
    return FrieghtBillModelResponseList(
      diNo: deliveryItem.diNo,
      tokenNo: deliveryItem.tokenNo,
      invoiceNo: deliveryItem.invoiceNo,
      invoiceDate:
          deliveryItem.invoiceDate?.toString(), // Convert DateTime to String
      grNo: deliveryItem.grNo,
      shipTo: deliveryItem.shipTo,
      stateName: deliveryItem.stateName,
      districtName: deliveryItem.districtName,
      shipToCityId: deliveryItem.shipToCityId,
      shipToCityName: deliveryItem.shipToCityName,
      customerCityName: deliveryItem.customerCityName,
      truckNo: deliveryItem.truckNo,
      unloadBy: deliveryItem.unloadBy,
      unloadingFrt: deliveryItem.unloadingFrt?.toInt(), // Convert double to int
      plantId: deliveryItem.plantId,
      quantity: deliveryItem.quantity,
      frtAmount: deliveryItem.frtAmount,
      frtRate: deliveryItem.frtRate,
      remarks: deliveryItem.remarks,
      diType: deliveryItem.diType,
      shortageQty: deliveryItem.shortageQty,
      specialFrtRate: deliveryItem.specialFrtRate,
      unloadingFrtRate: deliveryItem.unloadingFrtRate
    );
  }).toList();
}

class DeliveryItem {
  String? diNo;
  String? tokenNo;
  String? invoiceNo;
  DateTime? invoiceDate;
  String? grNo;
  String? grnMrnNo;
  String? shipTo;
  String? shipToCityId;
  String? shipToCityName;
  String? customerCityName;
  String? stateName;
  String? districtName;
  String? truckNo;
  String? unloadBy;
  double? unloadingFrt;
  int? plantId;
  int? tokenRank;
  double? quantity;
  double? shortageQty;
  double? frtAmount;
  double? frtRate;
  String? remarks;
  String? diUom;
  dynamic tollTax;
  dynamic kata;
  dynamic other;
  dynamic grossWeight;
  dynamic tareWeight;
  dynamic netWeight;
  dynamic tyreAmount;
  String? diType;
  double? specialFrtRate;
  double? unloadingFrtRate;
  bool? initiated;
  bool? dataUpdated;

  DeliveryItem({
    required this.diNo,
    required this.tokenNo,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.grNo,
    required this.tokenRank,
    required this.grnMrnNo,
    required this.shipTo,
    required this.shipToCityId,
    required this.shipToCityName,
    required this.customerCityName,
    required this.stateName,
    required this.districtName,
    required this.truckNo,
    required this.unloadBy,
    required this.unloadingFrt,
    required this.plantId,
    required this.quantity,
    required this.shortageQty,
    required this.frtAmount,
    required this.frtRate,
    required this.remarks,
    required this.diUom,
    required this.tollTax,
    required this.kata,
    required this.other,
    required this.grossWeight,
    required this.tareWeight,
    required this.netWeight,
    required this.tyreAmount,
    required this.diType,
    required this.specialFrtRate,
    required this.unloadingFrtRate,
    required this.initiated,
    required this.dataUpdated,
  });

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      diNo: json['diNo'],
      tokenRank: json['tokenRank'],
      tokenNo: json['tokenNo'],
      invoiceNo: json['invoiceNo'],
      invoiceDate: DateTime.parse(json['invoiceDate']),
      grNo: json['grNo'],
      grnMrnNo: json['grnMrnNo'],
      shipTo: json['shipTo'],
      shipToCityId: json['shipToCityId'],
      shipToCityName: json['shipToCityName'],
      customerCityName: json['customerCityName'],
      stateName: json['stateName'],
      districtName: json['districtName'],
      truckNo: json['truckNo'],
      unloadBy: json['unloadBy'],
      unloadingFrt: json['unloadingFrt'],
      plantId: json['plantId'],
      quantity: json['quantity'],
      shortageQty: json['shortageQty'],
      frtAmount: json['frtAmount'],
      frtRate: json['frtRate'],
      remarks: json['remarks'],
      diUom: json['diUom'],
      tollTax: json['tollTax'],
      kata: json['kata'],
      other: json['other'],
      grossWeight: json['grossWeight'],
      tareWeight: json['tareWeight'],
      netWeight: json['netWeight'],
      tyreAmount: json['tyreAmount'],
      diType: json['diType'],
      specialFrtRate: json['specialFrtRate'],
      unloadingFrtRate: json['unloadingFrtRate'],
      initiated: json['initiated'],
      dataUpdated: json['dataUpdated'],
    );
  }
}
