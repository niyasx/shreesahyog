import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/widgets/custom_drop_down.dart';
import 'package:shreecement/features/preBidding/apiModels/di_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../common/controller/controller.dart';
import '../common/screens/token_expire.dart';
import '../common/table/table_widgets.dart';
import '../common/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;

class CancelStartBid extends StatefulWidget {
  const CancelStartBid({super.key});

  @override
  State<CancelStartBid> createState() => _CancelStartBidState();
}

class _CancelStartBidState extends State<CancelStartBid> {
  final control = Get.put(Controller());
  Future<DiList> getDitypeList() async {
     String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/diType-list";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization":"Bearer $token",
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
      appBarText: "Cancel Bid",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cancel Bid',
                style: TextStyle(
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
                          color: Colors.grey,
                        ),
                      ),
                      vSpace(2),
                      const Text(
                        'Finished Goods Cement SG',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                      vSpace(10),
                      SizedBox(
                        width: 800,
                        child: Row(
                          children: [
                            labelledCustomDD(
                              label: "Division",
                              selVal: "Cement",
                              list: [
                                "Cement",
                                "Cement 1",
                                "Cement 2",
                                "Cement 3",
                                "Cement 4"
                              ],
                            ),
                            wSpace(20),
                            Expanded(
                              child: FutureBuilder(
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
                                      diList.add(snapshot.data!.diTypeList![i]
                                          .toString());
                                    }

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "DI Type",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        CustomDropdownMenu(
                                          selVal: diList.first,
                                          list: diList,
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
                            ),
                            wSpace(20),
                            SizedBox(
                              child: Expanded(
                                  child: labelledEnabledText(
                                      hgt: 30,
                                      label: "Time for Bidding (in Mins.)",
                                      text: sp!.getString(
                                              "timeForBiddingInMinutes") ??
                                          "")),
                            ),
                            wSpace(20),
                            SizedBox(
                              child: Expanded(
                                  child: labelledEnabledText(
                                      hgt: 30,
                                      label: "Re-Bid Time (in Hours)",
                                      text: sp?.getString("reBidTimeInHours") ??
                                          "")),
                            )
                          ],
                        ),
                      ),
                      vSpace(20),
                      Row(
                        children: [
                          SizedBox(
                            child: Expanded(
                                child: labelledEnabledText(
                                    hgt: 30,
                                    label: "BId Cancel Reason",
                                    text: "")),
                          ),
                          wSpace(20),
                          SizedBox(
                            child: Expanded(
                                child: labelledEnabledText(
                                    hgt: 30,
                                    label: "Bidding Status",
                                    text: "")),
                          ),
                        ],
                      ),
                      vSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          button(btnText: "Start Bid", tapFunction: () {}),
                          wSpace(10),
                          button(
                            btnText: "Cancel Running Bid",
                            btnClr: Colors.white,
                            btnTxtClr: ColorConstant.redbar,
                            tapFunction: () {},
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
