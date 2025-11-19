// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/controller/double_number.dart';
import 'package:shreecement/features/common/controller/indian_currency.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_popup_menu1.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/invoicing/apis/freight_bill_api.dart';
import 'package:shreecement/features/invoicing/apis/view_freightbill_api.dart';
import 'package:shreecement/features/invoicing/models/di_qty_model.dart';
import 'package:shreecement/features/invoicing/models/process_freight_bill_model.dart';
import 'package:shreecement/features/invoicing/models/validate_freight_logistics_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../../common/widgets/customdropdownprebid.dart';

class EditFreightBillTransporter extends StatefulWidget {
  const EditFreightBillTransporter({super.key});

  @override
  State<EditFreightBillTransporter> createState() =>
      _EditFreightBillTransporter();
}

class _EditFreightBillTransporter extends State<EditFreightBillTransporter> {
  RxInt currentPagination = 1.obs;
  String searchValue = "";

  List<LogisticApprovalDiList> originalEditFreightBillList = [];
  ValueNotifier<List<LogisticApprovalDiList>> editFreightBillListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<LogisticApprovalDiList>> editFreightBillListResponseList1 =
      ValueNotifier([]);
  ValueNotifier<ValidateFreightLogisticsModel> editFrBillAll =
      ValueNotifier(ValidateFreightLogisticsModel());

  double enteredValue = 0;

