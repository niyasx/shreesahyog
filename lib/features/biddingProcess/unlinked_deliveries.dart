import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/biddingProcess/api/unlinked_delivery_api.dart';
import 'package:shreecement/features/biddingProcess/models/unlinked_delivery_model.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:http/http.dart' as http;
import '../../utils/color_constant.dart';
import '../common/controller/controller.dart';
import '../common/widgets/customdropdownprebid.dart';

class UnlinkedDeliveries extends StatefulWidget {
  const UnlinkedDeliveries({super.key});

  @override
  State<UnlinkedDeliveries> createState() => _UnlinkedDeliveriesState();
}

class _UnlinkedDeliveriesState extends State<UnlinkedDeliveries> {
  List<UnlinkedResponseList> originalUnlinkedList = [];
  ValueNotifier<List<UnlinkedResponseList>> unlinkedResponseList =
      ValueNotifier([]);
  ValueNotifier<List<UnlinkedResponseList>> unlinkedResponseList1 =
      ValueNotifier([]);
  final control = Get.put(Controller());

  // List<double> extraHrs = [];
  // List<String> remarksTime = [];
  // List<String> remarkspenalty = [];
  List<ValueNotifier<bool>> savedSuccess = [];

  List<TextEditingController> extraHrsTextController = [];
  List<TextEditingController> remarkHrsTextController = [];
  List<TextEditingController> remarkPenaltyTextController = [];
  int currentPage = 1;
  RxInt currentPagination = 1.obs;
  String searchValue = "";

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    fetchUnlinkedList();
  }

  int pageSize = int.parse(selectedDropdownValue);
  List<UnlinkedResponseList> getCurrentPageItems(
      List<UnlinkedResponseList> items, int currentPage) {
    unlinkedResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<UnlinkedResponseList> a = items.sublist(startIndex, endIndex);

    remarkPenaltyTextController.clear();
    savedSuccess.clear();
    extraHrsTextController.clear();
    remarkHrsTextController.clear();
    if (extraHrsTextController.isEmpty) {
      for (var element in items) {
        extraHrsTextController.add(TextEditingController(
            text: element.extraHours == null
                ? ""
                : element.extraHours.toString()));
        remarkHrsTextController.add(
            TextEditingController(text: element.remarksForExtraTime ?? ""));
        remarkPenaltyTextController.add(
            TextEditingController(text: element.remarksPenalityWaiveOff ?? ""));
        savedSuccess.add(ValueNotifier((element.extraHours == null) ||
            (element.remarksForExtraTime == null) ||
            (element.remarksPenalityWaiveOff == null)));
      }
    }
    return a;
  }

  fetchUnlinkedList() async {
    final UnlinkedDeliveryModel response = await UnlinkedDeliveriesApi()
        .getUnlinkedDeliveries(plantId: sp?.getInt("plantId").toString() ?? "");

    extraHrsTextController.clear();
    remarkHrsTextController.clear();
    remarkPenaltyTextController.clear();

    originalUnlinkedList = response.responseList ?? [];
    unlinkedResponseList1.value =
        getCurrentPageItems(List.from(originalUnlinkedList), currentPage);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      unlinkedResponseList1.value =
          getCurrentPageItems(List.from(originalUnlinkedList), currentPage);
      return;
    }

    List<UnlinkedResponseList> filteredData = originalUnlinkedList
        .where((value) =>
            value.customerName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diQty
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.shipToCityName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.frtAmount
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.transporterName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    unlinkedResponseList1.value = filteredData;
  }

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

  Future<dynamic> saveUnlinkedDelivery(
      {
      // int? index,
      String? diNumber,
      String? extraHours,
      String? extraHoursRemarks,
      String? penalityWaiveRemarks}) async {
    String url = "$baseUrl/bidding/extenRebidHours";

    try {

      String? token = await secureStorage.read("token");
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "diNumber": diNumber ?? "",
            "extraHours": extraHours ?? "",
            "extraHoursRemarks": extraHoursRemarks ?? "",
            "penalityWaiveRemarks": penalityWaiveRemarks ?? ""
          }));
      final result = jsonDecode(res.body);

      if (res.statusCode == 200) {
        showResultDialog(result["responseMessage"]);
        // savedSuccess[index].value = true;
      } else {
        // savedSuccess[index].value = false;
        showResultDialog(result["responseMessage"]);
      }
    } catch (e) {
      // savedSuccess[index].value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 10)) / 100;
    return CustomScaffold(
      appBarText: 'Unlinked Deliveries > Start Bid > Unlinked Deliveries',
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await fetchUnlinkedList();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Unlinked Deliveries ${sp?.getString("plantName")} & ${sp?.getString("division1")}",
                style: const TextStyle(
                    fontSize: 21,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100),
              ),
              vSpace(10),
              tableHeading(heading: "Unlinked Deliveries"),
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
                                          await fetchUnlinkedList();
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
                              width: 110,
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
                                      const EdgeInsets.symmetric(horizontal: 5),
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
                valueListenable: unlinkedResponseList1,
                builder: (BuildContext context, List<UnlinkedResponseList> data,
                    Widget? child) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Text("No data found"),
                      ),
                    );
                  }
                  return CustomTable(
                    columns: [
                      const DataColumn(
                        label: TableColumn(
                          "Sr.No",
                          heading: true,
                          width: 55,
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
                          "Name Of Customer",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "Ship to City",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "DI Qty",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "Frt. Amt",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "Transporter Name",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "Di Status",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "Extra Hrs.",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "Remarks for Extra Time",
                          heading: true,
                          width: dynamicSize,
                        ),
                      ),
                      DataColumn(
                        label: TableColumn(
                          "Remarks Penality Waive Off",
                          heading: true,
                          width: dynamicSize,
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
                      (index) => DataRow(
                        cells: [
                          DataCell(
                            TableColumn(
                              "${index + 1}",
                              index: index,
                            ),
                          ),
                          DataCell(
                            TableColumn(
                              data[index].diNumber ?? "",
                              index: index,
                            ),
                          ),
                          DataCell(
                            TableColumn(
                              data[index].customerName ?? "",
                              index: index,
                            ),
                          ),
                          DataCell(
                            TableColumn(
                              data[index].cityName ?? "",
                              index: index,
                            ),
                          ),
                          DataCell(
                            TableColumn(
                              data[index].diQty.toString(),
                              index: index,
                            ),
                          ),
                          DataCell(
                            TableColumn(
                              data[index].frtAmount.toString(),
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
                              data[index].diStatus ?? "",
                              index: index,
                            ),
                          ),
                          DataCell(
                            Visibility(
                              visible: data[index].diStatus != "MANUAL",
                              child: TableColumnTextField(
                                controller: extraHrsTextController[index],
                                enabled: extraHrsTextController[index]
                                    .value
                                    .text
                                    .isBlank ,
                                index: index,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          DataCell(
                            Visibility(
                              visible:  data[index].diStatus != "MANUAL",
                              child: TableColumnTextField(
                                controller: remarkHrsTextController[index],
                                enabled: remarkHrsTextController[index]
                                    .value
                                    .text
                                    .isBlank,
                                index: index,
                              ),
                            ),
                          ),
                          DataCell(
                            Visibility(
                            visible:   data[index].diStatus != "MANUAL",
                              child: TableColumnTextField(
                                controller: remarkPenaltyTextController[index],
                                enabled: remarkPenaltyTextController[index]
                                    .value
                                    .text
                                    .isBlank,
                                index: index,
                              ),
                            ),
                          ),
                          DataCell(
                            ValueListenableBuilder(
                              valueListenable: savedSuccess[index],
                              builder: (BuildContext context, bool value,
                                  Widget? child) {
                                return TableColumnActionIcon(
                                    index: index,
                                    icon: 
                                     data[index].diStatus == "MANUAL" ?
                                       const Icon(
                                      Icons.save,
                                      color: Colors.grey,
                                      size: 21,
                                    )
                                   :  Icon(
                                      value ? Icons.save : Icons.done,
                                      color: Colors.green,
                                      size: 21,
                                    ),
                                    onPressed: data[index].diStatus == "MANUAL" ?null: () async {
                                      // Get the values from the controllers

                                      String extraHrs =
                                          extraHrsTextController[index]
                                              .value
                                              .text;
                                      String remarksExtrahrs =
                                          remarkHrsTextController[index]
                                              .value
                                              .text;
                                      String remarksPenalty =
                                          remarkPenaltyTextController[index]
                                              .value
                                              .text;

                                      // Check for empty or null values
                                      if (((extraHrs.isNotEmpty) &&
                                              (remarksExtrahrs.isNotEmpty)) &&
                                          (remarksPenalty.isNotEmpty)) {
                                        try {
                                          await saveUnlinkedDelivery(
                                              diNumber: data[index].diNumber,
                                              extraHours:
                                                  extraHrsTextController[index]
                                                      .text,
                                              extraHoursRemarks:
                                                  remarkHrsTextController[index]
                                                      .text,
                                              penalityWaiveRemarks:
                                                  remarkPenaltyTextController[
                                                          index]
                                                      .text);

                                          setState(() {});
                                          await fetchUnlinkedList();
                                          //     // Update the UI by fetching the latest data
                                          //     setState(() async {
                                          //       costToTransportTextController = [];
                                          //       frtChangeReasonTextController = [];
                                          //       reasonDiAllotmentTextController = [];
                                          //       await fetchPreBidList();
                                          //     });
                                        } catch (e) {
                                        }
                                        // Show a dialog if any field is empty
                                      } else {
                                        // All fields are valid, proceed with the update

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                  'Please fill the fields.'),
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
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              vSpace(15),
              Container(
                  color: Colors.grey.shade200,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: unlinkedResponseList,
                            builder: (BuildContext context,
                                List<UnlinkedResponseList> value,
                                Widget? child) {
                              return Expanded(
                                flex: 2,
                                child: Text(
                                    "Showing 1 to ${unlinkedResponseList1.value.length} of ${unlinkedResponseList.value.length} entries",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                              );
                            },
                          ),
                          buildValueListenableBuilder()
                        ],
                      ),
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<List<UnlinkedResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: unlinkedResponseList,
      builder: (BuildContext context, List<UnlinkedResponseList> value,
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

          return Wrap(
            children: pageWidgets,
          );
        });
      },
    );
  }
}
