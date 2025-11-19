// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/models/other_link_response_model.dart';
import 'package:shreecement/features/login/screens/login_screen.dart';
import 'package:shreecement/global.dart';

import 'package:shreecement/main.dart';

import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/utils/epod_icon.dart';
import 'package:shreecement/utils/styletextconstant.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/freight_bill_icon.dart';
import '../controller/controller.dart';

// ignore: must_be_immutable

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool selected = true;

  final control = Get.put(Controller());

  Widget customListTile({
    IconData? icon,
    CustomPaint? img,
    required String text,
    required VoidCallback ontap,
    required int index,
  }) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Add a grey border
        ),
        child: ListTile(
          onTap: ontap,
          title: Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                      size: 14,
                      color: control.currentIndex.value == index
                          ? Colors.white
                          : Colors.black,
                    )
                  : img ?? Container(),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: StyleText.robotow40013.copyWith(
                    color: control.currentIndex.value == index
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
          tileColor: control.currentIndex.value == index
              ? ColorConstant.redbar
              : ColorConstant.colordrawritem,
        ),
      ),
    );
  }

  Widget customexpansiontile(
      {IconData? icon,
      required String text,
      Function(bool)? onTap,
      required List<Widget> listItems,
      CustomPaint? img}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: ExpansionTile(
        onExpansionChanged: onTap,
        backgroundColor: ColorConstant.color1,
        collapsedBackgroundColor: ColorConstant.colordrawritem,
        textColor: Colors.white,
        iconColor: Colors.white,
        title: Row(
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 14,
                  )
                : img ?? Container(),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: StyleText.robotow40013,
            )
          ],
        ),
        children: listItems,
      ),
    );
  }

  Widget customExpansionListItem(String text, VoidCallback? tap, int index) {
    return Obx(
      () => Container(
        color: Colors.white, // Set active color here
        child: ListTile(
          onTap: () {
            control.currentIndex.value =
                index; // Update the currentIndex on tap
            tap?.call(); // Call the provided callback if it's not null
            Get.back(); // Close the drawer
          },
          horizontalTitleGap: 0.0,
          leading: Stack(
            children: [
              StyledVerticalDivider(
                color: ColorConstant.colorgrey,
                thickness: 3,
                width: 0,
                lineStyle: DividerLineStyle.dotted,
                indent: 0,
                endIndent: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 2.0),
                child: Text(
                  '--',
                  style:
                      TextStyle(fontSize: 20, color: ColorConstant.colorgrey),
                ),
              ),
            ],
          ),
          title: Text(
            text,
            style: StyleText.robotow40012.copyWith(
              color: control.currentIndex.value == index
                  ? ColorConstant.redbar
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget customExpansionListItemForLinks(String text, VoidCallback? tap) {
    return Container(
        color: Colors.white, // Set active color here
        child: ListTile(
          onTap: () {
            // Update the currentIndex on tap
            tap?.call(); // Call the provided callback if it's not null
            Get.back(); // Close the drawer
          },
          horizontalTitleGap: 0.0,
          leading: Stack(
            children: [
              StyledVerticalDivider(
                color: ColorConstant.colorgrey,
                thickness: 3,
                width: 0,
                lineStyle: DividerLineStyle.dotted,
                indent: 0,
                endIndent: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 2.0),
                child: Text(
                  '--',
                  style:
                      TextStyle(fontSize: 20, color: ColorConstant.colorgrey),
                ),
              ),
            ],
          ),
          title: Text(
            text,
            style: StyleText.robotow40012.copyWith(
              color: Colors.black,
            ),
          ),
        ));
  }

  var roleID;

  @override
  void initState() {
    roleID = (sp?.getString("roleId").toString());
    // roleID = "2";
    super.initState();
  }
  //change

  // String ilmsUrl = "http://192.168.100.87:8040/ilmsdev/ilmssso?token=12345";
  // String customerinvoiceUrl = "https://customerinvoice.shreecement.com";
  // String crmUrl =
  //     "https://app.powerbi.com/reportEmbed?reportId=e59be69f-d286-49a2-8974-b642427b1451&autoAuth=true&ctid=4e337c10-c06f-4f31-bb24-933689c1056b";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      backgroundColor: Colors.white.withOpacity(0.4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (roleID != "2" && roleID != "6") ...[
            customListTile(
                icon: Icons.dashboard_outlined,
                text: 'Dashboard',
                ontap: () {
                  control.currentIndex.value = 0;
                },
                index: 0),
          ],
          if (roleID == "1" || roleID == "2") ...[
            customListTile(
                icon: Icons.dashboard_outlined,
                text: 'Manage Users',
                ontap: () {
                  control.currentIndex.value = 1;
                },
                index: 1),
            customListTile(
                icon: Icons.map_outlined,
                text: 'Transporter District Mapping',
                ontap: () {
                  control.currentIndex.value = 25;
                },
                index: 25),
            customexpansiontile(
              icon: Icons.bar_chart_sharp,
              text: 'Reports',
              onTap: (gsg) {
                control.currentIndex.value = 26;
              },
              listItems: [
                customExpansionListItem('Bid View Report', () {}, 26),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
            customListTile(
              icon: Icons.logout_outlined,
              text: 'Logout',
              ontap: () {
                logoutUser();
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              index: 100,
            ),
          ] else if (roleID == "3" || roleID == "5") ...[
            customListTile(
                icon: Icons.timeline,
                text: 'View Pending DI',
                ontap: () {
                  control.currentIndex.value = 32;
                },
                index: 32),
            customexpansiontile(
              icon: Icons.gavel_outlined,
              text: 'Bidding Process',
              onTap: (gsg) {
                control.currentIndex.value = 14;
              },
              listItems: [
                customExpansionListItem('View Bid', () {}, 14),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
            customListTile(
                icon: Icons.map,
                text: 'Token Mapping',
                ontap: () {
                  control.currentIndex.value = 17;
                },
                index: 17),
            customListTile(
                icon: Icons.print,
                text: 'LR / GR Printing',
                ontap: () {
                  control.currentIndex.value = 30;
                },
                index: 30),
            customexpansiontile(
              img: CustomPaint(
                painter: FreightBillIcon(),
                size: const Size(14, 14),
              ),
              text: 'Freight Bill',
              onTap: (hasValue) {},
              listItems: [
                customExpansionListItem(
                  'Generate Bill',
                  () {},
                  25,
                ),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
                customExpansionListItem('View Bill Status', () {}, 27),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
                customExpansionListItem('View Payment Status', () {}, 28),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
            customexpansiontile(
              img: CustomPaint(
                painter: LinkIconPainter(),
                size: const Size(14, 14),
              ),
              text: 'Other Links',
              onTap: (hasValue) {},
              listItems: [
                customExpansionListItemForLinks(
                  'ILMS Portal',
                  () async {
                    // launchUrlSiteBrowser(url: ilmsUrl);
                    print("ILMS");
                    await customerPortApi(ctx: context, isILms: true);
                  },
                ),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
                customExpansionListItemForLinks(
                  'Customer Portal',
                  () async {
                    await customerPortApi(ctx: context);

                    // launchUrlSiteBrowser(url: customerinvoiceUrl);
                  },
                ),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
                customExpansionListItemForLinks(
                  'CRM Portal',
                  ()async {
                     await customerPortApi(ctx: context, isCRM: true);
                  },
                ),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
            customListTile(
                icon: Icons.person_2_outlined,
                text: 'Profile',
                ontap: () {
                  control.currentIndex.value = 23;
                },
                index: 21),
            customListTile(
              icon: Icons.logout_outlined,
              text: 'Logout',
              ontap: () async {
                await logoutUser();
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              index: 100,
            ),
          ] else if (roleID == "6")...[
            customexpansiontile(
              icon: Icons.bar_chart_sharp,
              text: 'Reports',
              onTap: (gsg) {
                control.currentIndex.value = 1;
              },
              listItems: [
                customExpansionListItem('Bid View Report', () {}, 1),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
            customListTile(
                icon: Icons.person_2_outlined,
                text: 'Profile',
                ontap: () {
                  control.currentIndex.value = 2;
                },
                index: 2),
            customListTile(
              icon: Icons.logout_outlined,
              text: 'Logout',
              ontap: () {
                logoutUser();
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              index: 100,
            ),
          ]else if (roleID == "4") ...[
            (sp?.getString("reportAccess")?.compareTo("true") == 0)
                ? customexpansiontile(
                    icon: Icons.bar_chart_sharp,
                    text: 'Reports',
                    onTap: (gsg) {
                      control.currentIndex.value = 32;
                    },
                    listItems: [
                      customExpansionListItem('Bid View Report', () {}, 32),
                      StyledDivider(
                        color: ColorConstant.colorgrey,
                        height: 0,
                        thickness: 5,
                        lineStyle: DividerLineStyle.dotted,
                        indent: 0,
                        endIndent: 0,
                      ),
                    ],
                  )
                : Container(),

            customListTile(
                icon: Icons.timeline,
                text: 'Pre Bid Process',
                ontap: () {
                  control.currentIndex.value = 3;
                },
                index: 3),
            customexpansiontile(
              icon: Icons.gavel_outlined,
              text: 'Bidding Process',
              onTap: (hasvalue) {},
              listItems: [
                customExpansionListItem(
                  'Start Bid',
                  () {},
                  5,
                ),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
                customExpansionListItem('Manual DI Allotment', () {}, 11),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
                customExpansionListItem('Unlink Token', () {}, 24),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
                customExpansionListItem('Token Mapping', () {}, 33),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
            customListTile(
                img: CustomPaint(
                  painter: EpodIcon(),
                  size: const Size(14, 14),
                ),
                text: 'ePOD',
                ontap: () {
                  control.currentIndex.value = 30;
                },
                index: 30),
            customexpansiontile(
              img: CustomPaint(
                painter: FreightBillIcon(),
                size: const Size(14, 14),
              ),
              text: 'Freight Bill',
              onTap: (hasValue) {},
              listItems: [
                customExpansionListItem('View Freight Bill', () {}, 28),
                StyledDivider(
                  color: ColorConstant.colorgrey,
                  height: 0,
                  thickness: 5,
                  lineStyle: DividerLineStyle.dotted,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
            //  customexpansiontile(
            //   img: CustomPaint(
            //     painter: LinkIconPainter(),
            //     size: const Size(14, 14),
            //   ),
            //   text: 'Other Links',
            //   onTap: (hasValue) {},
            //   listItems: [

            //     StyledDivider(
            //       color: ColorConstant.colorgrey,
            //       height: 0,
            //       thickness: 5,
            //       lineStyle: DividerLineStyle.dotted,
            //       indent: 0,
            //       endIndent: 0,
            //     ),
            //     customExpansionListItemForLinks('CRM Portal', () {
            //        launchUrlSiteBrowser(url: pfbUrl);
            //     },),
            //     StyledDivider(
            //       color: ColorConstant.colorgrey,
            //       height: 0,
            //       thickness: 5,
            //       lineStyle: DividerLineStyle.dotted,
            //       indent: 0,
            //       endIndent: 0,
            //     ),
            //   ],
            // ),
            customListTile(
                icon: Icons.menu_book_outlined,
                text: 'Pending DI View Data',
                ontap: () {
                  control.currentIndex.value = 36;
                },
                index: 36),
            customListTile(
                icon: Icons.person_2_outlined,
                text: 'Profile',
                ontap: () {
                  control.currentIndex.value = 23;
                },
                index: 21),
            customListTile(
              icon: Icons.logout_outlined,
              text: 'Logout',
              ontap: () async {
                await logoutUser();
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              index: 100,
            ),
          ],
        ],
      ),
    );
  }
}

Future<dynamic> logoutUser() async {
  String url = "$baseUrl/users/logout";
  try {


      String? token = await secureStorage.read("token");


    var res = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "userName": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
      body: jsonEncode({"emailId": sp?.getString("emailId") ?? ""}),
    );

      await secureStorage.deleteAll();

    return res.body;
  } catch (e) {
    debugPrint("$e");
  }
}

Future<void> launchUrlSiteBrowser({
  required String url,
}) async {
  try {
    print("launching started");
    final Uri urlParsed = Uri.parse(url);
    print("Parsed URL: $urlParsed");

    if (await canLaunchUrl(urlParsed)) {
      await launchUrl(urlParsed, mode: LaunchMode.externalApplication);
      print("URL launched successfully");
    } else {
      print("Could not launch $urlParsed");
      throw 'Could not launch $urlParsed';
    }
  } catch (e) {
    print("Error occurred while launching URL: $e");
  }
}


Future<void> showErrorDialogue(String message, BuildContext ctxx) async {
  return showDialog<void>(
    context: ctxx,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
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

RxBool isOtherLinkLoading = false.obs;

Future<dynamic> customerPortApi({
  bool isILms = false,
  required BuildContext ctx,
  bool isCRM = false,
}) async {
  String url = "$baseUrl/users/getApp";
  try {
    isOtherLinkLoading.value = true;
    String? token = await secureStorage.read("token");
    var res = await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "userName": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
      body: jsonEncode(
        {
          "transporterId": sp?.getString("employeeCode") ?? "",
          "appName": isCRM ? "CRM" : (isILms ? "ILMS" : "CPR"),
        },
      ),
    );

    // debugPrint("Response Status Code: ${res.statusCode}");
    // debugPrint("Response Body: ${res.body}");

    dynamic jsonResponse;
    try {
      jsonResponse = jsonDecode(res.body);
    } catch (e) {
      // debugPrint("JSON decode error: $e");
      if (ctx.mounted) {
        showErrorDialogue("Invalid response from server", ctx);
      }
      return;
    }

    final responseModel = OtherLinkResponseModel.fromJson(jsonResponse);

    if (res.statusCode == 200) {
      if (responseModel.successUrl != null && responseModel.successUrl!.isNotEmpty) {
        launchUrlSiteBrowser(url: responseModel.successUrl!);
      } else {
        if (ctx.mounted) {
          showErrorDialogue("Invalid URL in response", ctx);
        }
      }
    } else if (res.statusCode == 400) {
      if (ctx.mounted) {
        showErrorDialogue("Oops, some error occurred", ctx);
      }
    } else if (res.statusCode == 404) {
      if (ctx.mounted) {
        showErrorDialogue(responseModel.responseMessage ?? "", ctx);
      }
    } else {
      if (ctx.mounted) {
        showErrorDialogue("Unexpected error occurred (${res.statusCode})", ctx);
      }
    }
  } catch (e) {
    // debugPrint("customerPortApi error: $e");
    if (ctx.mounted) {
      showErrorDialogue("An unexpected error occurred", ctx);
    }
  } finally {
    isOtherLinkLoading.value = false;
  }
}