  Future<void> showResultDialog(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // final List<DoubleNumericTextEditingController> plantGrossWgtController = [];
  // final List<DoubleNumericTextEditingController> plantNetWeightController = [];
  // final List<DoubleNumericTextEditingController> plantTareWeightController = [];

  final DoubleNumericTextEditingController plantGrossWgtController =
      DoubleNumericTextEditingController();
  final DoubleNumericTextEditingController plantTareWeightController =
      DoubleNumericTextEditingController();
  final DoubleNumericTextEditingController plantNetWeightController =
      DoubleNumericTextEditingController();

  final List<DoubleNumericTextEditingController> tollTaxController = [];
  final List<DoubleNumericTextEditingController> kataController = [];
  final List<DoubleNumericTextEditingController> grossWeightController = [];
  final List<DoubleNumericTextEditingController> othersController = [];
  final List<DoubleNumericTextEditingController> tareWeightController = [];
  final List<DoubleNumericTextEditingController> netWeightController = [];
  final List<DoubleNumericTextEditingController> shortageQtyController = [];
  final List<LimitedLengthTextController> remarkController = [];
  ValueNotifier<bool> remarkson = ValueNotifier(false);

  ValueNotifier<double> netWeight = ValueNotifier(0);
  RxBool loaderScreen = false.obs;

  // String uomConverter(
  //     {required String qtyunit, required bool uom, required String diuOm}) {
  //   String convertedQty = "";
  //   // if (diuOm == "TO") {
  //   if (uom == true) {
  //     convertedQty = "${double.tryParse(qtyunit)! * 1000}";
  //   } else {
  //     convertedQty = "${double.tryParse(qtyunit)! * 20}";
  //   }
  //   // }
  //   print("convertedQty $convertedQty");
  //   return convertedQty;
  // }

  @override
  void initState() {
    super.initState();
    fetchEditFrBill(billNo: control.billNo.value);
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);

  List<LogisticApprovalDiList> getCurrentPageItems(
      List<LogisticApprovalDiList> items, int currentPage) {
    editFreightBillListResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<LogisticApprovalDiList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  final ProcessFreightBillModel response = ProcessFreightBillModel();
  fetchEditFrBill({required String billNo}) async {
    try {
      loaderScreen.value = true;
      final ValidateFreightLogisticsModel response = await ViewFreightBillApi()
          .validateFReightBillLogisticsApi(
              billNo: billNo, role: "TRANSPORTER", ctx: context);
      loaderScreen.value = false;
      editFrBillAll.value = response;

      originalEditFreightBillList =
          response.serviceDTO?.logisticApprovalDiList ?? [];

      for (int i = 0; i < originalEditFreightBillList.length; i++) {
        tollTaxController.add(DoubleNumericTextEditingController(
            text: originalEditFreightBillList[i].tollTax));
        kataController.add(DoubleNumericTextEditingController(
            text: originalEditFreightBillList[i].kata));
        shortageQtyController.add(DoubleNumericTextEditingController(
            text: originalEditFreightBillList[i].shortageQty));
        othersController.add(DoubleNumericTextEditingController(
            text: originalEditFreightBillList[i].other));
        grossWeightController.add(DoubleNumericTextEditingController(
            text: originalEditFreightBillList[i].grossWeight));
        tareWeightController.add(DoubleNumericTextEditingController(
            text: originalEditFreightBillList[i].tareWeight));
        netWeightController.add(DoubleNumericTextEditingController(
            text: originalEditFreightBillList[i].netWeight));
        remarkController.add(LimitedLengthTextController(
            text: originalEditFreightBillList[i].remarks ?? ""));
        netWeight = (ValueNotifier((double.parse(
                (originalEditFreightBillList[i].grossWeight ?? 0).toString()) -
            double.parse(
                (originalEditFreightBillList[i].tareWeight ?? 0).toString()))));
      }

      editFreightBillListResponseList1.value =
          getCurrentPageItems(originalEditFreightBillList, currentPage);
    } catch (e) {
      // print("error in fetch data $e");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      editFreightBillListResponseList1.value =
          getCurrentPageItems(originalEditFreightBillList, currentPage);
      return;
    }

    List<LogisticApprovalDiList> filteredData = originalEditFreightBillList
        .where((value) =>
            value.billDate
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.billDetailsId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.billNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.cgst
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.districtName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.frtAmount
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.frtNetAmount
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.grNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.grnAndMrnNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.grossWeight
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.invoiceDate
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.invoiceNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.kata
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.netWeight
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.other
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantId.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.sgst.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.shipTo.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.shipToCityId.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.customerCityName.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.stateName.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.tareWeight.toString().toLowerCase().contains(searchTerm.toLowerCase()) | value.tokenNo.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.tollTax.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.truckNo.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.unloadAmount.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.unloadBy.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.unloadingFrt.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.uom.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.grNumber.toString().toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    editFreightBillListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

// Function to calculate and update net weight
  void updateNetWeight(int index) {
    double grossWeight = double.tryParse(grossWeightController[
                index + int.parse(selectedDropdownValue) * (currentPage - 1)]
            .text) ??
        0.0;
    double tareWeight = double.tryParse(tareWeightController[
                index + int.parse(selectedDropdownValue) * (currentPage - 1)]
            .text) ??
        0.0;

    double netWeightValue = grossWeight - tareWeight;
    if (grossWeight == 0.0 && tareWeight != 0.0) {
      netWeightValue = tareWeight;
    } else if (grossWeight != 0.0 && tareWeight == 0.0) {
      netWeightValue = grossWeight;
    }

    netWeight.value = netWeightValue;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 31)) / 100;
    return CustomScaffold(
      appBarText: "Invoicing > Freight Bill",
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ' Edit Freight Bill',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                  vSpace(20),
                  tableHeading(
                    heading: "Bill Info",
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ValueListenableBuilder(
                          valueListenable: editFrBillAll,
                          builder: (BuildContext context,
                              ValidateFreightLogisticsModel value,
                              Widget? child) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  runSpacing: 5,
                                  children: [
                                    customTextField(
                                        label: "Bill No.",
                                        hint: value.serviceDTO?.billNo ?? "",
                                        isConst: true,
                                        disabled: true),

                                    customTextField(
                                        label: "Bill Date",
                                        hint: value.serviceDTO?.billDate ?? "",
                                        isConst: true,
                                        disabled: true),

                                    customTextField(
                                        label: "Organisation Code",
                                        hint: value.serviceDTO?.plantCode
                                                .toString() ??
                                            "",
                                        isConst: true,
                                        disabled: true),

                                    customTextField(
                                      label: "Freight Net Amount",
                                      disabled: true,
                                      hint: IndianCurrencyFormatter.format(
                                          value.serviceDTO?.frtNetAmount ??
                                              0.0),
                                      isConst: true,
                                    ),

                                    customTextField(
                                        label: "SGST",
                                        isConst: true,
                                        disabled: true,
                                        hint: IndianCurrencyFormatter.format(
                                            value.serviceDTO?.sgst ?? 0.0)),

                                    customTextField(
                                        label: "CGST",
                                        isConst: true,
                                        disabled: true,
                                        hint: IndianCurrencyFormatter.format(
                                            value.serviceDTO?.cgst ?? 0.0)),
                                    // customTextField(
                                    //   label: "IGST",
                                    //   isConst: true,
                                    //   disabled: true,
                                    //   hint: IndianCurrencyFormatter.format(
                                    //       value.serviceDTO?. ?? 0.0),
                                    // ),
                                    // wSpace(20),
                                    // customTextField(
                                    //     label: "Tax 4",
                                    //     isConst: true,
                                    //     disabled: true,
                                    //     hint: IndianCurrencyFormatter.format(
                                    //         value.serviceDTO?.tax4 ?? 0.0)),

                                    customTextField(
                                        label: "Net Amt.",
                                        isConst: true,
                                        disabled: true,
                                        hint: IndianCurrencyFormatter.format(
                                            value.serviceDTO?.netAmount ??
                                                0.0)),
                                  
                                  ],
                                ),
                                vSpace(20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Remarks",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    columnHeading(
                                        value.serviceDTO
                                                ?.approvedOrRejectetRemarks ??
                                            "",
                                        fntW: FontWeight.normal,
                                        selectable: true,
                                        wdt: 283,
                                        hgt: 70,
                                        colColor: const Color(0xFFE2E2E2)),
                                  ],
                                ),
                                vSpace(16),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [SizedBox()],
                                ),
                              ],
                            );
                          },
                        )),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Records"),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        color: const Color(0xffE2E2E2),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    children: [
                                      const Text("Display",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto')),
                                      wSpace(6),
                                      SizedBox(
                                          width: 65,
                                          height: 22,
                                          child: PreCustomDropdownMenu(
                                            selVal: selectedDropdownValue,
                                            list: const [
                                              "10",
                                              "20",
                                              "30",
                                              "50",
                                              "100"
                                            ],
                                            onChanged: (value) async {
                                              // Update the selected value when the dropdown changes
                                              setState(() {
                                                selectedDropdownValue = value;
                                                pageSize = int.parse(value);
                                                currentPage = 1;
                                              });
                                              filterData(searchValue);
                                            },
                                          )),
                                      wSpace(6),
                                      size.width > 600
                                          ? const Text("records",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12))
                                          : Container(),
                                    ],
                                  ),
                                ),
                                const Text("Search",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "RobotoLight")),
                                wSpace(10),
                                SizedBox(
                                  height: 22,
                                  width: 130,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  //   border: Border.all(
                                  //     width: 0.5,
                                  //   ),
                                  //   color: Colors.white,
                                  // ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.5,
                                            color: Colors.grey.shade600),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffA0A0A0)),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        textBaseline: TextBaseline.alphabetic,
                                        fontWeight: FontWeight.w100),
                                    onChanged: (val) {
                                      filterData(val);
                                    },
                                  ),
                                ),
                              ],
                            )),
                      )),
                    ],
                  ),
                  ValueListenableBuilder(
                      valueListenable: editFreightBillListResponseList1,
                      builder: (BuildContext context,
                          List<LogisticApprovalDiList> data, Widget? child) {
                        if (data.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Text("No data found"),
                            ),
                          );
                        } else {
                          return CustomTable(
                            columns: [
                              const DataColumn(
                                label: TableColumn(
                                  "Sr.No",
                                  heading: true,
                                  width: 32,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Bill No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Bill Date",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Org Code",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "DI No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Token No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              // DataColumn(
                              //   label: TableColumn(
                              //     "GRN / MRN",
                              //     heading: true,
                              //     width: dynamicSize,
                              //   ),
                              // ),
                              DataColumn(
                                label: TableColumn(
                                  "Truck No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Inv No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Inv. Date",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Ship To",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Ship To City",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "UOM",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Inv Qty",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Shortage Qty",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Frt. Rate",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Special Frt Rate",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Unloading Frt Rate",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Gross Wt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Tare Wt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Net Wt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              // DataColumn(
                              //   label: TableColumn(
                              //     "Tyre Amt",
                              //     heading: true,
                              //     width: dynamicSize,
                              //   ),
                              // ),
                              DataColumn(
                                label: TableColumn(
                                  "Unloaded By",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              
                              DataColumn(
                                label: TableColumn(
                                  "Kata Amt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Toll Tax",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Border Entry Charges",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Gross Amt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "SGST",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "CGST",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Total Amt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Actions",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                            ],
                            rows: List.generate(
                              data.length,
                              (index) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      TableColumn(
                                        "${index + 1}",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].billNo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].billDate ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].plantId.toString(),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].diNo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].tokenNo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    // DataCell(
                                    //   TableColumn(
                                    //     data[index].grnAndMrnNo ?? "",
                                    //     index: index,
                                    //   ),
                                    // ),
                                    DataCell(
                                      TableColumn(
                                        data[index].truckNo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].invoiceNo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                                data[index].invoiceDate ??
                                                    DateTime.now().toString())),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].shipTo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].customerCityName ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].uom ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].diQuantity.toString(),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].shortageQty.toString(),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].frtAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].specialFrtRate ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].unloadingFrtRate ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        (data[index].grossWeight??"").toString(),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        (data[index].tareWeight??"").toString(),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        (data[index].netWeight??"").toString(),
                                        index: index,
                                      ),
                                    ),
                                    // DataCell(
                                    //   TableColumn(
                                    //     IndianCurrencyFormatter.format(
                                    //         data[index].tyreAmount ?? 0),
                                    //     index: index,
                                    //   ),
                                    // ),
                                    DataCell(
                                      TableColumn(
                                        data[index].unloadBy ?? "",
                                        index: index,
                                      ),
                                    ),
                                    
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].kata ?? 0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].tollTax ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].other ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].frtNetAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].sgst ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].cgst ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].netAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(data[index].tokenRank == 1
                                        ? TableColumnActionIcon(
                                            index: index,
                                            icon: Image.asset(
                                              "assets/images/searchicon.png",
                                              color: Colors.green,
                                            ),
                                            onPressed: () async {
                                              netWeight.value = double.parse(
                                                  netWeightController[index +
                                                          int.parse(
                                                                  selectedDropdownValue) *
                                                              (currentPage - 1)]
                                                      .value
                                                      .text);

                                              loaderScreen.value = true;
                                              final FreightBillDiQtyModel res =
                                                  await FreightBillApi()
                                                      .getDiQtyAndFreightAmt(
                                                          ctx: context,
                                                          tokenNumber: data[
                                                                      index]
                                                                  .tokenNo ??
                                                              "");
                                              loaderScreen.value = false;

                                              plantGrossWgtController
                                                  .text = (res.serviceDTO
                                                          ?.plantGrossWeight ??
                                                      "")
                                                  .toString();

                                              plantTareWeightController
                                                  .text = (res.serviceDTO
                                                          ?.plantTareWeight ??
                                                      "")
                                                  .toString();
                                              plantNetWeightController.text =
                                                  res.serviceDTO?.plantNetWeight
                                                          .toString() ??
                                                      "";

                                              // ignore: use_build_context_synchronously
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    if (othersController[index +
                                                                    int.parse(
                                                                            selectedDropdownValue) *
                                                                        (currentPage -
                                                                            1)]
                                                                .text ==
                                                            "0" ||
                                                        othersController[index +
                                                                int.parse(
                                                                        selectedDropdownValue) *
                                                                    (currentPage -
                                                                        1)]
                                                            .text
                                                            .isEmpty) {
                                                      remarkson.value = false;
                                                    } else {
                                                      remarkson.value = true;
                                                    }
                                                    return Stack(
                                                      children: [
                                                        CustomPopup1(
                                                            height: 380,
                                                            width: 914,
                                                            buttonLabel1:
                                                                "Save",
                                                            buttonLabel2:
                                                                "Cancel",
                                                            title:
                                                                "Token No. ${data[index].tokenNo}",
                                                            ontap1: () async {
                                                              if (othersController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty ||
                                                                      kataController[index + int.parse(selectedDropdownValue) * (currentPage - 1)]
                                                                          .text
                                                                          .isEmpty ||
                                                                      grossWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)]
                                                                          .text
                                                                          .isEmpty ||
                                                                      tareWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)]
                                                                          .text
                                                                          .isEmpty ||
                                                                      (remarkson.value && remarkController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty ||
                                                                          tollTaxController[index + int.parse(selectedDropdownValue) * (currentPage - 1)]
                                                                              .text
                                                                              .isEmpty)
                                                                  //  netWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty ||
                                                                  ) {
                                                                showResultDialog(
                                                                    "Please fill all required fields.");
                                                                return;
                                                                // Exit function
                                                              }
                                                              // else if ((double.parse(
                                                              //     netWeight[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                              //         .value
                                                              //         .toString())
                                                              //     .isNegative) ||
                                                              //     (double.parse(netWeight[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                              //         .value
                                                              //         .toString())
                                                              //         .isEqual(0))) {
                                                              //   showResultDialog(
                                                              //       "Net Weight should not be negative or 0");
                                                              //   return;
                                                              // }
                                                              loaderScreen
                                                                  .value = true;
                                                              await FreightBillApi().updateDi(
                                                                  tokenNumber:
                                                                      data[index].tokenNo ??
                                                                          "",
                                                                  shortageQuantity: data[index].diType == "STO"
                                                                      ? data[index]
                                                                          .shortageQty
                                                                          .toString()
                                                                      : shortageQtyController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                                          .text,
                                                                  ctx: context,
                                                                  diNumber: data[index]
                                                                      .diNo
                                                                      .toString(),
                                                                  diUom: "KG",
                                                                  tollTax:
                                                                      tollTaxController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                                          .text,
                                                                  kata: kataController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                                      .text,
                                                                  other:
                                                                      othersController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                                          .text,
                                                                  grossWeight:
                                                                      grossWeightController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                                          .text,
                                                                  tareWeight:
                                                                      tareWeightController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                                          .text,
                                                                  netWeight: netWeight.value.toString(),
                                                                  tyreAmount: "0");
                                                              await fetchEditFrBill(
                                                                  billNo: control
                                                                      .billNo.value);
                                                              loaderScreen
                                                                      .value =
                                                                  false;

                                                              // ignore: use_build_context_synchronously
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                            },
                                                            ontap2: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            columnChildrens: [
                                                              SizedBox(
                                                                  height: 270,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child: Wrap(
                                                                      spacing:
                                                                          20,
                                                                      runSpacing:
                                                                          10,
                                                                      alignment: size.width >
                                                                              600
                                                                          ? WrapAlignment
                                                                              .start
                                                                          : WrapAlignment
                                                                              .center,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              child: Container(
                                                                                height: 32,
                                                                                width: 200,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: const Text(
                                                                                  "Plant Weight :",
                                                                                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        customTextField(
                                                                          width:
                                                                              200,
                                                                          disabled:
                                                                              true,
                                                                          isConst:
                                                                              true,
                                                                          controller:
                                                                              plantGrossWgtController,
                                                                          label:
                                                                              "Gross Weight",
                                                                        ),
                                                                        customTextField(
                                                                          width:
                                                                              200,
                                                                          disabled:
                                                                              true,
                                                                          isConst:
                                                                              true,
                                                                          controller:
                                                                              plantTareWeightController,
                                                                          label:
                                                                              "Tare Weight",
                                                                        ),
                                                                        customTextField(
                                                                          width:
                                                                              200,
                                                                          disabled:
                                                                              true,
                                                                          isConst:
                                                                              true,
                                                                          controller:
                                                                              plantNetWeightController,
                                                                          label:
                                                                              "Net Weight",
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              child: Container(
                                                                                height: 32,
                                                                                width: 200,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: const Text(
                                                                                  "Out Side Weight :",
                                                                                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        customTextField(
                                                                          width:
                                                                              200,
                                                                          controller:
                                                                              grossWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)],
                                                                          label:
                                                                              "Gross Weight",
                                                                          onChanged:
                                                                              (value) {
                                                                            updateNetWeight(index);
                                                                          },
                                                                        ),
                                                                        customTextField(
                                                                          width:
                                                                              200,
                                                                          controller:
                                                                              tareWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)],
                                                                          label:
                                                                              "Tare Weight",
                                                                          onChanged:
                                                                              (value) {
                                                                            updateNetWeight(index);
                                                                          },
                                                                        ),
                                                                        ValueListenableBuilder(
                                                                          valueListenable:
                                                                              netWeight,
                                                                          builder: (BuildContext context,
                                                                              double value,
                                                                              Widget? child) {
                                                                            return customTextField(
                                                                              width: 200,
                                                                              isConst: true,
                                                                              disabled: true,
                                                                              hint: value.toString(),
                                                                              label: "Net Weight",
                                                                            );
                                                                          },
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              child: Container(
                                                                                height: 32,
                                                                                width: 200,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: const Text(
                                                                                  "On Route Charges :",
                                                                                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        customTextField(
                                                                          width:
                                                                              200,
                                                                          controller:
                                                                              kataController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))],
                                                                          label:
                                                                              "Kata Amount",
                                                                        ),
                                                                        customTextField(
                                                                            width:
                                                                                200,
                                                                            controller:
                                                                                tollTaxController[index + int.parse(selectedDropdownValue) * (currentPage - 1)],
                                                                            label: "Toll Tax"),
                                                                        customTextField(
                                                                          width:
                                                                              200,
                                                                          controller:
                                                                              othersController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))],
                                                                          label:
                                                                              "Border Entry Charges",
                                                                          onChanged:
                                                                              (others) {
                                                                            if (others == "0" ||
                                                                                others.isEmpty) {
                                                                              remarkson.value = false;
                                                                            } else {
                                                                              remarkson.value = true;
                                                                            }
                                                                          },
                                                                        ),
                                                                        size.width >
                                                                                600
                                                                            ? const SizedBox(
                                                                                width: 200,
                                                                              )
                                                                            : Container(),
                                                                        ValueListenableBuilder(
                                                                          valueListenable:
                                                                              remarkson,
                                                                          builder: (BuildContext context,
                                                                              bool value,
                                                                              Widget? child) {
                                                                            return customTextField(
                                                                              width: 200,
                                                                              disabled: value ? false : true,
                                                                              controller: remarkController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))],
                                                                              label: "Remarks",
                                                                            );
                                                                          },
                                                                        ),
                                                                        data[index].diType ==
                                                                                "DI"
                                                                            ? customTextField(
                                                                                width: 200,
                                                                                controller: shortageQtyController[index + int.parse(selectedDropdownValue) * (currentPage - 1)],
                                                                                label: "Shortage Quantity",
                                                                              )
                                                                            : Container()
                                                                      ],
                                                                    ),
                                                                  )),
                                                            ]),
                                                      ],
                                                    );
                                                  });
                                            })
                                        : Container())
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }),
                  Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        child: size.width > 600
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable:
                                        editFreightBillListResponseList,
                                    builder: (BuildContext context,
                                        List<LogisticApprovalDiList> value,
                                        Widget? child) {
                                      if (value.isEmpty) {
                                        return Center(child: Container());
                                      }
                                      return Text(
                                          "Showing 1 to ${editFreightBillListResponseList1.value.length} of ${value.length} entries",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal));
                                    },
                                  ),
                                  const Expanded(child: SizedBox()),
                                  buildValueListenableBuilder(),

                                  const Expanded(child: SizedBox()),
                                  // buildValueListenableBuilder(),
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        button(
                                            btnText: "Back",
                                            btnClr: Colors.white,
                                            btnTxtClr: ColorConstant.redbar,
                                            tapFunction: () {
                                              control.backViewBill.value = true;
                                              control.currentIndex.value = 27;
                                            }),
                                        wSpace(16),
                                        ValueListenableBuilder(
                                          valueListenable: editFrBillAll,
                                          builder: (BuildContext context,
                                              ValidateFreightLogisticsModel
                                                  value,
                                              Widget? child) {
                                            return control.billStatus.value ==
                                                    "REJECTED"
                                                ?Obx(() =>  button(
                                                    btnText: "Resubmit",
                                                    btnClr:
                                                        ColorConstant.redbar,
                                                    btnTxtClr: Colors.white,
                                                    tapFunction:loaderScreen.value?null: () async {
                                                      try {
                                                        loaderScreen.value=true;
                                                        await ViewFreightBillApi()
                                                            .resubmitFreightBillApi(
                                                                billNo: value
                                                                        .serviceDTO
                                                                        ?.billNo ??
                                                                    "",
                                                                ctx: context);
                                                                loaderScreen.value=false;
                                                      } catch (e) {
                                                        // print(
                                                        //     "error in resubmit button $e");
                                                      }
                                                      control.billStatus.value =
                                                          "RESUBMITTED";
                                                      setState(() {});
                                                    }))
                                                : Container();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Wrap(
                                runSpacing: 5,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable:
                                        editFreightBillListResponseList,
                                    builder: (BuildContext context,
                                        List<LogisticApprovalDiList> value,
                                        Widget? child) {
                                      if (value.isEmpty) {
                                        return Center(child: Container());
                                      }
                                      return Text(
                                          "Showing 1 to ${editFreightBillListResponseList1.value.length} of ${value.length} entries",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal));
                                    },
                                  ),

                                  buildValueListenableBuilder(),

                                  // buildValueListenableBuilder(),
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        button(
                                            btnText: "Back",
                                            btnClr: Colors.white,
                                            btnTxtClr: ColorConstant.redbar,
                                            tapFunction: () {
                                              control.backViewBill.value = true;
                                              control.currentIndex.value = 27;
                                            }),
                                        wSpace(16),
                                        ValueListenableBuilder(
                                          valueListenable: editFrBillAll,
                                          builder: (BuildContext context,
                                              ValidateFreightLogisticsModel
                                                  value,
                                              Widget? child) {
                                            return control.billStatus.value ==
                                                    "REJECTED"
                                                ?Obx(() =>  button(
                                                    btnText: "Resubmit",
                                                    tapFunction:loaderScreen.value?null: () async {
                                                    
                                                      try {  loaderScreen.value=true;
                                                        await ViewFreightBillApi()
                                                            .resubmitFreightBillApi(
                                                                billNo: value
                                                                        .serviceDTO
                                                                        ?.billNo ??
                                                                    "",
                                                                ctx: context);
                                                                loaderScreen.value=false;
                                                      } catch (e) {
                                                        // print(
                                                        //     "error in resubmit button $e");
                                                      }
                                                      control.billStatus.value =
                                                          "RESUBMITTED";
                                                      setState(() {});
                                                    }))
                                                : Container();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => Visibility(
                visible: loaderScreen.value,
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.redbar,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ValueListenableBuilder<List<LogisticApprovalDiList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: editFreightBillListResponseList,
      builder: (BuildContext context, List<LogisticApprovalDiList> value,
          Widget? child) {
        if (value.isEmpty) {
          return Center(child: Container());
        }
        return Obx(() {
          int itemsPerPage = int.parse(selectedDropdownValue);
          int numberOfPages = (value.length / itemsPerPage).ceil();

          // Calculate the range of pages to display
          int startPage = (currentPagination.value - 2).clamp(1, numberOfPages);
          int endPage = (currentPagination.value + 2).clamp(1, numberOfPages);

          List<Widget> pageWidgets = [];

          // Add "Previous" button if necessary
          if (currentPage > 1) {
            pageWidgets.add(
              Container(
                margin: const EdgeInsets.only(right: 1),
                child: InkWell(
                  child: navBox(
                      boxWidth: 70,
                      text: "Previous",
                      txtClr: ColorConstant.redbar,
                      bgClr: Colors.white),
                  onTap: () async {
                    // isLoading.value=true;
                    currentPage--;
                    currentPagination.value = currentPage;
                    filterData(searchValue);
                  },
                ),
              ),
            );
          }

          // Add the page buttons
          for (int i = startPage; i <= endPage; i++) {
            pageWidgets.add(Obx(() {
              return InkWell(
                child: navBox(
                    boxWidth: 25,
                    text: i.toString(),
                    txtClr: (currentPagination.value == i)
                        ? Colors.white
                        : ColorConstant.redbar,
                    bgClr: (currentPagination.value == i)
                        ? ColorConstant.redbar
                        : Colors.white),
                onTap: () async {
                  // isLoading.value=true;
                  currentPagination.value = i;
                  currentPage = i;
                  filterData(searchValue);
                },
              );
            }));
          }

          // Add "Next" button if necessary
          if (endPage < numberOfPages) {
            pageWidgets.add(
              Container(
                margin: const EdgeInsets.only(left: 1),
                child: InkWell(
                  child: navBox(
                      boxWidth: 70,
                      text: "Next",
                      txtClr: ColorConstant.redbar,
                      bgClr: Colors.white),
                  onTap: () async {
                    // isLoading.value=true;
                    currentPage++;
                    currentPagination.value = currentPage;
                    filterData(searchValue);
                  },
                ),
              ),
            );
          }

          return Row(
            children: pageWidgets,
          );
        });
      },
    );
  }
}
