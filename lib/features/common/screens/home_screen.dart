import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shreecement/features/biddingProcess/manualdiallotment_action_screen.dart';
import 'package:shreecement/features/biddingProcess/unlinked_deliveries.dart';
import 'package:shreecement/features/biddingprocesslogisitc/CancelStartBid.dart';
import 'package:shreecement/features/biddingprocesslogisitc/transporter_action_screen.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidTranspoter.dart';
import 'package:shreecement/features/biddingprocesslogisitc/startbid_logisticts_action.dart';
import 'package:shreecement/features/biddingprocesslogisitc/startBidTimerScreen.dart';
import 'package:shreecement/features/biddingprocesslogisitc/delink_logistics.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/screens/manage_users.dart';
import 'package:shreecement/features/common/screens/profile_page.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/customdrawer.dart';
import 'package:shreecement/features/di_pendency_screen/pending_di_view_data.dart';
import 'package:shreecement/features/invoicing/logistics_invoicing/freight_bill.dart';
import 'package:shreecement/features/invoicing/logistics_invoicing/shortage_master.dart';
import 'package:shreecement/features/invoicing/logistics_invoicing/validate_freight_bill.dart';
import 'package:shreecement/features/invoicing/logistics_invoicing/view_frieght_bill.dart';
import 'package:shreecement/features/invoicing/logistics_invoicing/view_invoice_logistics.dart';
import 'package:shreecement/features/masterdata/screens/master_data_section.dart';
import 'package:shreecement/features/biddingProcess/manualdiallotment.dart';
import 'package:shreecement/features/preBidding/screens/pre_bidding_process.dart';
import 'package:shreecement/features/super_admin/view/district_mapping.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_action.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_linking.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_submit.dart';
import 'package:shreecement/features/tokenMappingLogistic/screens/token_mapping_action_logistic.dart';
import 'package:shreecement/features/tokenMappingLogistic/screens/token_mapping_linking_logistic.dart';
import 'package:shreecement/features/tokenMappingLogistic/screens/token_mapping_logistics.dart';
import 'package:shreecement/utils/image_string.dart';
import 'package:shreecement/utils/styletextconstant.dart';
import '../../../global.dart';
import '../../../main.dart';
import '../../../utils/color_constant.dart';
import '../../biddingprocesslogisitc/bid_report.dart';
import '../../epod/screens/epod_screen.dart';
import '../../preBidding/screens/pre_bidding_process2.dart';
import '../../biddingProcess/start_bid_logistics.dart';
import '../models/logistic_dashboard.dart';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';
import '../widgets/custom_dropdown_3.dart';
 
///home page for logistics persona role id : 4
// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final control = Get.put(Controller());

  //linking pending

  List<Widget> screens = [
    const DashBoardScreen(), //0
    const ManageUsers(), //manage user screen //1
    const MasterDataScreen(), //2

    //pre bid process screens
    const PreBiddingProcess(), // 3
    const PreBidProcess2(), //4

    //bidding process screens
    const StartBidLogistics(), //5 //start bid logistics
    //unlinked deliveries
    const StartBidFig(), //6

    const CancelStartBid(), //another bidding screen //7

    const StartBidTransporterAction(), //another bidding screen //8
    const UnlinkedDeliveries(), //another bidding screen //9

    const StartBidTimerScreen(), //another bidding screen //10
    const ManualDiallotment(), //manual DI allotment //11

    const ManualDiAllotmentAction(), //manual DI allotment action screen //12

    const DashBoardScreen(), //13

    const StartBidTransporter(), //start bid transporter //14
    const DashBoardScreen(), //start bid transporter 2 //15
    const DashBoardScreen(), //start bid transporter 3 //16

    //token mapping screens
    const TokenMapping(), //17
    const TokenMappingAction(), //18
    const TokenMappingLinking(), //19
    const TokenMappingSubmit(), //20

    //profile screen
    const DashBoardScreen(), //21
    const StartBidLogisticsActionScreen(), //22
    const ProfilePage(), //23
    const DelinkLogistics(), //24

    //invoicing logistics
   const ValidateFreightBillLogistics(), //25
    const ValidateFreightBillLogistics(), // 26
    const ValidateFreightBillLogistics(), //27
    const ViewFrieghtBillLogistics(), //28
    const ValidateFreightBillLogistics(), //29
    const EpodScreen(), //30
    const DistrictMapping(), //31
    const BidReports(), //32

    //logistic token mapping
    const TokenMappingLogistic(),  //33
    const TokenMappingActionLogistics(),  //34
    const TokenMappingLinkingLogistic(),  //35

    //DI Pendency Screen
    const PendingDiViewData(),  //36

  ];

  @override
  Widget build(BuildContext context) {
    final username = sp?.getString("userName");
    return SafeArea(
      child: Scaffold(
        // appBar: const MyCustomAppBar(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Image.asset(Images.logowhite),
          backgroundColor: ColorConstant.redbar,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Text(
                      username![0].toUpperCase(),
                      style: StyleText.robotowbold.copyWith(fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  username,
                  style: StyleText.robotow40012.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                )
                // IconButton(
                //     onPressed: () {},
                //     icon: const Icon(
                //       Icons.arrow_drop_down_outlined,
                //       color: Colors.white,
                //     ))
              ],
            )
          ],
        ),
        drawer: const CustomDrawer(),
        body: Obx(() => screens.elementAt(control.currentIndex.value)),
      ),
    );
  }
}

