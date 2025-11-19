// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/common/controller/numeric.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_2.dart';
import 'package:shreecement/features/common/widgets/snackbar.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import 'package:shreecement/features/preBidding/apiModels/di_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../common/controller/controller.dart';
import '../common/screens/token_expire.dart';
import '../common/table/table_widgets.dart';
import '../common/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;

class StartBidFig extends StatefulWidget {
  const StartBidFig({super.key});

  @override
  State<StartBidFig> createState() => _StartBidFigState();
}

class _StartBidFigState extends State<StartBidFig> {
  final control = Get.put(Controller());
  RxBool isLoading = false.obs;


  ValueNotifier<String> selectedDivision =
      ValueNotifier(sp?.getString("selectedDivisionStartBid") ?? "");
  // String? divisionitem;
  // String? diType;
  NumericTextEditingController startTime = NumericTextEditingController();
  NumericTextEditingController rebidTime = NumericTextEditingController();

  Future<DiList> getDitypeList() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/diType-list";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    // if (res.statusCode == 200) {
    final result = json.decode(res.body);
    // // print(result);
    // // print(res.body);

    return DiList.fromJson(result);
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

// calling api
  Future<dynamic> startManualBid({
    required String? division,
    required String? diType,
    required String? startTime,
    required String? reShedulerInHours,
  }) async {
    // // print("bidding started");
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/scheduler/startManualBid";

    try {
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "plantId": sp?.getInt("plantId"),
            "plantName": sp?.getString("plantName").toString(),
            "division": division,
            "diType": diType,
            "biddinTimeInMinutes": startTime,
            "repeatCount": 2,
            "reShedulerInHours": reShedulerInHours,
            "username": (sp?.getString("email")).toString()
          }));
      final parsedJson = jsonDecode(res.body);
      final result = jsonDecode(res.body);
      // // print("result $result");
      await showResultDialog(parsedJson['responseMessage'].toString());
      sp?.setString(
          "timerValue", parsedJson["serviceDTO"]["bidStartTime"].toString());
      return result;
    } catch (e) {
      // // print("error in start bid $e");
    }

    return ();
  }

  late DateTime scheduledTime;
  late int countdownEndTime;
  bool bidStarted = false;
  ValueNotifier<String> selectedDitype =
      ValueNotifier(sp?.getString("diType") ?? "");

  String? timerValue;



  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    timerValue = sp?.getString("timerValue");
    // try {
    //   if (timerValue != null) {
    //     scheduledTime = DateTime.parse(timerValue!);
    //     countdownEndTime = scheduledTime.millisecondsSinceEpoch;
    //     startCountdown();
    //   }
    // } catch (e) {
    //   // // print("error in time $e");
    // }
    if (sp!.containsKey("timeForBiddingInMinutes")) {
      String? a = sp!.getString("timeForBiddingInMinutes");

      startTime = NumericTextEditingController(text: int.parse(a!));
    }
    String? b = sp?.getString("manualReBidTime");
    rebidTime = NumericTextEditingController(text: int.parse(b!));
  }

  // void startCountdown() {
  //   Duration remainingTime = scheduledTime.difference(DateTime.now());

  //   if (remainingTime.isNegative) {
  //     // // print("Scheduled time is in the past");
  //   } else {
  //     CountdownTimer(
  //       endTime: countdownEndTime,
  //       onEnd: () {
  //         // Handle when the countdown reaches 0
  //       },
  //       widgetBuilder: (_, CurrentRemainingTime? time) {
  //         if (time == null) {
  //           return const Text("00:00");
  //         }

  //         String minutes = time.min.toString().padLeft(2, '0');
  //         String seconds = time.sec.toString().padLeft(2, '0');
  //         // String milliseconds = (time.millis! % 1000 ~/ 10).toString().padLeft(2, '0');

  //         return Text("$minutes:$seconds");
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarText: "Start New Bid",
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start New Bid  ${sp?.getString("plantName")} &  ${sp?.getString("division1")}',
                    style: const TextStyle(
                      fontSize: 21,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  vSpace(20),
                  Container(
                    width: double.infinity, // Set the desired width
                    color: const Color(0xFFFFAF3F),
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      'Warning! Please don’t cancel running bid. If you cancel, then you are responsible for any issue. Please contact ERP department before cancellation.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Start New Bid"),
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
                          const Text(
                            'Plant Name',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                            ),
                          ),
                          vSpace(2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${sp?.getString("plantName")}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                              ),

                              Builder(
                                builder: (context) {
                                  try {
                                    DateFormat("yyyy-MM-dd HH:mm:ss")
                                        .parse(timerValue!);
                                    return Column(
                                      children: [
                                        const Text("Remanining Time"),
                                        CountdownTimer(
                                          endTime: DateFormat("yyyy-MM-dd HH:mm:ss")
                                              .parse(timerValue!)
                                              .millisecondsSinceEpoch,
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          onEnd: () {
                                            try {
                                              setState(() {
                                                bidStarted = true;
                                              });
                                            } catch (e) {
                                              // // print("error in setstate $e");
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  } catch (e) {
                                    return Container();
                                  }
                                },
                              ),
                              //timer need to show here
                            ],
                          ),
                          vSpace(10),
                          Wrap(
                            runSpacing: 5,
                            children: [
                              FutureBuilder(
                                future: DivisionListApi().getDivisionListFromAPI(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: ColorConstant.redbar,
                                    );
                                  } else if (snapshot.hasData) {
                                    int i;
                                    List<String> division = [];
                                    for (i = 0;
                                        i < snapshot.data!.divisionlist!.length;
                                        i++) {
                                      division.add(snapshot.data!.divisionlist![i]
                                          .toString());
                                    }

                                    // selectedDivision.value = division.first;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Division",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: selectedDivision,
                                          builder: (BuildContext context,
                                              String data, Widget? child) {
                                            return CustomDropdownMenu2(
                                              selVal: data,
                                              list: division,
                                              fun: (value) {
                                                selectedDivision.value =
                                                    value ?? "";
                                              },
                                            );
                                          },
                                        ),
                                      ],
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
                                },
                              ),
                              wSpace(20),
                              FutureBuilder(
                                future: getDitypeList(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: ColorConstant.redbar,
                                    );
                                  } else if (snapshot.hasData) {
                                    int i;
                                    List<String> diList = [
                                      "All"
                                    ]; // Initialize with "All"

                                    for (i = 0;
                                        i < snapshot.data!.diTypeList!.length;
                                        i++) {
                                      diList.add(
                                          snapshot.data!.diTypeList![i].toString());
                                    }

                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "DI Type",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: selectedDitype,
                                          builder: (BuildContext context,
                                              String data, Widget? child) {
                                            return CustomDropdownMenu2(
                                              selVal: data,
                                              list: diList,
                                              fun: (value) {
                                                selectedDitype.value = value ?? "";
                                              },
                                            );
                                          },
                                        ),
                                      ],
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
                                },
                              ),
                              wSpace(20),
                              customTextField(
                                  controller: startTime,
                                  label: "Time for Bidding (in Mins.)"),
                              wSpace(20),
                              customTextField(
                                disabled: sp!.containsKey("manualReBidTime")
                                    ? true
                                    : false,
                                controller: rebidTime,
                                label: "Re-Bid Time (in Hours)",
                              )
                            ],
                          ),
                          vSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: sp?.getString("bidStatus") !=
                                    "MANUAL_SCHEDULED",
                                child: button(
                                    btnText: "Start Bid",
                                    tapFunction: () async {
                                      isLoading.value=true;

                                      if (startTime.value.text == "" ||
                                          rebidTime.value.text == "") {
                                        buildSnackBar("Invalid Input",
                                            "Please fill all fields");
                                        return;
                                      }
                                      try {
                                        var result = await startManualBid(
                                          division: selectedDivision.value,
                                          diType: selectedDitype.value,
                                          startTime: startTime.value.text,
                                          reShedulerInHours: rebidTime.value.text,
                                        );
                                        sp?.setString("timeForBiddingInMinutes",
                                            startTime.value.text);
                                        sp?.setString("reBidTimeInHours",
                                            rebidTime.value.text);
                                        if (result['responseCode'] == "200 OK") {
                                          control.currentIndex.value = 10;
                                        }
                                        isLoading.value=false;
                                      } catch (e) {
                                        // showResultDialog("$e");
                                        isLoading.value=false;
                                      }
                                    }),
                              ),
                              wSpace(10),
                              (sp?.getString("bidStatus") == "MANUAL_SCHEDULED")
                                  ? button(
                                      btnText: "Cancel Running Bid",
                                      btnClr: Colors.white,
                                      btnTxtClr: ColorConstant.redbar,
                                      tapFunction: () {
                                        control.currentIndex.value = 7;
                                      },
                                    )
                                  : button(
                                      btnText: "Cancel Running Bid",
                                      btnClr: Colors.white,
                                      btnTxtClr: ColorConstant.redbar,
                                      tapFunction: null,
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  vSpace(20),
                ],
              ),
            ),
          ),
          Obx(() => Visibility(
            visible: isLoading.value,
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
}

Widget customTextField(
    {String? label,
    TextEditingController? controller,
    bool disabled = false,
    String? hint,
    double? width,
    Color? color,
    bool isConst = false,
    bool changeColor = false,
    void Function(String)? onChanged}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label!,
        style: TextStyle(color: changeColor ? color : Colors.black),
      ),
      Container(
        height: 30,
        width: width ?? 283,
        color: isConst ? const Color(0xFFE2E2E2) : Colors.white,
        child: TextField(
          readOnly: disabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF727272),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            filled: true,
            fillColor: isConst ? const Color(0xFFE2E2E2) : Colors.white,
          ),
          textAlign: TextAlign.left,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              textBaseline: TextBaseline.alphabetic,
              fontWeight: FontWeight.w100),
        ),
      ),
    ],
  );
}

