import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/controller/mobile_number.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/tokenMapping/api/token_mapping_apis.dart';
import 'package:shreecement/features/tokenMapping/models/token_didetails.dart';
import 'package:shreecement/features/tokenMapping/models/token_list.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_link_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../common/controller/controller.dart';
import '../../common/controller/limitedtextcontroller.dart';
import '../../common/widgets/custom_dropdown_3.dart';

class TokenMappingLinkingLogistic extends StatefulWidget {
  const TokenMappingLinkingLogistic({super.key});

  @override
  State<TokenMappingLinkingLogistic> createState() => _TokenMappingLinkingLogisticState();
}

class _TokenMappingLinkingLogisticState extends State<TokenMappingLinkingLogistic> {
  final control = Get.put(Controller());
  ValueNotifier switchState = ValueNotifier(true);

  ValueNotifier<TokenMappingLinkListModel> tokenLinkResponseList =
  ValueNotifier(TokenMappingLinkListModel());

  ValueNotifier<MapEntry<String, String>> selectedToken =
  ValueNotifier(const MapEntry("", ""));

  ValueNotifier enabled = ValueNotifier(false);

  ValueNotifier<TokenDetailsResponseList> tokenDiResponseList =
  ValueNotifier(TokenDetailsResponseList());

  TextEditingController ownerName = TextEditingController();
  TextEditingController driverName = TextEditingController();
  LimitedLengthTextController licenceNo = LimitedLengthTextController();
  MobileTextEditingController transporterMobileNumber =
  MobileTextEditingController();
  MobileTextEditingController driverMobileNumber =
  MobileTextEditingController();

  // TextEditingController ownerName=TextEditingController();

  String tokenNumber = '';
  String diNumber = '';

