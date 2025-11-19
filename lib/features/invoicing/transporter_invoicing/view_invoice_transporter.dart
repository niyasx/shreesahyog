// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/controller/indian_currency.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_3.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
import 'package:shreecement/features/common/widgets/invoice_dialogebox.dart';
import 'package:shreecement/features/invoicing/apis/view_freightbill_api.dart';
import 'package:shreecement/features/invoicing/models/transporter_view_invoice_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../apis/shortage_master_apis.dart';

class ViewInvoiceTransporter extends StatefulWidget {
  const ViewInvoiceTransporter({super.key});

  @override
  State<ViewInvoiceTransporter> createState() => _ViewInvoiceTransporterState();
}

class _ViewInvoiceTransporterState extends State<ViewInvoiceTransporter> {
  final Controller control = Get.find(); // Access the controller
  ValueNotifier enabled = ValueNotifier(false);

  ValueNotifier<MapEntry<String, String>> selectedPlant =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedStatus =
      ValueNotifier(const MapEntry("", ""));

  RxBool loaderScreen = false.obs;

  RxInt currentPagination = 1.obs;
  String searchValue = "";

  List<TransporterViewInvoiceResponseList> originalVieInvoiceTransportList = [];
  ValueNotifier<List<TransporterViewInvoiceResponseList>>
      viewInvoiceListResponseList = ValueNotifier([]);
  ValueNotifier<List<TransporterViewInvoiceResponseList>>
      viewInvoiceListResponseList1 = ValueNotifier([]);

  double enteredValue = 0;
  bool saved = false;

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

