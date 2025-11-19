// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
import 'package:shreecement/features/invoicing/apis/view_freightbill_api.dart';
import 'package:shreecement/features/invoicing/models/validate_freight_logistics_model.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../../../main.dart';
import './view_frieght_bill.dart';
import '../../common/controller/indian_currency.dart';

class ValidateFreightBillLogistics extends StatefulWidget {
  const ValidateFreightBillLogistics({super.key});

  @override
  State<ValidateFreightBillLogistics> createState() =>
      _ValidateFreightBillLogisticsState();
}

class _ValidateFreightBillLogisticsState
    extends State<ValidateFreightBillLogistics> {
  List<LogisticApprovalDiList> originalvalidateFrBill = [];
  ValueNotifier<List<LogisticApprovalDiList>>
      viewFrieghBillLogisticsResponseList = ValueNotifier([]);
  ValueNotifier<List<LogisticApprovalDiList>>
      viewFrieghBillLogisticsResponseList1 = ValueNotifier([]);
  ValueNotifier<ValidateFreightLogisticsModel> validatefrlogistics =
      ValueNotifier(ValidateFreightLogisticsModel());
  LimitedLengthTextController100 remarkController =
      LimitedLengthTextController100();
  RxBool loaderScreen = false.obs;
  RxInt currentPagination = 1.obs;
  double enteredValue = 0;
  String searchValue = "";

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

  @override
  void initState() {
    super.initState();
    fetchValidateFrBillLogistics(billNo: controller.billNo.value);
    // print(controller.billStatus);
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<LogisticApprovalDiList> getCurrentPageItems(
      List<LogisticApprovalDiList> items, int currentPage) {
    viewFrieghBillLogisticsResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<LogisticApprovalDiList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  fetchValidateFrBillLogistics({required String billNo}) async {
    try {
      loaderScreen.value = true;
      final ValidateFreightLogisticsModel response = await ViewFreightBillApi()
          .validateFReightBillLogisticsApi(
              billNo: billNo, role: "LOGISTIC", ctx: context);
      validatefrlogistics.value = response;
      loaderScreen.value = false;
      originalvalidateFrBill =
          response.serviceDTO?.logisticApprovalDiList ?? [];

      viewFrieghBillLogisticsResponseList1.value =
          getCurrentPageItems(originalvalidateFrBill, currentPage);
    } catch (e) {
      // print("error in fetch data $e");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      viewFrieghBillLogisticsResponseList1.value =
          getCurrentPageItems(originalvalidateFrBill, currentPage);
      return;
    }

    List<LogisticApprovalDiList> filteredData = originalvalidateFrBill
        .where((value) =>
            value.billDate
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
            value.diQuantity
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.frtAmount
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
            value.netAmount
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
            value.plantId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.sgst
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.igst
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.shipTo.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.customerCityName.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.tareWeight.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.tokenNo.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.tollTax.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.transporterName.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.truckNo.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.unloadAmount.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.unloadBy.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.uom.toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
            value.frtNetAmount.toString().toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    viewFrieghBillLogisticsResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 32)) / 100;
    return CustomScaffold(
      appBarText: "Freight Bill > Freight Bill",
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
                    ' Validate Freight Bill',
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
                          valueListenable: validatefrlogistics,
                          builder: (BuildContext context,
                              ValidateFreightLogisticsModel value,
                              Widget? child) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 5,
                                  children: [
                                    customTextField(
                                        label: "Organisation Name",
                                        hint: sp?.getString("orgName") ?? "",
                                        isConst: true,
                                        disabled: true),

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
                                      label: "Freight Net Amount",
                                      disabled: true,
                                      hint: IndianCurrencyFormatter.format(
                                          value.serviceDTO?.frtNetAmount ??
                                              0.0),
                                      isConst: true,
                                    ),

                                    customTextField(
                                        label: "IGST",
                                        isConst: true,
                                        disabled: true,
                                        hint: IndianCurrencyFormatter.format(
                                            value.serviceDTO?.igst ?? 0.0)),

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

                                    //  customTextField(
                                    //      label: "IGST",
                                    //      isConst: true,
                                    //      disabled: true,
                                    //      hint: IndianCurrencyFormatter.format(
                                    //          value.serviceDTO?.sgst ?? 0.0)),
                                    //  wSpace(20),
                                    //  customTextField(
                                    //      label: "Tax 4",
                                    //      isConst: true,
                                    //      disabled: true,
                                    //      hint: IndianCurrencyFormatter.format(
                                    //          value.serviceDTO?.tax4 ?? 0.0)),
                                    //  wSpace(20),
                                    customTextField(
                                        label: "Total Amt.",
                                        isConst: true,
                                        disabled: true,
                                        hint: IndianCurrencyFormatter.format(
                                            value.serviceDTO?.netAmount ??
                                                0.0)),
                                  ],
                                ),
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
                                              await fetchValidateFrBillLogistics(
                                                  billNo: controller.billNo.value);
                                            },
                                          )),
                                      wSpace(6),
                                      size.width > 600
                                          ? const Text("records",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12))
                                          : Container()
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
                      valueListenable: viewFrieghBillLogisticsResponseList1,
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
                                  "Transporter",
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
                              DataColumn(
                                label: TableColumn(
                                  "LR / GR",
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
                                  "Inv  No.",
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
                                  "Net Amt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "IGST",
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
                                  "Remarks",
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
                                        data[index].transporterName ?? "",
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
                                    DataCell(
                                      TableColumn(
                                        data[index].grNumber ?? "",
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
                                    //     DataCell(
                                    //       TableColumn(
                                    // IndianCurrencyFormatter.format(data[index].tyreAmount??0),
                                    //         index: index,
                                    //       ),
                                    //     ),
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
                                            data[index].netAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].igst ?? 0.0),
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
                                        data[index].remarks ?? "",
                                        index: index,
                                      ),
                                    ),

                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].totalAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }),
                  size.width > 600
                      ? Container(
                          color: Colors.grey.shade200,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable:
                                        viewFrieghBillLogisticsResponseList1,
                                    builder: (BuildContext context,
                                        List<LogisticApprovalDiList> value,
                                        Widget? child) {
                                      if (value.isEmpty) {
                                        return Center(child: Container());
                                      }
                                      return Text(
                                          "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${viewFrieghBillLogisticsResponseList.value.length} entries",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal));
                                    },
                                  ),
                                  const Expanded(child: SizedBox()),
                                  buildValueListenableBuilder(),
                                  const Expanded(child: SizedBox()),
                                  SizedBox(
                                      child: ValueListenableBuilder(
                                    valueListenable: validatefrlogistics,
                                    builder: (BuildContext context,
                                        ValidateFreightLogisticsModel value,
                                        Widget? child) {
                                      return Row(
                                        children: [
                                          button(
                                              btnText: "Back",
                                              btnClr: ColorConstant.redbar,
                                              btnTxtClr: Colors.white,
                                              tapFunction: () {
                                                try {
                                                  // print(controller.billNo.value);
                                                  // print(controller.currentIndex.value );

                                                  
                                                  controller.back.value = true;
                                                  controller.currentIndex.value =
                                                      28;
                                                } catch (e) {
                                                  // print("error on back $e");
                                                }
                                              }),
                                          wSpace(5),
                                          controller.billStatus.value != "APPROVED" &&
                                            controller.billStatus.value != "HOLD" &&  controller.billStatus.value != "UNHOLD" &&
                                                  controller.billStatus.value != 
                                                      "REJECTED"
                                              ? button(
                                                  btnText: "Approve",
                                                  tapFunction: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Message'),
                                                          content: const Text(
                                                              "Do you want to Approve?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await ViewFreightBillApi().approveOrRejectFrBillApi(
                                                                    billNo: value
                                                                            .serviceDTO
                                                                            ?.billNo ??
                                                                        "",
                                                                    isApproved:
                                                                        "1",
                                                                    isRejected:
                                                                        "0",
                                                                    remark:
                                                                        "This bill is approved");
                                                                controller.billStatus.value =
                                                                    "APPROVED";
                                                                setState(() {});
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
                                              : Container(),
                                          wSpace(5),
                                          controller.billStatus.value != "APPROVED" &&
                                          controller.billStatus.value != "HOLD" &&  controller.billStatus.value != "UNHOLD" &&
                                                  controller.billStatus.value !=
                                                      "REJECTED"
                                              ? button(
                                                  btnText: "Reject",
                                                  btnTxtClr:
                                                      ColorConstant.redbar,
                                                  btnClr: Colors.white,
                                                  tapFunction: () {
                                                    showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Message'),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                customTextField2(
                                                                    controller:
                                                                        remarkController,
                                                                    label:
                                                                        "Remarks")
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (remarkController
                                                                      .text
                                                                      .isEmpty) {
                                                                    showResultDialog(
                                                                        "Please enter Remarks to continue");
                                                                  }
                                                                  await ViewFreightBillApi().approveOrRejectFrBillApi(
                                                                      billNo: value
                                                                              .serviceDTO
                                                                              ?.billNo ??
                                                                          "",
                                                                      isApproved:
                                                                          "0",
                                                                      isRejected:
                                                                          "1",
                                                                      remark: remarkController
                                                                          .text);
                                                                  controller.billStatus.value =
                                                                      "REJECTED";
                                                                  setState(
                                                                      () {});
                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Ok'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                )
                                              : Container()
                                        ],
                                      );
                                    },
                                  ))
                                ],
                              )),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 5),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                runSpacing: 15,
                                spacing: 20,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable:
                                        viewFrieghBillLogisticsResponseList,
                                    builder: (BuildContext context,
                                        List<LogisticApprovalDiList> value,
                                        Widget? child) {
                                      if (value.isEmpty) {
                                        return Center(child: Container());
                                      }
                                      return Text(
                                          "Showing ${viewFrieghBillLogisticsResponseList.value.length} of ${value.length}  entries",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal));
                                    },
                                  ),
                                  buildValueListenableBuilder(),
                                  SizedBox(
                                      child: ValueListenableBuilder(
                                    valueListenable: validatefrlogistics,
                                    builder: (BuildContext context,
                                        ValidateFreightLogisticsModel value,
                                        Widget? child) {
                                      return Row(
                                        children: [
                                          button(
                                              btnText: "Back",
                                              btnClr: ColorConstant.redbar,
                                              btnTxtClr: Colors.white,
                                              tapFunction: () {
                                                
                                                controller.back.value = true;
                                                controller.currentIndex.value = 28;
                                              }),
                                          wSpace(5),
                                          controller.billStatus.value != "APPROVED" &&
                                          controller.billStatus.value != "HOLD" &&  controller.billStatus.value != "UNHOLD" &&
                                                  controller.billStatus.value !=
                                                      "REJECTED"
                                              ? button(
                                                  btnText: "Approve",
                                                  tapFunction: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Message'),
                                                          content: const Text(
                                                              "Do you want to Approve?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await ViewFreightBillApi().approveOrRejectFrBillApi(
                                                                    billNo: value
                                                                            .serviceDTO
                                                                            ?.billNo ??
                                                                        "",
                                                                    isApproved:
                                                                        "1",
                                                                    isRejected:
                                                                        "0",
                                                                    remark:
                                                                        "This bill is approved");
                                                                controller.billStatus.value =
                                                                    "APPROVED";
                                                                setState(() {});
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
                                              : Container(),
                                          wSpace(5),
                                          controller.billStatus.value != "APPROVED" &&
                                          controller.billStatus.value != "HOLD" &&  controller.billStatus.value != "UNHOLD" &&
                                                  controller.billStatus.value !=
                                                      "REJECTED"
                                              ? button(
                                                  btnText: "Reject",
                                                  btnTxtClr:
                                                      ColorConstant.redbar,
                                                  btnClr: Colors.white,
                                                  tapFunction: () {
                                                    showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Message'),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                customTextField2(
                                                                    controller:
                                                                        remarkController,
                                                                    label:
                                                                        "Remarks")
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (remarkController
                                                                      .text
                                                                      .isEmpty) {
                                                                    showResultDialog(
                                                                        "Please enter Remarks to continue");
                                                                  }
                                                                  await ViewFreightBillApi().approveOrRejectFrBillApi(
                                                                      billNo: value
                                                                              .serviceDTO
                                                                              ?.billNo ??
                                                                          "",
                                                                      isApproved:
                                                                          "0",
                                                                      isRejected:
                                                                          "1",
                                                                      remark: remarkController
                                                                          .text);
                                                                  controller.billStatus.value =
                                                                      "REJECTED";
                                                                  setState(
                                                                      () {});
                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Ok'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                )
                                              : Container()
                                        ],
                                      );
                                    },
                                  ))
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
      valueListenable: viewFrieghBillLogisticsResponseList,
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