  RxBool loadingButton = false.obs;

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    fetchTokenLinkData();
  }

  fetchTokenLinkData() async {
    tokenLinkResponseList.value = await TokenMappingApi()
        .getTokenMapingLinkingFirst(diNumber: sp?.getString("diNumber"));
  }

  fetchTokenDiDetails(String tokenNumber) async {
    try {
      tokenDiResponseList.value =
      await TokenMappingApi().getTokenDiDetails(tokenNumber: tokenNumber);
    } catch (e) {
      // print("errorin tokenresponselist $e");
    }
  }

  Future<void> showResultDialog(String message, BuildContext context) async {
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

  String convertDateFormat(String inputString) {
    String formattedString = '';
    try {
      DateTime dateTime = DateTime.parse(inputString);

      formattedString = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
    } catch (e) {
      // print("error formating time $e");
    }

    return formattedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Mapping'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tableHeading(heading: "Direct DI Allotment Form"),
              Container(
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffE2E2E2),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Plant Name",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        const Text(
                          "FGB: Finished Goods Cement BWR",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        vSpace(10),
                        Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ValueListenableBuilder(
                                valueListenable: tokenLinkResponseList,
                                builder: (BuildContext context,
                                    TokenMappingLinkListModel value,
                                    Widget? child) {
                                  diNumber = value.diNumber ?? "";

                                  return Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          runSpacing: 10,
                                          spacing: 20,
                                          children: [
                                            labelledDisabledText1(
                                                hgt: 30,
                                                label: "DI Number",
                                                text: value.diNumber ?? ""),
                                            labelledDisabledText1(
                                                label: "DI Quantity",
                                                hgt: 30,
                                                text: value.diQty.toString()),
                                            labelledDisabledText1(
                                                label: "Unit of Measure",
                                                hgt: 30,
                                                text: value.diUom ?? ""),
                                            labelledDisabledText1(
                                                label: "Freight Type",
                                                hgt: 30,
                                                text: value.frtTerms ?? ""),
                                            labelledDisabledText1(
                                                label: "Sales Order Number",
                                                hgt: 30,
                                                text: value.salesOrderNo ?? ""),
                                            labelledDisabledText1(
                                                label: "Consignee",
                                                hgt: 30,
                                                text: value.customerName ?? ""),
                                            labelledDisabledText1(
                                                label: "Consignee Address",
                                                hgt: 30,
                                                text: value.consigneeAddress ??
                                                    ""),
                                            labelledDisabledText1(
                                                label: "Cost Of Transportation",
                                                hgt: 30,
                                                text: value.winFrtAmount
                                                    .toString()),
                                            labelledDisabledText1(
                                                label: "Ship To City",
                                                hgt: 30,
                                                text:
                                                value.shipToCityName ?? ""),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 4),
                                              child: FutureBuilder(
                                                future: TokenMappingApi()
                                                    .getTokenNumberList(
                                                    transporterId:
                                                    // "13000001"
                                                    sp?.getString(
                                                        "transporterCode") ??
                                                        "",
                                                    context: context),
                                                builder:
                                                    (stateIndex, snapshot) {
                                                  if (snapshot
                                                      .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                      CircularProgressIndicator(
                                                        color: ColorConstant
                                                            .redbar,
                                                      ),
                                                    );
                                                  } else if (snapshot.hasData) {
                                                    final List<ResponseList>?
                                                    responseList = snapshot
                                                        .data?.responseList;

                                                    if (responseList == null ||
                                                        responseList.isEmpty ||
                                                        responseList == []) {
                                                      // If the response list is empty, show a message
                                                      return Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Text(
                                                            "Token Number",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            width: 283,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                            BoxDecoration(
                                                              color:
                                                              Colors.white,
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xffA0A0A0)),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  5.0),
                                                            ),
                                                            child: const Text(
                                                              "No Tokens Available",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff727272),
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontFamily:
                                                                  'Roboto'),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }

                                                    Map<String, String> map =
                                                    {};
                                                    map["Select a Token Number"] =
                                                    "Select a Token Number";

                                                    if (responseList
                                                        .isNotEmpty) {
                                                      for (var element
                                                      in responseList) {
                                                        map["${element.tokenNumber!}-${element.truckNumber}"] =
                                                        "${element.truckNumber!}-${element.truckNumber}";
                                                        tokenNumber = element
                                                            .tokenNumber ??
                                                            "";
                                                      }

                                                      selectedToken.value =
                                                          map.entries.first;
                                                      if (selectedToken
                                                          .value.value ==
                                                          "Select a Token Number") {
                                                      } else {
                                                        fetchTokenDiDetails(
                                                            tokenNumber);

                                                        tokenNumber =
                                                            selectedToken
                                                                .value.key;
                                                      }

                                                      // TokenMappingApi()
                                                      //     .getTokendidetails(
                                                      //         tokenNumber:
                                                      //             selectedToken
                                                      //                 .value.key);
                                                    }

                                                    return ValueListenableBuilder(
                                                      valueListenable:
                                                      selectedToken,
                                                      builder:
                                                          (BuildContext context,
                                                          data,
                                                          Widget? child) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Token Number",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            CustomDropdownMenu3(
                                                              selVal:
                                                              selectedToken
                                                                  .value
                                                                  .key,
                                                              list: map.keys
                                                                  .toList(),
                                                              fun: (value) {
                                                                if (value ==
                                                                    "Select a Token Number") {
                                                                  enabled.value =
                                                                  false;
                                                                  setState(
                                                                          () {});
                                                                  tokenDiResponseList
                                                                      .value =
                                                                      TokenDetailsResponseList();
                                                                } else {
                                                                  enabled.value =
                                                                  true;
                                                                }
                                                                String?
                                                                firstValue;
                                                                String
                                                                inputString =
                                                                    value ??
                                                                        '0-0';

                                                                List<String>
                                                                parts =
                                                                inputString
                                                                    .split(
                                                                    '-');

                                                                if (parts
                                                                    .isNotEmpty) {
                                                                  firstValue =
                                                                      parts
                                                                          .first;
                                                                  // print(
                                                                  //     "First Value: $firstValue");
                                                                }

                                                                // TokenMappingApi()
                                                                //     .getTokendidetails(
                                                                //         tokenNumber:
                                                                //             value ??
                                                                //                 "");
                                                                fetchTokenDiDetails(
                                                                    firstValue ??
                                                                        "");
                                                                selectedToken
                                                                    .value =
                                                                    MapEntry(
                                                                      value ?? "",
                                                                      map[value] ??
                                                                          "",
                                                                    );
                                                                tokenNumber =
                                                                    firstValue ??
                                                                        "";
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    return const Text(
                                                        "Something is not right!");
                                                  }
                                                },
                                              ),
                                            ),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  transporterMobileNumber
                                                      .value =
                                                      TextEditingValue(
                                                          text:
                                                          data.transporterMobileNumber ??
                                                              "");

                                                  // licenceNo=TextEditingController(text: data.)

                                                  return Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 4),
                                                      child: customTextField(
                                                          label:
                                                          "Trans. Mob. No. For SMS",
                                                          changeColor: true,
                                                          color: const Color(
                                                              0xFF606060),
                                                          controller:
                                                          transporterMobileNumber,
                                                          hint:
                                                          data.transporterMobileNumber ??
                                                              "")
                                                    //  labelledEnabledText1(
                                                    //     label: "Trans. Mob. No. For SMS",
                                                    //     hgt: 30,
                                                    //     text:
                                                    //         data.transporterMobileNumber ??
                                                    //             ""),
                                                  );
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  return labelledDisabledText1(
                                                      label: "TR Number",
                                                      hgt: 30,
                                                      text:
                                                      data.trNumber ?? "");
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  return labelledDisabledText1(
                                                      label:
                                                      "Mode Of Transport",
                                                      hgt: 30,
                                                      text: value
                                                          .modeOfTranport ??
                                                          "");
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  return labelledDisabledText1(
                                                      label: "Truck Type",
                                                      hgt: 30,
                                                      text:
                                                      data.truckType ?? "");
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  return labelledDisabledText1(
                                                      label: "Truck Number",
                                                      hgt: 30,
                                                      text: data.truckNumber ??
                                                          "");
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  return labelledDisabledText1(
                                                      label:
                                                      "Actual Vehicle Capacity",
                                                      hgt: 30,
                                                      text: data.actualVehicleCapacity ==
                                                          null
                                                          ? ""
                                                          : data
                                                          .actualVehicleCapacity
                                                          .toString());
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  return labelledDisabledText1(
                                                      label: "Vehicle Model",
                                                      hgt: 30,
                                                      text: data.vehicleModel ==
                                                          null
                                                          ? ""
                                                          : data.vehicleModel
                                                          .toString());
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  ownerName.value =
                                                      TextEditingValue(
                                                          text:
                                                          data.ownerName ??
                                                              "");
                                                  return Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 5),
                                                    child: customTextField(
                                                      label: "Owner Name",
                                                      changeColor: true,
                                                      color: const Color(
                                                          0xFF606060),
                                                      controller: ownerName,
                                                    ),
                                                  );
                                                }),
                                            labelledDisabledText1(
                                                label: "Product",
                                                hgt: 30,
                                                text: sp!.getString(
                                                    "productName") ??
                                                    ""),
                                            labelledDisabledText1(
                                                label: "Packaging Type",
                                                hgt: 30,
                                                text:
                                                value.materialFrtGrpName ??
                                                    ""),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  driverName.value =
                                                      TextEditingValue(
                                                          text:
                                                          data.driverName ??
                                                              "");
                                                  return customTextField(
                                                    label: "Driver Name",
                                                    changeColor: true,
                                                    color:
                                                    const Color(0xFF606060),
                                                    controller: driverName,
                                                  );
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  driverMobileNumber.value =
                                                      TextEditingValue(
                                                          text:
                                                          data.driverMobileNumber ??
                                                              "");
                                                  return customTextField(
                                                    label:
                                                    "Driver Mob. No. For SMS",
                                                    changeColor: true,
                                                    color:
                                                    const Color(0xFF606060),
                                                    controller:
                                                    driverMobileNumber,
                                                  );
                                                }),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child:
                                                    ValueListenableBuilder(
                                                      valueListenable:
                                                      switchState,
                                                      builder:
                                                          (BuildContext context,
                                                          value,
                                                          Widget? child) {
                                                        return Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 5),
                                                          child:
                                                          labelledSwitch2(
                                                            label:
                                                            "Smart Phone",
                                                            function: (value) {
                                                              switchState
                                                                  .value =
                                                                  value;
                                                            },
                                                            switchStatus: value,
                                                          ),
                                                        );
                                                      },
                                                    )),
                                              ],
                                            ),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  licenceNo.value =
                                                      TextEditingValue(
                                                          text:
                                                          data.licenceNo ??
                                                              "");
                                                  return customTextField(
                                                    label: "License No.",
                                                    changeColor: true,
                                                    color:
                                                    const Color(0xFF606060),
                                                    controller: licenceNo,
                                                  );
                                                }),
                                            ValueListenableBuilder(
                                                valueListenable:
                                                tokenDiResponseList,
                                                builder: (BuildContext context,
                                                    TokenDetailsResponseList
                                                    data,
                                                    Widget? child) {
                                                  return labelledDisabledText1(
                                                      label:
                                                      "Factory Gate In Time",
                                                      hgt: 30,
                                                      text: convertDateFormat(
                                                          data.factoryGateInTime ??
                                                              "")
                                                    // data.factoryGateInTime ??
                                                    //     ""
                                                  );
                                                }),
                                            Row(
                                              children: [
                                                Wrap(
                                                  spacing: 20,
                                                  runSpacing: 10,
                                                  children: [
                                                    Obx(
                                                          () => loadingButton.value
                                                          ? SizedBox(
                                                        width: 100,
                                                        child:
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                            ColorConstant
                                                                .redbar,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                              // Adjust the value as needed
                                                            ),
                                                          ),
                                                          child:
                                                          const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                            CircularProgressIndicator(
                                                              color: Colors
                                                                  .white,
                                                              strokeWidth:
                                                              3,
                                                            ),
                                                          ),
                                                          onPressed:
                                                              () {},
                                                        ),
                                                      )
                                                          : SizedBox(
                                                        width: 100,
                                                        child: button(
                                                            btnText:
                                                            "Submit",
                                                            tapFunction:
                                                                () async {
                                                              if (driverMobileNumber.value.text.isEmpty ||
                                                                  driverName
                                                                      .value
                                                                      .text
                                                                      .isEmpty ||
                                                                  licenceNo
                                                                      .value
                                                                      .text
                                                                      .isEmpty ||
                                                                  ownerName
                                                                      .value
                                                                      .text
                                                                      .isEmpty ||
                                                                  transporterMobileNumber
                                                                      .value
                                                                      .text
                                                                      .isEmpty) {
                                                                showDialog(
                                                                  context:
                                                                  context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                      const Text('Message'),
                                                                      content:
                                                                      const Text('Please fill the fields.'),
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
                                                                return;
                                                              }
                                                              if (driverMobileNumber.value.text.trim().length !=
                                                                  10 ||
                                                                  transporterMobileNumber.value.text.trim().length !=
                                                                      10) {
                                                                showDialog(
                                                                  context:
                                                                  context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                      const Text('Message'),
                                                                      content:
                                                                      const Text('Mobile No. is invalid'),
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
                                                                return;
                                                              }
                                                              try {
                                                                loadingButton
                                                                    .value =
                                                                true;

                                                                await TokenMappingApi().submitTokenForm(
                                                                    transporterId: sp?.getString("transporterCode") ?? ""
                                                                        "",
                                                                    tokenNumber:
                                                                    tokenNumber,
                                                                    diNumber: value.diNumber ??
                                                                        "",
                                                                    driverName: driverName
                                                                        .value
                                                                        .text
                                                                        .toString(),
                                                                    licenceNo: licenceNo
                                                                        .value
                                                                        .text
                                                                        .toString(),
                                                                    ownerName: ownerName
                                                                        .value
                                                                        .text
                                                                        .toString(),
                                                                    transporterMobileNumber: transporterMobileNumber
                                                                        .value
                                                                        .text,
                                                                    driverMobileNumber1: driverMobileNumber
                                                                        .value
                                                                        .text,
                                                                    smartPhone: switchState
                                                                        .value,
                                                                    context:
                                                                    context);
                                                                loadingButton
                                                                    .value =
                                                                false;
                                                                control
                                                                    .currentIndex
                                                                    .value = 34;
                                                              } catch (e) {
                                                                // ignore: use_build_context_synchronously
                                                                // showResultDialog(
                                                                //     "$e", context);
                                                              }
                                                            }),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      child: button(
                                                          btnText: "Reset",
                                                          btnTxtClr:
                                                          ColorConstant
                                                              .redbar,
                                                          btnClr: Colors.white,
                                                          tapFunction: () {
                                                            tokenDiResponseList =
                                                                tokenDiResponseList =
                                                                ValueNotifier(
                                                                    TokenDetailsResponseList());
                                                            setState(() {});
                                                          }),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ]);
                                })),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