    int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<TransporterViewInvoiceResponseList> getCurrentPageItems(
      List<TransporterViewInvoiceResponseList> items, int currentPage) {
    viewInvoiceListResponseList1.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<TransporterViewInvoiceResponseList> a = items.sublist(startIndex, endIndex);

    return a;
  }
  fetchViewInvoiceBill({
    required String plantId,
    required String fromDate,
    required String toDate,
    required String status,
  }) async {
    try {
      loaderScreen.value = true;
      final TransporterViewInvoiceModel response = await ViewFreightBillApi()
          .viewInvoiceTransporter(
              ctx: context,
              status: status,
              plantId: plantId,
              fromDate: fromDate,
              toDate: toDate);
      loaderScreen.value = false;
      originalVieInvoiceTransportList = response.responseList ?? [];
      viewInvoiceListResponseList.value =originalVieInvoiceTransportList;
      viewInvoiceListResponseList1.value =
          getCurrentPageItems(originalVieInvoiceTransportList, currentPage);
    } catch (e) {
      // print("error in fetch data $e");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      viewInvoiceListResponseList1.value =
          getCurrentPageItems(originalVieInvoiceTransportList, currentPage);
      return;
    }

    List<TransporterViewInvoiceResponseList> filteredData =
        originalVieInvoiceTransportList
            .where((value) =>
                value.frtNetAmount
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.invoiceDate
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.frtNetAmount
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.netAmount
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.invoiceNo
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.paymentStatus
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .toList();

    viewInvoiceListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  // int? index1;

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  String parseDate(String inputDate) {
    // Check if the inputDate is already in the desired format
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(inputDate)) {
      return inputDate;
    }

    // If not in the desired format, convert it to the desired format
    final parts = inputDate.split('/');
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  String convertDateFormat(DateTime inputDate) {
    // Parse input date
    return DateFormat("yyyy-MM-dd").format(inputDate);
  }

  @override
  Widget build(BuildContext context) {
    fromDateController.text = 
  //   DateFormat('dd/MM/yyyy').format(
  //  DateTime.now().isBefore(DateTime(DateTime.now().year, 4, 1)) ? DateTime.now() : DateTime(DateTime.now().year, 4, 1));


    ///90 days logic
    DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 90)));
    toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 8)) / 100;
    return CustomScaffold(
      appBarText: "Freight Bill > View Payment Status",
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
                    'View Payment Status',
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
                    heading: "Search Invoice",
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 20,
                            runSpacing: 8,
                            children: [
                              FutureBuilder(
                                  future: ShortageMasterApis().getPlantList(),
                                  builder: (stateIndex, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(
                                        color: ColorConstant.redbar,
                                      );
                                    } else if (snapshot.hasData) {
                                      final List responseList =
                                          snapshot.data?.responseList ?? [];
                                      Map<String, String> map = {};

                                      map["Select Plant"] = "Select Plant";
                                      for (var element in responseList) {
                                        map[element.plantName] =
                                            element.plantCode;
                                      }
                                      selectedPlant.value = map.entries.first;

                                      return ValueListenableBuilder(
                                        valueListenable: selectedPlant,
                                        builder: (BuildContext context, data,
                                            Widget? child) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Plant",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              CustomDropdownMenu3(
                                                selVal: selectedPlant.value.key,
                                                list: map.keys.toList(),
                                                fun: (value) {
                                                  if (value == "Select Plant") {
                                                    enabled.value = false;
                                                  } else {
                                                    enabled.value = true;
                                                  }
                                                  selectedPlant.value =
                                                      MapEntry(
                                                    value ?? "",
                                                    map[value] ?? "",
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      Future.delayed(Duration.zero, () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TokenExpire()),
                                        );
                                      });
                                      return const Text(
                                          "Token Error: Recheck token in API");
                                    }
                                  }),
                              FutureBuilder(
                                  future: ShortageMasterApis()
                                      .getBillStatusListFromAPI(),
                                  builder: (stateIndex, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(
                                        color: ColorConstant.redbar,
                                      );
                                    } else if (snapshot.hasData) {
                                      final List responseList =
                                          snapshot.data?.responseList ?? [];
                                      Map<String, String> map = {};

                                      map["All"] = "All";
                                      for (var element in responseList) {
                                        map[element.billStatus] =
                                            element.id.toString();
                                      }
                                      selectedStatus.value = map.entries.first;

                                      return ValueListenableBuilder(
                                        valueListenable: selectedStatus,
                                        builder: (BuildContext context, data,
                                            Widget? child) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Status",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              CustomDropdownMenu3(
                                                  selVal:
                                                      selectedStatus.value.key,
                                                  list: map.keys.toList(),
                                                  fun: (value) async {
                                                    // if (value == "All") {
                                                    //   enabled.value = false;
                                                    // } else {
                                                    //   enabled.value = true;
                                                    // }
                                                    selectedStatus.value =
                                                        MapEntry(
                                                      value ?? "",
                                                      map[value] ?? "",
                                                    );
                                                  }),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      Future.delayed(Duration.zero, () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TokenExpire()),
                                        );
                                      });
                                      return const Text(
                                          "Token Error: Recheck token in API");
                                    }
                                  }),
                              datePicker(
                                label: "From Date",
                                controller: fromDateController,
                                ontap: () =>
                                    selectFromDate(context, fromDateController),
                              ),
                              datePicker(
                                label: "To Date",
                                controller: toDateController,
                                ontap: () =>
                                    selectToDate(context, toDateController),
                              ),
                            ],
                          ),
                          vSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              button(
                                  btnText: "Search",
                                  tapFunction: () async {
                                    if (fromDateController.text.isEmpty ||
                                        toDateController.text.isEmpty ||
                                        selectedPlant.value.key ==
                                            "Select Plant") {
                                      showResultDialog(
                                          "Please fill all required fields.");
                                      return;
                                    }

                                    try {
                                      loaderScreen.value = true;

                                      final toDate = DateTime.parse(
                                          parseDate(toDateController.text));
                                      // Parse from date
                                      final fromDate = DateTime.parse(
                                          parseDate(fromDateController.text));
                                      await fetchViewInvoiceBill(
                                          status: selectedStatus.value.key,
                                          plantId: selectedPlant.value.value,
                                          fromDate: convertDateFormat(fromDate),
                                          toDate: convertDateFormat(toDate));

                                      loaderScreen.value = false;
                                    } catch (e) {
                                      // print("error in search $e");
                                    }
                                  }),
                              wSpace(10),
                              button(
                                  btnText: "Reset",
                                  btnClr: Colors.white,
                                  btnTxtClr: ColorConstant.redbar,
                                  tapFunction: () async {
                                    selectedPlant.value = const MapEntry(
                                        "Select Plant", "Select Plant");
                                    selectedStatus.value =
                                        const MapEntry("All", "All");

                                    fromDateController.text =
  //                                   DateFormat('dd/MM/yyyy').format(
  //  DateTime.now().isBefore(DateTime(DateTime.now().year, 4, 1)) ? DateTime.now() : DateTime(DateTime.now().year, 4, 1));
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.now().subtract(
                                                const Duration(days: 90)));
                                    toDateController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(DateTime.now());
                                    originalVieInvoiceTransportList = [];
                                    viewInvoiceListResponseList
                                        .value = [];
                                    viewInvoiceListResponseList1
                                        .value = [];
                                    setState(() {});
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Search Results"),
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
                      valueListenable: viewInvoiceListResponseList1,
                      builder: (BuildContext context,
                          List<TransporterViewInvoiceResponseList> data,
                          Widget? child) {
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
                                  "Invoice Date",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Invoice No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Freight Amt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Tax Amt.",
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
                                  "Paid Amt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Payment Status",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Action",
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
                                        data[index].invoiceDate ?? "",
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
                                        IndianCurrencyFormatter.format(
                                            data[index].frtNetAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].totalTax ?? 0.0),
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
                                        (data[index].paidAmount == null)
                                            ? ""
                                            : IndianCurrencyFormatter.format(
                                                data[index].paidAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].paymentStatus ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumnActionIcon(
                                        index: index,
                                        icon: Icon(
                                          Icons.receipt_long,
                                          color: Colors.blue.shade900,
                                        ),
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Stack(
                                                  children: [
                                                    InvoicePopup(
                                                        title: "Invoice",
                                                        width: 715,
                                                        height: 550,
                                                        columnChildrens: [
                                                          SizedBox(
                                                            child: Container(
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      maxHeight:
                                                                          450,
                                                                      maxWidth:
                                                                          630),
                                                              child:
                                                                  FutureBuilder(
                                                                future: _loadPdfBytes(
                                                                    data[index]
                                                                            .invoiceNo ??
                                                                        ""),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            Uint8List>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return const Center(
                                                                      child: Text(
                                                                          'You have not uploaded signed Invoice copy.'),
                                                                    );
                                                                  } else if (snapshot
                                                                          .data ==
                                                                      null) {
                                                                    return const Center(
                                                                      child: Text(
                                                                          'You have not uploaded signed Invoice copy.'),
                                                                    );
                                                                  } else if (snapshot
                                                                          .runtimeType ==
                                                                      String) {
                                                                    return const Center(
                                                                      child: Text(
                                                                          'You have not uploaded signed Invoice copy.'),
                                                                    );
                                                                  } else {
                                                                    return SfPdfViewer
                                                                        .memory(
                                                                      snapshot
                                                                          .data!, // Display PDF from bytes
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                        buttons: [
                                                          SizedBox(
                                                            width: 74,
                                                            height: 31,
                                                            child: FittedBox(
                                                              child: button(
                                                                  btnText:
                                                                      'Close',
                                                                  tapFunction:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8.0),
                                                        ]),
                                                    Obx(() => Visibility(
                                                          visible: loaderScreen
                                                              .value,
                                                          child: Container(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    ColorConstant
                                                                        .redbar,
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ),
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
                        child: Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable:
                                  viewInvoiceListResponseList1,
                              builder: (BuildContext context,
                                  List<TransporterViewInvoiceResponseList>
                                      value,
                                  Widget? child) {
                                if (value.isEmpty) {
                                  return Center(child: Container());
                                }
                                return Expanded(
                                  flex: 2,
                                  child: Text(
                                            "Showing ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + 1} to ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + value.length} of ${viewInvoiceListResponseList.value.length} entries",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                );
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            buildValueListenableBuilder()
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
  ValueListenableBuilder<List<TransporterViewInvoiceResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: viewInvoiceListResponseList,
      builder: (BuildContext context, List<TransporterViewInvoiceResponseList> value,
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

Widget datePicker(
    {String? label, TextEditingController? controller, VoidCallback? ontap}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label ?? "label",
        style: const TextStyle(color: Colors.black),
      ),
      Container(
        width: 283,
        height: 30,
        color: Colors.white,
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          controller: controller,
          textAlign: TextAlign.start,
          // textAlignVertical: TextAlignVertical.center,
          onTap: ontap,
          decoration: InputDecoration(
            contentPadding: const EdgeInsetsDirectional.only(start: 15),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            hintText: 'DD/MM/YYYY',
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color.fromRGBO(114, 114, 114, 1),
            ),
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ),
    ],
  );
}



// Future<void> selectFromDate(
//     BuildContext context, TextEditingController textController) async {
//   final now = DateTime.now();
//   final DateTime firstOfApril = DateTime(now.year, 4, 1); // April 1st of the current year
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: firstOfApril.isBefore(now) ? firstOfApril : now, // Start from April 1st or today's date
//     firstDate: firstOfApril, // Earliest selectable date
//     lastDate: now, // Latest selectable date
//   );

//   if (pickedDate != null) {
//     textController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//   }
// }

// Future<void> selectToDate(
//     BuildContext context, TextEditingController textController) async {
//   final now = DateTime.now();
//   final DateTime firstOfApril = DateTime(now.year, 4, 1); // April 1st of the current year
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: now, // Default to today's date
//     firstDate: firstOfApril, // Earliest selectable date
//     lastDate: now, // Latest selectable date
//   );

//   if (pickedDate != null) {
//     textController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//   }
// }

///latest 90 days logic

Future<void> selectFromDate(
    BuildContext context, TextEditingController textcontroller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 90)),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    textcontroller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  }
}

Future<void> selectToDate(
    BuildContext context, TextEditingController textcontroller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 90)),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    textcontroller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  }
}

Future<dynamic> loadPdf({String? billNo}) async {
  final queryParameters = {
    "billNo": billNo,
    "transporterId": sp?.getString("employeeCode") ?? ""
  };
  final uri = Uri.https(
      domain, "/app/finance/freightBill/getinvoicepdf", queryParameters);

  try {
    String? token = await secureStorage.read("token");

    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    if (res.statusCode == 200) {
      Uint8List bytes = Uint8List.fromList(res.bodyBytes);
      return bytes;
    } else if (res.statusCode == 403) {
      throw "You have not uploaded signed Invoice copy.";
    } else if (res.statusCode == 404) {
      throw "You have not uploaded signed Invoice copy.";
    } else {
      return null;
    }
  } catch (e) {
    // print("Error loading PDF: $e");
    return null;
  }
}

Future<Uint8List> _loadPdfBytes(String billNo) async {
  Uint8List data = await loadPdf(billNo: billNo);
  // print(data);
  return data;
}