Widget disabledCustomTextField(
    {String? label,
      TextEditingController? controller,
      bool disabled = true,
      String? hint,
      double? width,
      Color? color,
      bool isConst = false,
      bool changeColor = false,
      void Function(String)? onChanged}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label!,
        style: TextStyle(color: changeColor ? color : Colors.black),
      ),
      Container(
        height: 30,
        width: width ?? 283,
        // color: isConst ? const Color(0xFFE2E2E2) : Colors.white,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E2E2), // Grey background
          borderRadius: BorderRadius.circular(5), // Optional rounded corners
        ),
        child: TextField(
          enabled: false,
          readOnly: disabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF727272),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            // filled: true,
            // fillColor: isConst ? const Color(0xFFE2E2E2) : Colors.white,
            filled: true,
            fillColor: Color(0xFFE2E2E2), // Ensures grey background
          ),
          textAlign: TextAlign.left,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              textBaseline: TextBaseline.alphabetic,
              fontWeight: FontWeight.w100),
        ),
      ),
    ],
  );
}

//this custom textField is input formatter only allow of alphabetic input
Widget customTextField3(
    {String? label,
      TextEditingController? controller,
      bool disabled = false,
      String? hint,
      double? width,
      Color? color,
      bool isConst = false,
      bool changeColor = false,
      void Function(String)? onChanged}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label!,
        style: TextStyle(color: changeColor ? color : Colors.black),
      ),
      Container(
        height: 30,
        width: width ?? 283,
        color: isConst ? const Color(0xFFE2E2E2) : Colors.white,
        child: TextField(
          readOnly: disabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF727272),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            filled: true,
            fillColor: isConst ? const Color(0xFFE2E2E2) : Colors.white,
          ),
          textAlign: TextAlign.left,
          // keyboardType: TextInputType.name,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$'))], // Allows only alphabets and spaces
          style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              textBaseline: TextBaseline.alphabetic,
              fontWeight: FontWeight.w100),
        ),
      ),
    ],
  );
}

Widget customTextField2({
  String? label,
  TextEditingController? controller,
  bool disabled = false,
  String? hint,
  double? width,
  Color? color,
  bool isConst = false,
  bool changeColor = false,
  int maxLines = 5, // Adjust the number of lines here
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label!,
        style: TextStyle(color: changeColor ? color : Colors.black),
      ),
      Container(
        width: width ?? 283,
        color: isConst ? const Color(0xFFE2E2E2) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            readOnly: disabled,
            controller: controller,
            maxLines: maxLines, // Set maxLines to make it a textarea

            textAlign: TextAlign.left,
            textAlignVertical:
                TextAlignVertical.center, // Set textAlignVertical
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              textBaseline: TextBaseline.alphabetic,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    ],
  );
}
