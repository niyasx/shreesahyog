// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/models/profile_model.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/widgets/custom_popup_menu.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import '../../../utils/color_constant.dart';
import '../../common/controller/controller.dart';
import '../../common/table/table_widgets.dart';
import 'package:http/http.dart' as http;
import '../api/transporter_profile_page.dart';
import '../controller/mobile_number.dart';
import '../models/transporter_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final control = Get.put(Controller());

  List<ProfileResponseList> originalProfileList = [];
  ValueNotifier<List<ProfileResponseList>> profileResponseList =
      ValueNotifier([]);
  ValueNotifier<List<SPOCUserList>> spoclistfortable = ValueNotifier([]);
  LimitedLengthTextController fullName = LimitedLengthTextController();
  MobileTextEditingController mobileNo = MobileTextEditingController();
  TextEditingController emailID = TextEditingController();
  List<ValueNotifier<bool>> plantCheckboxStates = [];
  List<List<ValueNotifier<bool>>> plantCheckboxStatesList = [];
  List<String> selectedPlants = [];
  List<LimitedLengthTextController> EditfullName = [];
  List<MobileTextEditingController> EditmobileNo = [];
  List<TextEditingController> EditemailID = [];
  List<List<ValueNotifier<bool>>> EditplantCheckboxStates = [];
  List<List<String>> EditselectedPlants = [];
  List<SPOCUserList> spocList = [];
  late Map<String, String> avlList = {};
  ValueNotifier<bool> activeValNotifier = ValueNotifier(false);
  List<ValueNotifier<bool>> statusSwitch = [];

  var roleID;

  @override
  void initState() {
    super.initState();
    roleID = (sp?.getString("roleId").toString());
    fetchPreBidList();
    if (roleID == "3") {
      getSPOCList();
    }
  }

  fetchPreBidList() async {
    try {
      final ProfileModel response = await _getProfileList();
      originalProfileList = response.responseList ?? [];
      profileResponseList.value = List.from(originalProfileList);
      for (int i = 0; i < profileResponseList.value.length; i++) {
        avlList[profileResponseList.value[i].plantCode.toString()] =
            profileResponseList.value[i].plantName.toString();
      }
      for (int i = 0; i < profileResponseList.value.length; i++) {
        avlList[profileResponseList.value[i].plantCode.toString()] =
            profileResponseList.value[i].plantName.toString();
        plantCheckboxStates.add(ValueNotifier(false));
      }
    } catch (e) {}
  }

  Future<dynamic> _getProfileList() async {
    try {
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
      final uri =
          Uri.https(domain, "/app/users/getUserPlantMapping", queryParameters);
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });

      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TokenExpire()),
        );
      }
      // print(result);
      return ProfileModel.fromJson(result);
    } catch (e) {
      // print("error in tokenmap api $e");
    }
  }

  Future<dynamic> getSPOCList() async {
    try {
      final queryParameters = {
        "transporterCode": sp?.getString("employeeCode") ?? ""
      };
      String? token = await secureStorage.read("token");
      final uri = Uri.https(domain, "app/users/staff-users", queryParameters);
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });

       final result = jsonDecode(res.body);
      if(res.statusCode==403){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const TokenExpire()),
        );
      }



      // var result = jsonDecode(res.body);
      spocList.clear();
      statusSwitch.clear();
      EditselectedPlants.clear();
      EditemailID.clear();
      EditmobileNo.clear();
      plantCheckboxStatesList.clear();
      EditfullName.clear();

      for (int i = 0; i < result.length; i++) {
        spocList.add(SPOCUserList.fromJson(result[i]));
        statusSwitch.add(ValueNotifier(spocList[i].status ?? false));

        EditemailID.add(TextEditingController(text: spocList[i].emailId ?? ""));
        EditfullName.add(
            LimitedLengthTextController(text: spocList[i].userName ?? ""));
        EditmobileNo.add(
            MobileTextEditingController(text: spocList[i].mobileNumber ?? ""));
        EditselectedPlants.add([]);
        for (int k = 0; k < spocList[i].userPlantMappedList!.length; k++) {
          EditselectedPlants[i]
              .add(spocList[i].userPlantMappedList![k].plantCode.toString());
        }
        plantCheckboxStatesList
            .add(List.generate(avlList.length, (j) => ValueNotifier(false)));
      }

      spoclistfortable.value = List.from(spocList);

      // return SPOCUserList.fromJson(result);
    } catch (e) {
      // print("error in tokenmaps api $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 5)) / 100;
    return CustomScaffold(
      appBarText: "Profile",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                    fontSize: 21,
                    fontFamily: 'RobotoLight',
                    fontWeight: FontWeight.w100),
              ),
              vSpace(20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    width: size.width * 0.14,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E2E2),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width > 600 ? 12 : 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 40,
                      decoration: const BoxDecoration(color: Color(0xFFF6F6F6)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          sp?.getString("name") ?? "",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width < 600 ? 12 : 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              vSpace(1),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    width: size.width * 0.14,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E2E2),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        ' Mobile No.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width < 600 ? 12 : 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 40,
                      decoration: const BoxDecoration(color: Color(0xFFF6F6F6)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          sp?.getString("mobileNo") ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              vSpace(1),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    width: size.width * 0.14,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E2E2),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        ' Email Id.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width < 600 ? 12 : 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 40,
                      decoration: const BoxDecoration(color: Color(0xFFF6F6F6)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          sp?.getString("userName") ?? "",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              vSpace(1),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    width: size.width * 0.14,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E2E2),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Plants Linked',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width < 600 ? 12 : 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 70,
                      decoration: const BoxDecoration(color: Color(0xFFF6F6F6)),
                      child: ValueListenableBuilder(
                        valueListenable: profileResponseList,
                        builder: (BuildContext context,
                            List<ProfileResponseList> value, Widget? child) {
                          if (value.isEmpty) {
                            return Container();
                          }
                          List<String> plantNames = value
                              .map((profile) => profile.plantName ?? "")
                              .toList();

                          return SingleChildScrollView(
                            child: Container(
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(
                                  maxHeight: 70, minHeight: 70, minWidth: 360),
                              child: Wrap(
                                runSpacing: 10,
                                spacing: 20,
                                children: [
                                  Text(
                                    plantNames.join(', '),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              if (roleID == "3") ...[
                const SizedBox(
                  height: 30,
                ),
                ValueListenableBuilder(
                  valueListenable: spoclistfortable,
                  builder: (BuildContext context, List<SPOCUserList> value,
                      Widget? child) {
                    if (value.isEmpty) {
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
                            "Sr. No.",
                            heading: true,
                            width: 6,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "SPOC Name",
                            heading: true,
                            width: dynamicSize,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Phone No.",
                            heading: true,
                            width: dynamicSize,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Email ID",
                            heading: true,
                            width: dynamicSize,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Plant Name",
                            heading: true,
                            width: dynamicSize,
                          ),
                        ),
                        const DataColumn(
                          label: TableColumn(
                            "Active",
                            heading: true,
                            width: 130,
                          ),
                        ),
                        const DataColumn(
                          label: TableColumn(
                            "Action",
                            heading: true,
                            width: 70,
                          ),
                        ),
                      ],
                      rows: List.generate(
                        value.length,
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
                                  value[index].userName.toString(),
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  value[index].mobileNumber.toString(),
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  value[index].emailId ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                buildTableColumn(value, index),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      "No",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w100,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: statusSwitch[index],
                                      builder: (context, value, child) {
                                        //  print(statusSwitch[index]);
                                        return Transform.scale(
                                          scaleX: 0.85,
                                          scaleY: 0.75,
                                          child: Switch(
                                            value: value,
                                            onChanged: (newValue) async {
                                              setState(() {
                                                statusSwitch[index].value =
                                                    newValue;
                                              });

                                              List<Map<String, String>> a = [];

                                              for (int i = 0;
                                                  i <
                                                      EditselectedPlants[index]
                                                          .length;
                                                  i++) {
                                                Map<String, String> b = {};
                                                b["plantCode"] =
                                                    EditselectedPlants[index]
                                                        [i];
                                                a.add(b);
                                              }
                                              try {
                                                await updateSPOCUser(
                                                  empCode: spocList[index]
                                                      .employeeCode
                                                      .toString(),
                                                  updatedBy: sp?.getString(
                                                          "employeeCode") ??
                                                      "",
                                                  emailId:
                                                      EditemailID[index].text,
                                                  mobileNumber:
                                                      EditmobileNo[index]
                                                          .value
                                                          .text,
                                                  roleId: 5,
                                                  roleName: "TRANSPORTER_STAFF",
                                                  stateName: "",
                                                  supplierCode: int.parse(sp!
                                                      .getString("employeeCode")
                                                      .toString()),
                                                  supplierName:
                                                      sp?.getString("name") ??
                                                          "",
                                                  status:
                                                      statusSwitch[index].value,
                                                  userPlantMappedList: a,
                                                  userName:
                                                      EditfullName[index].text,
                                                );
                                              } catch (e) {
                                                // print(e);
                                              }

                                              setState(() {});
                                              await getSPOCList();
                                            },
                                            activeTrackColor:
                                                ColorConstant.redbar,
                                            inactiveTrackColor: Colors.grey,
                                            inactiveThumbColor: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                    const Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w100,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ],
                                ),
                                // TableColumn(
                                //   value[index].status.toString(),
                                //   index: index,
                                // ),
                              ),
                              DataCell(
                                InkWell(
                                  child: TableColumnActionIcon(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    index: index,
                                  ),
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomPopup(
                                          title: "Edit SPOC",
                                          columnChildrens: [
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 5.0,
                                              children: [
                                                customTextField(
                                                    label: "SPOC Name",
                                                    hint: "Firstname Lastname",
                                                    controller:
                                                        EditfullName[index]),
                                                // const SizedBox(height: 16.0),
                                                customTextField(
                                                    label: "Phone Number",
                                                    hint: "9898989898",
                                                    controller:
                                                        EditmobileNo[index]),

                                                // const SizedBox(height: 16.0),
                                                customTextField(
                                                    label: "Email Id",
                                                    hint: "something@gmail.com",
                                                    controller:
                                                        EditemailID[index]),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              // child: Wrap(
                                              //   spacing: 38.0,
                                              //   runSpacing: 20.0,
                                              //   children: List.generate(
                                              //     avlList.length,
                                              //         (i) {
                                              //       print("gdhagdhas");
                                              //       print(i);
                                              //       String plantCode = avlList.keys.elementAt(i);
                                              //       String plantName = avlList.values.elementAt(i);
                                              //
                                              //       return ValueListenableBuilder(
                                              //         valueListenable: plantCheckboxStatesList[index][i],
                                              //         builder: (BuildContext context, bool value, Widget? child) {
                                              //           return Row(
                                              //             mainAxisSize: MainAxisSize.min,
                                              //             children: [
                                              //               Checkbox(
                                              //                 value: value,
                                              //                 onChanged: (newValue) {
                                              //                   setState(() {
                                              //                     plantCheckboxStatesList[index][i].value = newValue ?? false;
                                              //                   });
                                              //                   if (plantCheckboxStatesList[index][i].value) {
                                              //                     EditselectedPlants[index].add(plantCode);
                                              //                   }
                                              //                   else {
                                              //                     EditselectedPlants[index].remove(plantCode);
                                              //                   }
                                              //                   print(EditselectedPlants[index].toString());
                                              //                 },
                                              //               ),
                                              //               Text(plantName),
                                              //             ],
                                              //           );
                                              //         },
                                              //       );
                                              //     },
                                              //   ),
                                              // ),
                                              // Inside the Wrap widget
                                              child: Wrap(
                                                spacing: 38.0,
                                                runSpacing: 20.0,
                                                children: List.generate(
                                                  avlList.length,
                                                  (i) {
                                                    String plantCode = avlList
                                                        .keys
                                                        .elementAt(i);
                                                    String plantName = avlList
                                                        .values
                                                        .elementAt(i);

                                                    plantCheckboxStatesList[
                                                                index][i]
                                                            .value =
                                                        EditselectedPlants[
                                                                index]
                                                            .contains(
                                                                plantCode);

                                                    return ValueListenableBuilder(
                                                      valueListenable:
                                                          plantCheckboxStatesList[
                                                              index][i],
                                                      builder:
                                                          (BuildContext context,
                                                              bool value,
                                                              Widget? child) {
                                                        // Set the initial value based on whether the plantCode is in EditselectedPlants

                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Checkbox(
                                                              value: value,
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  plantCheckboxStatesList[index]
                                                                              [i]
                                                                          .value =
                                                                      newValue ??
                                                                          false;
                                                                });

                                                                if (plantCheckboxStatesList[
                                                                        index][i]
                                                                    .value) {
                                                                  EditselectedPlants[
                                                                          index]
                                                                      .add(
                                                                          plantCode);
                                                                } else {
                                                                  EditselectedPlants[
                                                                          index]
                                                                      .remove(
                                                                          plantCode);
                                                                }

                                                                // print(EditselectedPlants[
                                                                //         index]
                                                                //     .toString());
                                                              },
                                                            ),
                                                            Text(plantName),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            // Checkbox(value: is, onChanged: onChanged)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Active",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xff616161)),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "No",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w100,
                                                            fontFamily:
                                                                "Roboto",
                                                          ),
                                                        ),
                                                        ValueListenableBuilder<
                                                            bool>(
                                                          valueListenable:
                                                              statusSwitch[
                                                                  index],
                                                          builder: (context,
                                                              value, child) {
                                                            return Switch(
                                                              value: value,
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  statusSwitch[
                                                                              index]
                                                                          .value =
                                                                      newValue;
                                                                });
                                                              },
                                                              activeTrackColor:
                                                                  ColorConstant
                                                                      .redbar,
                                                              inactiveTrackColor:
                                                                  Colors.grey,
                                                              inactiveThumbColor:
                                                                  Colors.white,
                                                            );
                                                          },
                                                        ),
                                                        const Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w100,
                                                            fontFamily:
                                                                "Roboto",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                          buttonWidget: button(
                                              btnText: "Update",
                                              tapFunction: () async {
                                                if (!isEmailValid(
                                                    EditemailID[index]
                                                        .value
                                                        .text)) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Invalid Input'),
                                                        content: const Text(
                                                            'Please enter a valid Email Address'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  return;
                                                }

                                                List<Map<String, String>> a =
                                                    [];

                                                for (int i = 0;
                                                    i <
                                                        EditselectedPlants[
                                                                index]
                                                            .length;
                                                    i++) {
                                                  Map<String, String> b = {};
                                                  b["plantCode"] =
                                                      EditselectedPlants[index]
                                                          [i];
                                                  a.add(b);
                                                }
                                                try {
                                                  await updateSPOCUser(
                                                    empCode: spocList[index]
                                                        .employeeCode
                                                        .toString(),
                                                    updatedBy: sp?.getString(
                                                            "employeeCode") ??
                                                        "",
                                                    emailId:
                                                        EditemailID[index].text,
                                                    mobileNumber:
                                                        EditmobileNo[index]
                                                            .value
                                                            .text,
                                                    roleId: 5,
                                                    roleName:
                                                        "TRANSPORTER_STAFF",
                                                    stateName: "",
                                                    supplierCode: int.parse(sp!
                                                        .getString(
                                                            "employeeCode")
                                                        .toString()),
                                                    supplierName:
                                                        sp?.getString("name") ??
                                                            "",
                                                    status: statusSwitch[index]
                                                        .value,
                                                    userPlantMappedList: a,
                                                    userName:
                                                        EditfullName[index]
                                                            .text,
                                                  );
                                                } catch (e) {
                                                  // print(e);
                                                }
                                                await getSPOCList();
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                          buttonLabel2: "Cancel",
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                // Wrap(
                //   spacing: 8.0,
                //   runSpacing: 5.0,
                //   children: [
                //     SizedBox(
                //       width: 110,
                //       child: button(
                //           btnText: "Add SPOC",
                //           tapFunction: () async {
                //             showDialog(
                //               context: context,
                //               builder: (BuildContext context) {
                //                 return CustomPopup(
                //                   title: "Add New SPOC",
                //                   columnChildrens: [
                //                     Wrap(
                //                       spacing: 8.0,
                //                       runSpacing: 5.0,
                //                       children: [
                //                         customTextField(
                //                             label: "SPOC Name",
                //                             hint: "Firstname Lastname",
                //                             controller: fullName),
                //                         // const SizedBox(height: 16.0),
                //                         customTextField(
                //                             label: "Phone Number",
                //                             hint: "9898989898",
                //                             controller: mobileNo),

                //                         // const SizedBox(height: 16.0),
                //                         customTextField(
                //                             label: "Email Id",
                //                             hint: "something@gmail.com",
                //                             controller: emailID),
                //                       ],
                //                     ),
                //                     const SizedBox(
                //                       height: 16,
                //                     ),
                //                     buildPlantGrid(),
                //                     // Checkbox(value: is, onChanged: onChanged)
                //                     Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.start,
                //                       children: [
                //                         const SizedBox(
                //                           width: 25,
                //                         ),
                //                         Column(
                //                           children: [
                //                             const Text(
                //                               "Active",
                //                               style: TextStyle(
                //                                   color: Color(0xff616161)),
                //                             ),
                //                             Row(
                //                               children: [
                //                                 const Text(
                //                                   "No",
                //                                   style: TextStyle(
                //                                     color: Colors.black,
                //                                     fontWeight: FontWeight.w100,
                //                                     fontFamily: "Roboto",
                //                                   ),
                //                                 ),
                //                                 ValueListenableBuilder<bool>(
                //                                   valueListenable:
                //                                       activeValNotifier,
                //                                   builder:
                //                                       (context, value, child) {
                //                                     return Switch(
                //                                       value: value,
                //                                       onChanged: (newValue) {
                //                                         setState(() {
                //                                           activeValNotifier
                //                                               .value = newValue;
                //                                         });
                //                                       },
                //                                       activeTrackColor:
                //                                           ColorConstant.redbar,
                //                                       inactiveTrackColor:
                //                                           Colors.grey,
                //                                       inactiveThumbColor:
                //                                           Colors.white,
                //                                     );
                //                                   },
                //                                 ),
                //                                 const Text(
                //                                   "Yes",
                //                                   style: TextStyle(
                //                                     color: Colors.black,
                //                                     fontWeight: FontWeight.w100,
                //                                     fontFamily: "Roboto",
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ],
                //                         )
                //                       ],
                //                     ),
                //                   ],
                //                   buttonWidget: button(
                //                       btnText: "Add",
                //                       tapFunction: () async {
                //                         if (emailID.text.isEmpty ||
                //                             mobileNo.value.text.isEmpty ||
                //                             fullName.text.isEmpty) {
                //                           showDialog(
                //                             context: context,
                //                             builder: (context) {
                //                               return AlertDialog(
                //                                 title:
                //                                     const Text('Invalid Input'),
                //                                 content: const Text(
                //                                     'Please fill all fields.'),
                //                                 actions: <Widget>[
                //                                   TextButton(
                //                                     onPressed: () {
                //                                       Navigator.of(context)
                //                                           .pop();
                //                                     },
                //                                     child: const Text('OK'),
                //                                   ),
                //                                 ],
                //                               );
                //                             },
                //                           );
                //                           return;
                //                         }
                //                         if (mobileNo.value.text.length != 10) {
                //                           showDialog(
                //                             context: context,
                //                             builder: (context) {
                //                               return AlertDialog(
                //                                 title:
                //                                     const Text('Invalid Input'),
                //                                 content: const Text(
                //                                     'Please enter a valid Mobile Number'),
                //                                 actions: <Widget>[
                //                                   TextButton(
                //                                     onPressed: () {
                //                                       Navigator.of(context)
                //                                           .pop();
                //                                     },
                //                                     child: const Text('OK'),
                //                                   ),
                //                                 ],
                //                               );
                //                             },
                //                           );
                //                           return;
                //                         }
                //                         if (!isEmailValid(emailID.value.text)) {
                //                           showDialog(
                //                             context: context,
                //                             builder: (context) {
                //                               return AlertDialog(
                //                                 title:
                //                                     const Text('Invalid Input'),
                //                                 content: const Text(
                //                                     'Please enter a valid Email Address'),
                //                                 actions: <Widget>[
                //                                   TextButton(
                //                                     onPressed: () {
                //                                       Navigator.of(context)
                //                                           .pop();
                //                                     },
                //                                     child: const Text('OK'),
                //                                   ),
                //                                 ],
                //                               );
                //                             },
                //                           );
                //                           return;
                //                         }

                //                         List<Map<String, String>> a = [];

                //                         for (int i = 0;
                //                             i < selectedPlants.length;
                //                             i++) {
                //                           Map<String, String> b = {};
                //                           b["plantCode"] = selectedPlants[i];
                //                           a.add(b);
                //                         }
                //                         Navigator.pop(context);
                //                         await addSPOCUser(
                //                           createdBy:
                //                               sp?.getString("employeeCode") ??
                //                                   "",
                //                           emailId: emailID.text,
                //                           mobileNumber: mobileNo.value.text,
                //                           roleId: 5,
                //                           roleName: "TRANSPORTER_STAFF",
                //                           stateName: "",
                //                           supplierCode: int.parse(sp!
                //                               .getString("employeeCode")
                //                               .toString()),
                //                           supplierName:
                //                               sp?.getString("name") ?? "",
                //                           status: activeValNotifier.value,
                //                           userPlantMappedList: a,
                //                           userName: fullName.text,
                //                         );

                //                         selectedPlants.clear();
                //                         fullName.clear();
                //                         mobileNo.clear();
                //                         emailID.clear();
                //                         setState(() {
                //                           getSPOCList();
                //                         });
                //                       }),
                //                   buttonLabel2: "Cancel",
                //                 );
                //               },
                //             );
                //           }),
                //     ),
                //   ],
                // )
             
              ],
            ],
          ),
        ),
      ),
    );
  }

  TableColumn buildTableColumn(List<SPOCUserList> value, int index) {
    List<UserPlant>? a = value[index].userPlantMappedList;
    String b = "";
    for (int i = 0; i < a!.length; i++) {
      if (i + 1 == a.length) {
        b = "$b${a[i].plantName}";
      } else {
        b = "$b${a[i].plantName}, ";
      }
    }
    return TableColumn(
      b,
      index: index,
    );
  }

  Widget buildPlantGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 38.0,
        runSpacing: 20.0,
        children: List.generate(
          avlList.length,
          (index) {
            String plantCode = avlList.keys.elementAt(index);
            String plantName = avlList.values.elementAt(index);

            return ValueListenableBuilder(
              valueListenable: plantCheckboxStates[index],
              builder: (BuildContext context, bool value, Widget? child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: value,
                      onChanged: (newValue) {
                        setState(() {
                          plantCheckboxStates[index].value = newValue ?? false;
                        });
                        if (plantCheckboxStates[index].value) {
                          selectedPlants.add(plantCode);
                        } else {
                          selectedPlants.remove(plantCode);
                        }
                        // print(selectedPlants.toString());
                      },
                    ),
                    Text(plantName),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  bool isEmailValid(String text) {
    // Regular expression for a simple email validation
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return emailRegex.hasMatch(text);
  }
}
