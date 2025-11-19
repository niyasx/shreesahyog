import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';

import '../../../global.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;

import '../../../utils/color_constant.dart';
import '../models/profile_model.dart';
import '../models/transporter_dashboard_model.dart';
import '../table/table_widgets.dart';
import '../widgets/custom_dropdown_3.dart';
import 'home_screen.dart';

class DashBoardScreen2 extends StatefulWidget {
  const DashBoardScreen2({super.key});

  @override
  State<DashBoardScreen2> createState() => _DashBoardScreen2State();
}

Future<TransporterDashboard> getDiCount(
    {required String plantCode, required BuildContext ctx}) async {
  if (sp?.getString("employeeCode") != null) {
    final queryParameters = {
      "transporterCode": sp?.getString("employeeCode") ?? "",
      "plantCode": plantCode
    };
    String? token = await secureStorage.read("token");

    final uri =
        Uri.https(domain, "/app/bidding/dashboard/dicount", queryParameters);

    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    if (res.statusCode == 403) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (context) => const TokenExpire()),
        );
      });
    }

    final result = json.decode(res.body);
    // print(result);
    return TransporterDashboard.fromJson(result);
  }
  return TransporterDashboard();
}

class _DashBoardScreen2State extends State<DashBoardScreen2> {
  Future<dynamic> getProfileList() async {
    try {
      if (sp?.getString("employeeCode") != null) {
        final dynamic queryParameters;
        if (sp?.getString("roleName") == "TRANSPORTER_STAFF") {
          queryParameters = {
            "userId": sp?.getString("staffCode") ?? "",
            "role": sp?.getString("roleName") ?? ""
          };
        } else {
          queryParameters = {
            "userId": sp?.getString("employeeCode") ?? "",
            "role": sp?.getString("roleName") ?? ""
          };
        }
        String? token = await secureStorage.read("token");
        final uri = Uri.https(
            domain, "/app/users/getUserPlantMapping", queryParameters);
        var res = await http.get(uri, headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        });

        final result = jsonDecode(res.body);
        // print(result);
        return ProfileModel.fromJson(result);
      }
    } catch (e) {
      // print(e);
    }
  }

  ValueNotifier<MapEntry<String, String>> selectedPlant =
      ValueNotifier(const MapEntry("", ""));

  ValueNotifier<TransporterDashboard> transporterResponse =
      ValueNotifier(TransporterDashboard());

  ValueNotifier enabled = ValueNotifier(false);
  bool showallinit = true;
  @override
  void initState() {
    super.initState();
    // ignore: unused_local_variable

    fetchData();
  }

  TransporterDashboard response = TransporterDashboard();

  fetchData() async {
    try {
      response = await getDiCount(
          plantCode: selectedPlant.value.value.isNotEmpty
              ? selectedPlant.value.value
              : "",
          ctx: context);
      transporterResponse.value = response;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 32,
        backgroundColor: const Color.fromRGBO(211, 216, 239, 1.0),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        actions: const [
          // Row(
          //   children: [
          //     Text(DateFormat('EEE dd-MM-yyyy HH:mm').format(DateTime.now()),
          //         textAlign: TextAlign.right,
          //         style: const TextStyle(
          //           color: Colors.black,
          //           fontSize: 10,
          //           fontFamily: 'Roboto',
          //           fontWeisght: FontWeight.w400,
          //           height: 0,
          //         )),
          //     const SizedBox(
          //       width: 24,
          //     )
          //   ],
          // )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ValueListenableBuilder<TransporterDashboard>(
                valueListenable: transporterResponse,
                builder: (context, value, child) {
                  // var MapdataItems = [
                  //   {"title": "Bids Won", "value": value.automatedBids!+value.manualBids!},
                  //   {"title": "Bids Lost", "value": value.totalBids!-(value.automatedBids!+value.manualBids!)},
                  // ];
                  var MapdataItems = [
                    {
                      "title": "Automated Bids",
                      "value": double.tryParse(
                          (value.automatedBids ?? 0).toString()),
                    },
                    {
                      "title": "Manual Bids",
                      "value":
                          double.tryParse((value.manualBids ?? 0).toString()),
                    },
                  ];

                  // print(value.totalBids.toString());
                  double size = 126;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, top: 24),
                          child: FutureBuilder(
                              future: getProfileList(),
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
                                    map[element.plantName] =
                                        element.plantCode.toString();
                                  }
                                  if (showallinit == true) {
                                    showallinit = false;
                                    selectedPlant.value = map.entries.first;
                                  }

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
                                            "Plant Selected",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          CustomDropdownMenu3(
                                            selVal: selectedPlant.value.key,
                                            list: map.keys.toList(),
                                            fun: (value) async {
                                              if (value == "All") {
                                                enabled.value = false;
                                              } else {
                                                enabled.value = true;
                                              }
                                              selectedPlant.value = MapEntry(
                                                value ?? "",
                                                map[value] ?? "",
                                              );
                                              await fetchData();

                                              // print("selectedPlant.value ${selectedPlant.value.value},selectedPlant.key ${selectedPlant.value.key}");
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return const Text("Something is not right!");
                                }
                              }),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          children: [
                            buildCustomContainerChart(
                                "Total Bids",
                                "#e3fbd4",
                                "#32a628",
                                size,
                                double.parse((value.totalBids ?? 0).toString()),
                                screenSize),
                            buildCustomContainerChart(
                                "Unmapped DI",
                                "#fbebd4",
                                "#fc9c06",
                                size,
                                double.parse(
                                    (value.unmappedDI ?? 0).toString()),
                                screenSize),
                            SingleChildScrollView(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenSize.width > 600 ? 460 : 340,
                                    height: screenSize.width > 600 ? 200 : 170,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                          strokeAlign:
                                              BorderSide.strokeAlignCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: PieChart(
                                        dataMap: Map.fromIterable(
                                          MapdataItems,
                                          key: (item) => item["title"],
                                          value: (item) => item["value"],
                                        ),
                                        chartType: ChartType.disc,
                                        legendOptions: const LegendOptions(
                                          legendPosition: LegendPosition.right,
                                          legendTextStyle:
                                              TextStyle(fontSize: 16),
                                        ),
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        colorList: [
                                          ColorConstant.fromHex("#fbebd4"),
                                          ColorConstant.fromHex("#ff0000")
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: screenSize.width > 600 ? 460 : 340,
                                      height:
                                          screenSize.width > 600 ? 200 : 170,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Center(
                                              child: Text(
                                                'Token Mapping Status',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 28,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 200 *
                                                      ((value.unlinkedDIRed ??
                                                              0) +
                                                          1) /
                                                      100,
                                                  child: Container(
                                                    width: 200 *
                                                        ((value.unlinkedDIRed ??
                                                                0) +
                                                            1) /
                                                        100,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorConstant.fromHex(
                                                              "#ff0000"),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Adjust the radius value as needed
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 28,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 200 *
                                                      ((value.unlinkedDIOrange ??
                                                              0) +
                                                          1) /
                                                      100,
                                                  child: Container(
                                                    width: 200 *
                                                        ((value.unlinkedDIOrange ??
                                                                0) +
                                                            1) /
                                                        100,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorConstant.fromHex(
                                                              "#ff9801"),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Adjust the radius value as needed
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 28,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 200 *
                                                      ((value.unlinkedDIGreen ??
                                                              0) +
                                                          1) /
                                                      100,
                                                  child: Container(
                                                    width: 200 *
                                                        ((value.unlinkedDIGreen ??
                                                                0) +
                                                            1) /
                                                        100,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorConstant.fromHex(
                                                              "#11c500"),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Adjust the radius value as needed
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })),
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }

  Widget buildCustomContainerChart(String title, String bgColor,
      String valueColor, double size, double progressValue, Size screenSize) {
    return customContainer(
        screenSize: screenSize,
        title: title,
        image: SizedBox(
          // child: Image.asset("assets/images/Sharts.png"),
          child: Container(
            decoration: BoxDecoration(
                color: ColorConstant.fromHex(bgColor),
                borderRadius: BorderRadius.circular(63)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular Progress Indicator
                SizedBox(
                  width: screenSize.width > 600 ? size : 80,
                  height: screenSize.width > 600 ? size : 80,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 2, // Adjust the border width as needed
                    backgroundColor: ColorConstant.fromHex(
                        bgColor), // Set the background color
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ColorConstant.fromHex(valueColor)),
                    strokeCap: StrokeCap.round, // Set the indicator color
                  ),
                ),

                // Red Border

                // Display Progress Value
                Text(
                  '${(progressValue).toInt()}',
                  style: TextStyle(
                    fontSize: screenSize.width > 600 ? 20.0 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set the text color
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
