import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_2.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import 'package:shreecement/features/preBidding/apiModels/di_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../common/table/table_widgets.dart';
import '../common/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;

class StartBidTimerScreen extends StatefulWidget {
  const StartBidTimerScreen({super.key});

  @override
  State<StartBidTimerScreen> createState() => _StartBidTimerScreenState();
}

class _StartBidTimerScreenState extends State<StartBidTimerScreen> {
  final control = Get.put(Controller());
  late Future<DiList>? diTypeListFuture;

  late DateTime scheduledTime;
  late int countdownEndTime;
  bool bidStarted = false;
  ValueNotifier<String> selectedDivision =
      ValueNotifier(sp?.getString("selectedDivisionStartBid") ?? "");
  ValueNotifier<String> selectedDitype =
      ValueNotifier(sp?.getString("diType") ?? "");

  String? timerValue;

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    timerValue = sp?.getString("timerValue");
    try {
      if (timerValue != null) {
        scheduledTime = DateTime.parse(timerValue!);
        countdownEndTime = scheduledTime.millisecondsSinceEpoch;
        startCountdown();
      }
    } catch (e) {
      // print("error in time $e");
    }
    diTypeListFuture = getDitypeList();
  }

  void startCountdown() {
    Duration remainingTime = scheduledTime.difference(DateTime.now());

    if (remainingTime.isNegative) {
      // print("Scheduled time is in the past");
    } else {
      CountdownTimer(
        endTime: countdownEndTime,
        onEnd: () {
          // Handle when the countdown reaches 0
        },
        widgetBuilder: (_, CurrentRemainingTime? time) {
          if (time == null) {
            return const Text("00:00");
          }

          String minutes = time.min.toString().padLeft(2, '0');
          String seconds = time.sec.toString().padLeft(2, '0');
          // String milliseconds = (time.millis! % 1000 ~/ 10).toString().padLeft(2, '0');

          return Text("$minutes:$seconds");
        },
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarText: "Start New Bid",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start New Bid ${sp?.getString("plantName")} &  ${sp?.getString("division1")}',
                style: const TextStyle(
                  fontSize: 21,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                ),
              ),
              vSpace(20),
              Container(
                width: double.infinity,
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
                                              // print("error in setstate $e");
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
                          ]),
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

                                selectedDivision.value = division.first;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Division",
                                      style: TextStyle(color: Colors.grey),
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
                                      style: TextStyle(color: Colors.grey),
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
                              text: sp?.getString("timeForBiddingInMinutes") ??
                                  ""),
                          wSpace(20),
                          labelledDisabledText(
                              enabled: false,
                              hgt: 30,
                              label: "Re-Bid Time (in Hours)",
                              text: sp?.getString("manualReBidTime") ?? ""),
                        ],
                      ),
                      vSpace(50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          greyBorderColorButton(
                            btnClr: const Color(0xff727272),
                            btnText: "Start Bid",
                            tapFunction: null,
                          ),
                          wSpace(10),
                          button(
                            btnText: "Cancel Running Bid",
                            btnClr: Colors.white,
                            btnTxtClr: ColorConstant.redbar,
                            tapFunction: () {
                              // Check if the timer has ended before allowing cancellation
                              if (!bidStarted) {
                                control.currentIndex.value = 7;
                              } else {
                                showResultDialog("Cannot Cancel The Bid Now");
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
