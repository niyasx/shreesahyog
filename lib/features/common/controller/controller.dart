import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/models/dashboard_gridviewlist.dart';
import 'package:shreecement/features/invoicing/models/process_freight_bill_model.dart';

class Controller extends GetxController {
  static Controller get instance => Get.find();

  final RxString preBid2PlantId = ''.obs;
  final RxString division = ''.obs;
  List<String> diNumberList = [];
  final RxString billNo = "".obs;
  final RxString billStatus = "".obs;
  RxList<DashBoardGridViewList> dashboardGridViewList = RxList();
  RxBool back = false.obs;
  RxBool backViewBill = false.obs;

  RxInt currentIndex = 0.obs;

  void resetCurrentIndex() {
    currentIndex.value = 0;
  }

 ValueNotifier<List<DiDetails>> processFrBillListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<DiDetails>> processFrBillListResponseList1 =
      ValueNotifier([]);
  ValueNotifier<ProcessFreightBillModel> processfrbill =
      ValueNotifier(ProcessFreightBillModel());

  List<DiDetails> originalProcessFrBill2List = [];


  RxBool isProcess200 =false.obs;

  
}