Future<LogisticUserDashboard> getDiCount(
    {required String plantCode, required BuildContext ctx}) async {
  if (sp?.getString("employeeCode") != null) {
    final queryParameters = {
      "employeeCode": sp?.getString("employeeCode") ?? "",
      "plantCode": plantCode
    };

          // Retrieve token from secure storage
      String? token = await secureStorage.read("token");

      debugPrint("token in dicount api $token");


    final uri = Uri.https(domain,
        "app/bidding/dashboard/getLogisticDashbordData", queryParameters);

    var res = await http.get(uri, headers: {
      "Authorization":  "Bearer $token",
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
    return LogisticUserDashboard.fromJson(result);
  }
  return LogisticUserDashboard();
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  ValueNotifier<LogisticUserDashboard> LogisticUserDashboardResponse =
      ValueNotifier(LogisticUserDashboard());

  LogisticUserDashboard response = LogisticUserDashboard();

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
    } catch (e) {}
  }

  ValueNotifier<MapEntry<String, String>> selectedPlant =
      ValueNotifier(const MapEntry("", ""));

  // ValueNotifier<LogisticUserDashboard> transporterResponse=ValueNotifier(LogisticUserDashboard());

  ValueNotifier enabled = ValueNotifier(false);
  bool showallinit = true;
  fetchData() async {
    try {
      response = await getDiCount(
          plantCode: selectedPlant.value.value.isNotEmpty
              ? selectedPlant.value.value
              : "",
          ctx: context);
      LogisticUserDashboardResponse.value = response;
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size = 130;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(211, 216, 239, 1.0),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
        actions: const [
          // Row(
          //   children: [
          //     Text(DateFormat('EEE dd-MM-yyyy hh:mm a').format(DateTime.now())
          //         ,
          //         textAlign: TextAlign.right,
          //         style: const TextStyle(
          //           color: Colors.black,
          //           fontSize: 10,
          //           fontFamily: 'Roboto',
          //           fontWeight: FontWeight.w400,
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
          child: ValueListenableBuilder<LogisticUserDashboard>(
              valueListenable: LogisticUserDashboardResponse,
              builder: (context, value, child) {
                // var MapdataItems = [
                //   {"title": "Bids Won", "value": value.automatedBids!+value.manualBids!},
                //   {"title": "Bids Lost", "value": value.totalBids!-(value.automatedBids!+value.manualBids!)},
                // ];
                var MapdataItems = [
                  {
                    "title": "Automated Bids",
                    "value": (value.automatedBidCount ?? 0),
                  },
                  {
                    "title": "Manual Bids",
                    "value": (value.manualBidCount ?? 0),
                  },
                ];

                // print(value.totalBids.toString());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Plant Selected",
                                        style: TextStyle(color: Colors.black),
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
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          buildCustomContainerChart(
                              "Scheduled Bids",
                              "#fbe3d4",
                              "#cc1516",
                              size,
                              value.scheduledBidCount ?? 0,
                              screenSize),
                          buildCustomContainerChart(
                              "Cancelled Bids",
                              "#fbd4d4",
                              "#fc0606",
                              size,
                              value.cancelledBidCount ?? 0,
                              screenSize),
                          buildCustomContainerChart(
                              "Running Bids",
                              "#e3fbd4",
                              "#32a628",
                              size,
                              value.runningBidCount ?? 0,
                              screenSize),
                          buildCustomContainerChart(
                              "In-force Bids",
                              "#fbebd4",
                              "#fc9c06",
                              size,
                              value.inforceBidCount ?? 0,
                              screenSize),
                          buildCustomContainerChart(
                              "Active Bids",
                              "#e4fbd4",
                              "#16c406",
                              size,
                              value.activeBidCount ?? 0,
                              screenSize),
                          buildCustomContainerChart(
                              "Total DI Allotted",
                              "#e4fbd4",
                              "#16c406",
                              size,
                              value.totalDiAllotedCount ?? 0,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PieChart(
                                        dataMap: Map.fromIterable(
                                          MapdataItems,
                                          key: (item) => item["title"],
                                          value: (item) => item["value"],
                                        ),
                                        chartType: ChartType.disc,
                                        legendOptions: LegendOptions(
                                          legendPosition: LegendPosition.right,
                                          legendTextStyle: TextStyle(
                                              fontSize: screenSize.width > 600
                                                  ? 16
                                                  : 12),
                                        ),
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        colorList: [
                                          ColorConstant.fromHex("#fbebd4"),
                                          ColorConstant.fromHex("#ff0000")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
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

  double getAppBarHeight(BuildContext context) {
    // You can adjust the multiplication factor based on your needs
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.1; // 10% of the screen height
  }
}

Widget customContainer({String? title, Widget? image, Size? screenSize}) {
  return Container(
    width: screenSize!.width > 600 ? 220 : 160,
    height: screenSize.width > 600 ? 200 : 140,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black38,
          strokeAlign: 1,
        )),
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? "title",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenSize.width > 600 ? 20 : 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [image!],
        )
      ],
    ),
  );
}
