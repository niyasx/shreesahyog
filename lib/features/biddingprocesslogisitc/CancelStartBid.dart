import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/widgets/snackbar.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import 'package:shreecement/features/preBidding/apiModels/di_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../common/controller/controller.dart';
import '../common/screens/token_expire.dart';
import '../common/table/table_widgets.dart';
import '../common/widgets/custom_dropdown_2.dart';
import '../common/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;

class CancelStartBid extends StatefulWidget {
  const CancelStartBid({super.key});

  @override
  State<CancelStartBid> createState() => _CancelStartBidState();
}

class _CancelStartBidState extends State<CancelStartBid> {
  final control = Get.put(Controller());
  String? divisionitem;
  TextEditingController cancelReason = TextEditingController();
  TextEditingController bidStatus = TextEditingController();
  ValueNotifier<String> selectedDitype =
      ValueNotifier(sp?.getString("diType") ?? "");

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

  Future<dynamic> cancelBid(
      {String? division,
      TextEditingController? bidstatus,
      TextEditingController? reason,
      String? diType}) async {
        String? token = await secureStorage.read("token");
    String url = "$baseUrl/scheduler/changeBidStatus";
    var res = await http.post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode({
          "plantId": sp?.getInt("plantId"),
          "plantName": "${sp?.getString("plantName")}",
          "division": "$division",
          "diType": "$diType",
          "bidChangeStatus": "CANCELLED",
          "statusChangeReason": reason!.text,
          "changedBy": (sp?.getString("email")).toString()
        }));

    final parsedJson = jsonDecode(res.body);

    final result = jsonDecode(res.body);

    // // print("result $result");

    await showResultDialog(parsedJson['responseMessage'].toString());

    return (result);
  }

  Future<DiList> getDitypeList() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/diType-list";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = json.decode(res.body);
    return DiList.fromJson(result);
  }

  late DateTime scheduledTime;
  late int countdownEndTime;
  bool bidStarted = false;

  String? timerValue;

  @override
  void initState() {
    super.initState();
    timerValue = sp?.getString("timerValue");
    try {
      if (timerValue != null) {
        scheduledTime = DateTime.parse(timerValue!);
        countdownEndTime = scheduledTime.millisecondsSinceEpoch;
        startCountdown();
      }
    } catch (e) {
      // // print("error in time $e");
    }
  }

  void startCountdown() {
    Duration remainingTime = scheduledTime.difference(DateTime.now());

    if (remainingTime.isNegative) {
      // // print("Scheduled time is in the past");
    } else {
      CountdownTimer(
        endTime: countdownEndTime,
        onEnd: () {},
        widgetBuilder: (_, CurrentRemainingTime? time) {
          if (time == null) {
            return const Text("00:00");
          }
          String minutes = time.min.toString().padLeft(2, '0');
          String seconds = time.sec.toString().padLeft(2, '0');
          return Text("$minutes:$seconds");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarText: "Cancel Bid",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cancel Bid ${sp?.getString("plantName")} &  ${sp?.getString("division1")}',
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
              tableHeading(heading: "Cancel Bid"),
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
                            '${sp?.getString("plantName")}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                            ),
                          ),
                          if (timerValue != null && !bidStarted)
                            Builder(
                              builder: (context) {
                                try {
                                  DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .parse(timerValue!);
                                  return Column(
                                    children: [
                                      const Text("Remanining Time"),
                                      CountdownTimer(
                                        endTime:
                                            DateFormat("yyyy-MM-dd HH:mm:ss")
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
                                // // print("Data received");
                                int i;
                                List<String> division = [];
                                for (i = 0;
                                    i < snapshot.data!.divisionlist!.length;
                                    i++) {
                                  division.add(snapshot.data!.divisionlist![i]
                                      .toString());
                                }
                                divisionitem =
                                    sp?.getString("selectedDivisionStartBid") ??
                                        "";
                                // // print(divisionitem);
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Division",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                114, 114, 114, 1)),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<String>(
                                            value: division.first,
                                            icon: const Icon(Icons
                                                .keyboard_arrow_down_outlined), // Icon aligned at the center right
                                            iconSize: 18,
                                            elevation: 16,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  114, 114, 114, 1),
                                              fontSize: 14,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            onChanged: (val) {
                                              division.first = val!;
                                              divisionitem = val;
                                              // // print(divisionitem);
                                              setState(() {});
                                            },
                                            items: division
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  height: 30,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    value,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                // labelledCustomDD(
                                //   label: "Division",
                                //   selVal: division.first,
                                //   list: division,
                                // );
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
                          labelledDisabledText(
                              enabled: false,
                              hgt: 30,
                              label: "Time for Bidding (in Mins.)",
                              text: sp!.getString("timeForBiddingInMinutes") ??
                                  ""),
                          wSpace(20),
                          labelledDisabledText(
                              enabled: false,
                              hgt: 30,
                              label: "Re-Bid Time (in Hours)",
                              text: sp?.getString("reBidTimeInHours") ?? ""),
                        ],
                      ),
                      vSpace(20),
                      Row(
                        children: [
                          customTextField(
                            width: 240,
                            controller: cancelReason,
                            label: "BId Cancel Reason",
                          ),
                          // wSpace(20),
                          // customTextField(
                          //   controller: bidStatus,
                          //   label: "Bidding Status",
                          // ),
                        ],
                      ),
                      vSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          button(
                              btnText: "Start Bid",
                              tapFunction: null,
                              btnClr: const Color.fromRGBO(114, 114, 114, 1),
                              btnTxtClr: Colors.white),
                          wSpace(10),
                          button(
                            btnText: "Cancel Running Bid",
                            btnClr: Colors.white,
                            btnTxtClr: ColorConstant.redbar,
                            tapFunction: () async {
                              try {
                                if (cancelReason.value.text
                                        .toString()
                                        .compareTo("") ==
                                    0) {
                                  buildSnackBar("Invalid input",
                                      "Please fill all fields");
                                  return;
                                }
                                await cancelBid(
                                    bidstatus: bidStatus,
                                    division: divisionitem,
                                    reason: cancelReason);
                                control.currentIndex.value = 5;
                              } catch (e) {
                                // showResultDialog("$e");
                              }
                            },
                          ),
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
    );
  }
}
