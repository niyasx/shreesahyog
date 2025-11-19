import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/controller/mobile_number.dart';
import 'package:shreecement/features/common/models/plant_list_model.dart';
import 'package:shreecement/features/common/models/usersModel.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/widgets/custom_popup_menu.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/common/widgets/snackbar.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import 'package:shreecement/features/preBidding/api/division_list_by_plant.dart';
import 'package:shreecement/features/preBidding/apiModels/divisionResponse.dart';
import 'package:shreecement/features/super_admin/model/get_role_master_details_list.dart';
import 'package:shreecement/global.dart';
import '../../../main.dart';
import '../../common/controller/controller.dart';
import '../../common/table/table_widgets.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../super_admin/api/state_api.dart';
import '../widgets/customdropdownprebid.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final control = Get.put(Controller());
  RxBool isLoading = false.obs;
  RxInt currentPagination = 1.obs;
  String searchValue = "";

  int dropDownCount = 10;
  List<String> rowCount = ["10", "20", "30"];
  String selectedVal = "";
  int inc_index = 0;

  int selectedIndex = 1;

  Color previousClr = ColorConstant.redbar;

  int noOfPages = 0;

  int listViewTopIndex = 0;

  int displayNo = 1;

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    selectedVal = rowCount.elementAt(0);
    fetchPreBidList();
    getUsersFromAPI();
    callRoleMasterApi();
  }

  List<UsersModel> userData = [];
  ValueNotifier<List<UsersModel>> userDataLength = ValueNotifier([]);
  ValueNotifier<List<UsersModel>> userData1 = ValueNotifier([]);

  List<PlantListAdminResponseList> originalProfileList = [];
  ValueNotifier<List<PlantListAdminResponseList>> profileResponseList =
      ValueNotifier([]);
  List<ValueNotifier<bool>> plantCheckboxStates = [];
  // List<List<ValueNotifier<bool>>> plantCheckboxStatesList = [];
  List<String> selectedPlantsstr = [];
  late Map<String, String> avlList = {};
  ValueNotifier<bool> activeValNotifier = ValueNotifier(false);
  // List<int> selectedPlants = [];
  List<List<String>> EditselectedPlants = [];
  List<List<ValueNotifier<bool>>> plantCheckboxStatesList = [];
  ValueNotifier<bool> isActive = ValueNotifier<bool>(false);
  ValueNotifier<bool> hasReportAccess = ValueNotifier<bool>(false);
  bool hasReportAccessToggleEnabled = true;
  bool isActiveToggleEnabled = true;
  bool showReportAccess = false;
  Map<String, bool> selectedPlants = {};  //Map to store selected plants


  List<ValueNotifier<bool>> statusSwitch = [];
  List<ValueNotifier<bool>> reportSwitch = [];
  String? selectedValue;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = MobileTextEditingController();
  TextEditingController employeeCodeController = MobileTextEditingController();
  TextEditingController userTypeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  RxList<RoleMasterDetailsList> rxRoleMasterList = RxList();
  RxList<PlantListAdminResponseList> rxPlantList = RxList();


  fetchPreBidList() async {
    isLoading.value = true;
    final PlantListModelAdmin response = await getAllPlantList(context);
    isLoading.value = false;
    originalProfileList = response.responseList ?? [];
    if(rxPlantList.isNotEmpty){
      rxPlantList.clear();
    }
    //if all plants have same divisions checkboxes
    // var divisionList = <DivisionList1>[];
    // divisionList..add(DivisionList1(divisionName: "Cement",isDivisionSelected: false)
    // )..add(DivisionList1(divisionName: "Clinker",isDivisionSelected: false))
    //   ..add(DivisionList1(divisionName: "AACB",isDivisionSelected: false));

     rxPlantList..addAll(response.responseList!)..refresh();
    for(var obj3 in rxPlantList ){
      if (obj3.plantName == "SCL-UPGU AAC") {
        // All 3 divisions for this plant
        obj3.divisionList = [
          DivisionList1(divisionName: "Cement", isDivisionSelected: false),
          DivisionList1(divisionName: "Clinker", isDivisionSelected: false),
          DivisionList1(divisionName: "AACB", isDivisionSelected: false),
        ];
      } else {
        // only 2 divisions for others
        obj3.divisionList = [
          DivisionList1(divisionName: "Cement", isDivisionSelected: false),
          DivisionList1(divisionName: "Clinker", isDivisionSelected: false),
        ];
      }
      // obj3.divisionList = divisionList.map((e) => DivisionList1(
      //   divisionName: e.divisionName,
      //   isDivisionSelected: e.isDivisionSelected,
      // )).toList();
    }
    for (var plant in rxPlantList) {
      debugPrint('Plant: ${plant.plantName} (${plant.plantCode})');
      for (var division in plant.divisionList!) {
        debugPrint('  - Division: ${division.divisionName}, isSelected: ${division.isDivisionSelected}');
      }
    }
    profileResponseList.value = List.from(originalProfileList);
    for (int i = 0; i < profileResponseList.value.length; i++) {
      avlList[profileResponseList.value[i].plantCode.toString()] =
          profileResponseList.value[i].plantName.toString();
      plantCheckboxStates.add(ValueNotifier(false));
      statusSwitch
          .add(ValueNotifier(profileResponseList.value[i].status ?? false));
    }

  }




  void callRoleMasterApi() async {
    isLoading.value = true;
    var list = await StateApi().getRoleMasterDetails(context);
    isLoading.value = false;
    // Create default "Select User Type" option
    var roleObj = RoleMasterDetailsList(roleName: 'Select User Type');
    // Filter the roles to only include LOGISTIC and MIS_USER
    var filteredRoles = list.roleMasterDetailsList!.where((role) =>
    role.roleName == "LOGISTIC" || role.roleName == "MIS_USER").toList();
    // Clear and rebuild the list with only filtered roles
    rxRoleMasterList
      ..clear()
      ..add(roleObj)
      ..addAll(filteredRoles)
      ..refresh();
    selectedValue = rxRoleMasterList[0].roleName!;
  }

  Future<dynamic> getAllPlantList(BuildContext ctx) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.https(domain, "/app/master/getallplants");
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

      final result = jsonDecode(res.body);
      // print(result);
      return PlantListModelAdmin.fromJson(result);
    } catch (e) {
      // print("error in tokenmap api $e");
    }
  }

  Future getUsersFromAPI() async {
    isLoading.value = true;
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/users/getusers";

    var res = await http.get(Uri.parse(url), headers: {
      "Authorization":"Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    isLoading.value = false;

    statusSwitch.clear();
    reportSwitch.clear();
    EditselectedPlants.clear();
    plantCheckboxStatesList.clear();
    userData.clear();

    userData = [];
    // for (Map i in result) {
    //   userData.add(UsersModel.fromJson(i));
    //   reportSwitch.add(ValueNotifier(i['reportAccess'] ?? false));
    //
    // }
    for (Map i in result) {
      userData.add(UsersModel.fromJson(i as Map<String, dynamic>));
      reportSwitch.add(ValueNotifier(i['reportAccess'] ?? false));
      // debugPrint('Loaded ${userData.length} users with report switches');
      // for (int i = 0; i < userData.length; i++) {
      //   debugPrint('User ${userData[i].userName}: ${userData[i]
      //       .status} - Report Access: ${reportSwitch[i].value}');
      // }
    }
    userDataLength.value = userData;
    filterData(searchValue);
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);

  List<UsersModel> getCurrentPageItems(
      List<UsersModel> items, int currentPage) {
    userDataLength.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<UsersModel> temp = items.sublist(startIndex, endIndex);
    statusSwitch.clear();
    EditselectedPlants.clear();
    plantCheckboxStatesList.clear();
    // userData.clear();
    for (int i = 0; i < temp.length; i++) {
      // userData.add(items[i]);
      statusSwitch.add(ValueNotifier(temp[i].status ?? false));
      // reportSwitch.add(ValueNotifier(temp[i].reportAccess ?? false));
      reportSwitch = List.generate(temp.length, (i) =>
          ValueNotifier(temp[i].reportAccess ?? false));

      EditselectedPlants.add([]);
      for (int k = 0; k < temp[i].userPlantMappedList!.length; k++) {
        EditselectedPlants[i]
            .add(temp[i].userPlantMappedList![k].plantCode.toString());
      }

      plantCheckboxStatesList
          .add(List.generate(avlList.length, (j) => ValueNotifier(false)));
    }
    return temp;
  }

//filter data
  void filterData(String searchTerm) {
    if (searchTerm.trim().isEmpty) {
      userData1.value = getCurrentPageItems(userData, currentPage);
    }

    // Use the searchTerm to filter the userData list
    List<UsersModel> filteredData = userData
        .where((user) =>
            // user.status.toLowerCase().contains(searchTerm.toLowerCase())||
    (user.userName ?? '').toLowerCase().contains(searchTerm.toLowerCase()) ||
        (user.roleName ?? '').toLowerCase().contains(searchTerm.toLowerCase()) ||
        (user.employeeName ?? '').toLowerCase().contains(searchTerm.toLowerCase()) ||
        (user.mobileNumber ?? '').toLowerCase().contains(searchTerm.toLowerCase()) ||
        (user.employeeCode ?? '').toString().contains(searchTerm.toLowerCase()))
        .toList();
    // Update the displayed data
    userData1.value = getCurrentPageItems(filteredData, currentPage);
  }

  //delete user API
  Future<List<UsersModel>> deleteUser(
      {required String userEmail, required String userCode}) async {
        String? token = await secureStorage.read("token");
    final http.Response response = await http.delete(
      Uri.parse("$baseUrl/users/onboard-user"),
      headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
        "emailId": userEmail,
        "employeeCode": userCode,
      },
    );

    final result = jsonDecode(response.body);

    userData = [];
    for (Map i in result) {
      userData.add(UsersModel.fromJson(i as Map<String, dynamic>));  //changes, expects a Map<String, dynamic>.
    }

    userData1.value = getCurrentPageItems(userData, currentPage);

    return userData1.value;
  }

  ///updating the Plant and Division list
  List<Map<String, Object>> generateUserPlantMappedList() {
    return rxPlantList
        .where((plant) => plant.isPlantSelected == true)
        .map((plant) => {
      "plantCode": plant.plantCode.toString(),
      "divisionList": plant.divisionList
          ?.where((division) => division.isDivisionSelected == true)
          .map((e) => e.divisionName!)
          .toList() ??
          []
    })
        .toList();
  }

  ///validation for division & plant checkboxes
  bool validatePlantDivisionSelection() {
    bool hasInvalidSelection = false;
    bool hasPlantWithoutDivision = false;

    for (var plant in rxPlantList) {
      // Check if any division is selected while plant is not selected
      if (plant.divisionList != null &&
          plant.divisionList!.any((division) => division.isDivisionSelected == true) &&
          plant.isPlantSelected != true) {
        hasInvalidSelection = true;
      }

      // Check if plant is selected but no divisions are selected
      if (plant.isPlantSelected == true &&
          (plant.divisionList == null ||
              !plant.divisionList!.any((division) => division.isDivisionSelected == true))) {
        hasPlantWithoutDivision = true;
      }
    }

    if (hasInvalidSelection) {
      buildSnackBar("Message", "Cannot update user: Please choose plant for the selected divisions");
      return false;
    }

    if (hasPlantWithoutDivision) {
      buildSnackBar("Message", "Please select at least one division for the selected plant(s).");
      return false;
    }

    return true;
  }

  void updateStatus({
    required String? userName,
    required String? mobileNumber,
    required String? emailId,
    required bool status,
    required String? roleName,
    required int? roleId,
    required String? stateName,
    required String? districtName,
    required String? cityName,
    required String? postalCode,
    required String employeeCode,
    required String? employeeName,
    required String? createdBy,
    required String? updatedBy,
    required int? supplierCode,
    required String? supplierName,
    required int? staffCode,
    required List<Map<String, Object>> userPlantMappedList,
  }) async {
    try {
      // final queryParameters = {
      //   'empCode': userCode,
      //   'status': userStatus.toString(),
      // };
      String? token = await secureStorage.read("token");
      final uri = Uri.https(
        domain,
        "/app/users/update-user",
      );
      dynamic message = await http.patch(
        uri,
        body: jsonEncode(
            // {
            //   "userPlantMappedList": userPlantMappedList,
            //   'empCode': int.parse(userCode),
            //   'status': userStatus.toString(),
            // }
            {
              "userName": userName,
              "mobileNumber": mobileNumber,
              "emailId": emailId,
              "status": status,
              "roleName": roleName,
              "roleId": roleId,
              "stateName": stateName,
              "districtName": districtName,
              "cityName": cityName,
              "postalCode": postalCode,
              "employeeCode": employeeCode,
              "employeeName": employeeName,
              "createdBy": createdBy,
              "updatedBy": updatedBy,
              "supplierCode": supplierCode,
              "supplierName": supplierName,
              "staffCode": staffCode,
              "userPlantMappedList": userPlantMappedList
            }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      buildSnackBar("Message", (message.body ?? "").toString());
    } catch (e) {
      // print("jdbshdahjbdavdhv");
    }

    await getUsersFromAPI();
    setState(() {});
  }


  Future<void> saveUserDetails({
    required BuildContext ctx,
    required String roleName,
    required String employeeCode,
    required String userName,
    required String emailId,
    required String mobileNumber,
    required bool reportAccess,
    required bool isStatus,
    required List<String> selectedPlants,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final apiUrl = Uri.https(
        domain,
        "/app/master/saveUserDetails",
      );

      // Convert selectedPlants to List<int>
      List<int> plantCodeList = selectedPlants
          .map((plantCode) => int.tryParse(plantCode) ?? 0)
          // .where((code) => code != 0)
          .toList();
      // Determine misUser based on roleName
      bool misUser = roleName == "MIS_USER";

      // Construct the payload
      Map<String, dynamic> payload = {
        "roleName": roleName,
        "employeeCode": employeeCode,
        "employeeName": userName,
        "emailId": emailId,
        "mobileNumber": mobileNumber,
        "reportAccess": reportAccess,
        "status": isStatus,
        "plantCodeList": selectedPlants,
        "misUser": misUser,
        "update": true
      };

      final response = await http.post(
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String message = responseData["responseMessage"];

        // Show result dialog with message
        buildSnackBar("Message", message);

        // Close the dialog and refresh UI
        employeeCodeController.clear();
        nameController.clear();
        emailController.clear();
        mobileController.clear();
      } else {
        buildSnackBarAlert("Alert", "Failed to Update User");
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }

    await getUsersFromAPI();
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

  void submitUserDetails({required BuildContext ctx}) async {

    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.https(
        domain,
        "/app/master/saveUserDetails",
      );
      final plantCodes = selectedPlants.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();
      // Determine misUser value based on selectedValue
      bool misUser = selectedValue == "MIS_USER";
      // Make the API request
      dynamic response = await http.post(
        uri,
        body: jsonEncode({
          "roleName": selectedValue,
          "employeeCode": employeeCodeController.text,
          "employeeName": nameController.text,
          "emailId": emailController.text,
          "mobileNumber": mobileController.text,
          "reportAccess": hasReportAccess.value.toString(),
          "status": isActive.value.toString(),
          "plantCodeList": plantCodes,
          "misUser": misUser,  // Add this line
          "update": false
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },

      );

            final result = jsonDecode(response.body);

      if (ctx.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(ctx).pop();
        showResultDialog(result["responseMessage"], ctx);

      if (response.statusCode == 200 || result[response] == "201 CREATED") {

          print("Success: ${response.body}");
          // Clear input fields
          employeeCodeController.clear();
          nameController.clear();
          emailController.clear();
          mobileController.clear();
          // Show success message
        }
      } else {
        if (ctx.mounted) {
          Navigator.of(ctx).pop();
          showResultDialog(result["responseMessage"], ctx);
          // print("Failed: ${response.statusCode} - ${response.body}");
        }
        print("Failed: ${response.statusCode} - ${response.body}");
        // Handle API error
      }
    } catch (e) {
      print("Error: $e");
    }
    await getUsersFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width) * (100 / 7)) / 100;
    return CustomScaffold(
      appBarText: "Manage Users",
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await getUsersFromAPI();
        },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage Users",
                        style: TextStyle(fontFamily: 'RobotoLight', fontSize: 20),
                      ),
                      button(
                        btnText: "Add User",
                        tapFunction: () async {
                          isLoading.value = true; // Show loader

                          await Future.delayed(Duration(seconds: 1)); // Simulate API call

                          isLoading.value = false; // Hide loader and show popup

                          // Map to store selected plants, initializes selectedPlants with all plant codes set to false initially
                          selectedPlants = {
                            for (var plant in originalProfileList) plant.plantCode.toString(): false
                          };

                          employeeCodeController.clear();
                          nameController.clear();
                          emailController.clear();
                          mobileController.clear();
                          setState(() {
                            // Refresh data table or update user list API
                            selectedValue = null; // Reset dropdown selection
                            isActive.value = false; // Reset toggle button
                            hasReportAccess.value = false; // Reset report access toggle
                            isActiveToggleEnabled = true;
                            hasReportAccessToggleEnabled = true;
                            selectedPlants.updateAll((key, value) => false);
                          });

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return CustomPopup(
                                    title: "Enter User Detail",
                                    columnChildrens: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 20),
                                          Wrap(
                                            runSpacing: 10,
                                            spacing: 30,
                                            children: [

                                              // dropdown for logistic/transporter/MIS user code selection
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Select User Type',
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                  Container(
                                                    height: 32,
                                                    width: 283,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: const Color(0xffA0A0A0)),
                                                      borderRadius:
                                                      BorderRadius.circular(5.0),
                                                    ),
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton2<String>(
                                                        isDense: true,
                                                        isExpanded: true,
                                                        hint: const Text("Select User Type",
                                                            style: TextStyle(
                                                                color: Color(0xff727272),
                                                                overflow:
                                                                TextOverflow.ellipsis)
                                                        ),
                                                        value: selectedValue,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            selectedValue = newValue!;

                                                            if (selectedValue == "LOGISTIC") {
                                                              // Show only the "Active" toggle, set value to true & disable it
                                                              isActive.value = true;
                                                              hasReportAccess.value = false; // Hide Report Access
                                                              isActiveToggleEnabled = false;
                                                              hasReportAccessToggleEnabled = true;
                                                              // showReportAccess = false;
                                                            } else if (selectedValue == "MIS_USER") {
                                                              // Show both toggles, set both to true & disable them
                                                              isActive.value = true;
                                                              hasReportAccess.value = true;
                                                              isActiveToggleEnabled = false;
                                                              hasReportAccessToggleEnabled = false;
                                                              // showReportAccess = true;
                                                            } else {
                                                              // Default state
                                                              isActive.value = false;
                                                              hasReportAccess.value = false;
                                                              isActiveToggleEnabled = true;
                                                              hasReportAccessToggleEnabled = true;
                                                              // showReportAccess = false;
                                                            }
                                                          });
                                                        },
                                                        style: const TextStyle(
                                                          color: Color(0xff727272),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        items: rxRoleMasterList.map<DropdownMenuItem<String>>(
                                                              (RoleMasterDetailsList value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value.roleName,
                                                              child: Container(
                                                                height: 30,
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  value.roleName!,
                                                                  softWrap: true,
                                                                  textAlign: TextAlign.left,
                                                                  style: const TextStyle(
                                                                    color: Color(0xff727272),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: 'Roboto',
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                        dropdownSearchData: DropdownSearchData(
                                                          searchController: textEditingController,
                                                          searchInnerWidgetHeight: 50,
                                                          searchInnerWidget: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: TextFormField(
                                                              controller: textEditingController,
                                                              decoration: InputDecoration(
                                                                isDense: true,
                                                                contentPadding: const EdgeInsets.symmetric(
                                                                  horizontal: 10,
                                                                  vertical: 8,
                                                                ),
                                                                hintText: 'Search for an item...',
                                                                hintStyle: const TextStyle(fontSize: 12),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          searchMatchFn: (item, searchValue) {
                                                            return item.value
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(searchValue.toLowerCase());
                                                          },
                                                        ),
                                                        dropdownStyleData: const DropdownStyleData(
                                                          maxHeight: 300,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              customTextField(
                                                  label: "Employee Code",
                                                  controller: employeeCodeController,
                                                  hint: 'Enter Employee Code',
                                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // Custom Text Fields for User Details
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          runSpacing: 10,
                                          spacing: 30,
                                          children: [
                                            Row(
                                              children: [
                                                customTextField3(
                                                  label: "User Name",
                                                  controller: nameController,
                                                  hint: 'Enter Username',
                                                ),
                                                const SizedBox(width: 30),
                                                customTextField(
                                                    label: "Email",
                                                    controller: emailController,
                                                    hint: "Enter Email"
                                                ),
                                              ],
                                            ),

                                            // const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                customTextField(
                                                  label: "Mobile Number",
                                                  controller: mobileController,
                                                  hint: "Enter mobile no.",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Plant Selection Header
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 20),
                                          Text(
                                            "Select Plants",
                                            style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Checkbox List with Wrap Widget
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16.0),
                                        child: Wrap(
                                          spacing: 10.0,
                                          runSpacing: 5.0,
                                          children: originalProfileList.map((plant) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Checkbox(
                                                  value: selectedPlants[plant.plantCode.toString()] ?? false,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      selectedPlants[plant.plantCode.toString()] = value!;
                                                    });
                                                  },
                                                ),
                                                Text(plant.plantName.toString()),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Active",
                                                  style: TextStyle(color: Color(0xff616161)),
                                                ),
                                                Row(
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
                                                      valueListenable: isActive,
                                                      builder: (context, value, child) {
                                                        return Switch(
                                                          value: value,
                                                          onChanged: isActiveToggleEnabled ? (newValue) {
                                                            isActive.value = newValue;
                                                          } : null,
                                                          activeTrackColor: ColorConstant.redbar,
                                                          inactiveTrackColor: Colors.grey,
                                                          inactiveThumbColor: Colors.white,
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
                                              ],
                                            ),
                                            wSpace(20),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Report Access",
                                                  style: TextStyle(color: Color(0xff616161)),
                                                ),
                                                Row(
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
                                                      valueListenable: hasReportAccess,
                                                      builder: (context, value, child) {
                                                        return Switch(
                                                          value: value,
                                                          onChanged: hasReportAccessToggleEnabled ? (newValue) {
                                                            hasReportAccess.value = newValue;
                                                          } : null, //disable toggle from accessing
                                                          activeTrackColor: ColorConstant.redbar,
                                                          inactiveTrackColor: Colors.grey,
                                                          inactiveThumbColor: Colors.white,
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                    buttonWidget: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: button(
                                        btnText: "Submit",
                                        tapFunction: () {
                                          // if (mobileController.text.length != 10) {
                                          //   buildSnackBarAlert("Alert", "Mobile number must be 10 digits");
                                          //   return;
                                          // }
                                          //
                                          // if (!emailController.text.toLowerCase().endsWith("@shreecement.com")) {
                                          //   buildSnackBarAlert("Alert", "Email must be a valid @shreecement.com address");
                                          //   return;
                                          // }

                                          if (nameController.text.isEmpty ||
                                              employeeCodeController.text.isEmpty ||
                                              emailController.text.isEmpty ||
                                              mobileController.text.isEmpty || selectedValue == null){
                                            buildSnackBarAlert("Alert", "Please fill all required fields");
                                          }else if(!emailController.text.toLowerCase().endsWith("@shreecement.com")) {
                                            buildSnackBarAlert("Alert", "Email must be a valid @shreecement.com address");
                                            return;
                                          }else if (mobileController.text.length != 10) {
                                            buildSnackBarAlert("Alert", "Mobile number must be 10 digits");
                                            return;
                                          }else {
                                            submitUserDetails(ctx: context);
                                            // Navigator.pop(context);
                                            // setState(() {
                                            //   // Refresh data table or update user list API
                                            // });
                                          }
                                        },
                                      ),
                                    ),
                                    buttonLabel2: "Cancel",
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),

                    ],
                  ),



                  vSpace(20),
                  tableHeading(heading: "User List"),
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
                                              await getUsersFromAPI();
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
                                  width: 130,
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
                                          const EdgeInsets.symmetric(
                                              horizontal: 5),
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
                                    onChanged: (value) {
                                      filterData(value);
                                      searchValue = value;
                                    },
                                  ),
                                ),
                              ],
                            )),
                      )),
                    ],
                  ), //search bar

                  ValueListenableBuilder(
                    valueListenable: userData1,
                    builder: (BuildContext context, List<UsersModel> value,
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
                              width: 32,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Employee/Transporter Code",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Role",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Name",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Mobile No.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Email",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Organization",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Geography",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Status",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Actions",
                              heading: true,
                              width: dynamicSize,
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
                                    "${((currentPage - 1) * int.parse(selectedDropdownValue)) + index + 1}",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    value[index].employeeCode?.toString() ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    value[index].roleName ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    value[index].employeeName ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    value[index].mobileNumber ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    value[index].userName ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    textTrim: true,
                                    buildPlantNames(
                                        value[index].userPlantMappedList),
                                    // value[index].userName ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    "",
                                    // value[index].userName ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(SizedBox(
                                    // cell height

                                    height: dynamicSize,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4)),
                                                color: value[index].status ==
                                                        false
                                                    ? const Color(0xffFF2121)
                                                    : const Color(0xff1FC24E),
                                                /*? const Color(0xff1FC24E)
                                                            : const Color(0xffFF2121),*/
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                child: Text(
                                                  //value[index].status.toString(),
                                                  value[index].status == false
                                                      ? "INACTIVE"
                                                      : "ACTIVE",
                                                  style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                                DataCell(Container(
                                  height: dynamicSize,
                                  padding: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          // Assuming the first user in the list is the one being edited
                                          // UsersModel? selectedUser = userData.isNotEmpty ? userData.first : null


                                          ///this code is for \\\selecting the assigned plants
                                          // for (var obj in value[index].userPlantMappedList) {
                                          //   final matchedPlant = rxPlantList.firstWhere(
                                          //         (plant) => plant.plantCode == obj.plantCode,
                                          //     orElse: () => PlantListAdminResponseList(), // Avoids exception if no match
                                          //   );
                                          //
                                          //
                                          //   if (matchedPlant != null) {
                                          //     matchedPlant.isPlantSelected = true;
                                          //   }else{
                                          //     matchedPlant.isPlantSelected = false;
                                          //   }
                                          //   rxPlantList.refresh();
                                          //   for (var plant in rxPlantList) {
                                          //     print('Plant: ${plant.plantName} (${plant.isPlantSelected})');
                                          //     for (var division in plant.divisionList!) {
                                          //       print('  - Division: ${division.divisionName}, isSelected: ${division.isDivisionSelected}');
                                          //     }
                                          //   }
                                          // }
                                          // Reset all plant and division selections first
                                          for (var plant in rxPlantList) {
                                            plant.isPlantSelected = false;
                                            for (var division in plant.divisionList ?? []) {
                                              division.isDivisionSelected = false;
                                            }
                                          }

                                          // Now apply the new selections based on userPlantMappedList
                                          for (var obj in value[index].userPlantMappedList) {
                                            final matchedPlant = rxPlantList.firstWhereOrNull(
                                                  (plant) => plant.plantCode == obj.plantCode,
                                            );

                                            if (matchedPlant != null) {
                                              matchedPlant.isPlantSelected = true;

                                              // Update division selections
                                              for (var division in matchedPlant.divisionList ?? []) {
                                                if (obj.divisionList.contains(division.divisionName)) {
                                                  division.isDivisionSelected = true;
                                                }
                                              }
                                            }
                                          }

                                          // Refresh UI if rxPlantList is RxList
                                          rxPlantList.refresh();

                                          ///this code is for  division list
                                          for (var mappedPlant in value[index].userPlantMappedList) {
                                            final matchingPlant = rxPlantList.where((plant) => plant.plantCode == mappedPlant.plantCode).firstOrNull;

                                            if (matchingPlant != null) {
                                              matchingPlant.isPlantSelected = true;
                                              // debugPrint('✅ Plant selected: ${matchingPlant.plantName}');

                                              for (var divisionName in mappedPlant.divisionList ?? []) {
                                                final matchingDivision = matchingPlant.divisionList!
                                                    .where((d) => d.divisionName == divisionName)
                                                    .firstOrNull;

                                                if (matchingDivision != null) {
                                                  matchingDivision.isDivisionSelected = true;
                                                  // debugPrint('✅ Division selected: $divisionName in ${matchingPlant.plantName}');
                                                }
                                              }
                                            }
                                          }

                                          rxPlantList.refresh();

                                          emailController.text = value[index].emailId ?? "";
                                          userTypeController.text = value[index].roleName ?? "";
                                          nameController.text = value[index].employeeName ?? "";
                                          mobileController.text = value[index].mobileNumber ?? "";
                                          employeeCodeController.text = value[index].employeeCode.toString();

                                          if (value[index].roleName == "TRANSPORTER") {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomPopup(
                                                  title: "Edit",
                                                  columnChildrens: [
                                                    const Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          "Select Plants",
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "Roboto",
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Obx(() {
                                                      return Container(
                                                        height: 400,
                                                        child: Scrollbar(
                                                          thumbVisibility: true,
                                                          controller: _scrollController,
                                                          child: GridView.builder(
                                                            controller: _scrollController,
                                                            padding: EdgeInsets.all(8),
                                                            itemCount: rxPlantList.length,
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 4, // 3 items in a row
                                                              crossAxisSpacing: 1, // Reduce horizontal spacing
                                                              mainAxisSpacing: 0.5,  // Reduce vertical spacing
                                                              childAspectRatio: 1.0, // Adjust based on how tall you want each tile
                                                            ),
                                                            itemBuilder: (context, index) {
                                                              final plant = rxPlantList[index];
                                                              return Padding(
                                                                padding: const EdgeInsets.all(10),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    CheckboxListTile(
                                                                      value: plant.isPlantSelected ?? false, // 👈 null-safe
                                                                      title: Text(
                                                                        plant.plantName ?? '',
                                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                                      ),
                                                                      controlAffinity: ListTileControlAffinity.leading,
                                                                      onChanged: (val) {
                                                                        plant.isPlantSelected = val ?? false;

                                                                        // Select/unselect all divisions accordingly
                                                                        for (var division in plant.divisionList ?? []) {
                                                                          division.isDivisionSelected = plant.isPlantSelected;
                                                                        }
                                                                        rxPlantList.refresh();
                                                                      },
                                                                    ),
                                                                    // Divider(),
                                                                    Expanded(
                                                                      child: ListView.builder(
                                                                        itemCount: plant.divisionList?.length ?? 0,
                                                                        itemBuilder: (context, dIndex) {
                                                                          final division = plant.divisionList![dIndex];
                                                                          return CheckboxListTile(
                                                                            value: division.isDivisionSelected ?? false, // 👈 null-safe
                                                                            title: Text(division.divisionName ?? ''),
                                                                            controlAffinity: ListTileControlAffinity.leading,
                                                                            onChanged: (val) {
                                                                              division.isDivisionSelected = val ?? false;
                                                                              rxPlantList.refresh();
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }),
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
                                                                  style:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                    fontFamily:
                                                                    "Roboto",
                                                                  ),
                                                                ),
                                                                ValueListenableBuilder<
                                                                    bool>(
                                                                  valueListenable:
                                                                  statusSwitch[
                                                                  index],
                                                                  builder:
                                                                      (context,
                                                                      data,
                                                                      child) {
                                                                    return Switch(
                                                                      value: data,
                                                                      onChanged:
                                                                          (newValue) {
                                                                        setState(
                                                                                () {
                                                                              // print(
                                                                              //     newValue);

                                                                              statusSwitch[index].value =
                                                                                  newValue;
                                                                            });
                                                                      },
                                                                      activeTrackColor:
                                                                      ColorConstant
                                                                          .redbar,
                                                                      inactiveTrackColor:
                                                                      Colors
                                                                          .grey,
                                                                      inactiveThumbColor:
                                                                      Colors
                                                                          .white,
                                                                    );
                                                                  },
                                                                ),
                                                                const Text(
                                                                  "Yes",
                                                                  style:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w100,
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
                                                  buttonWidget: Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: button(
                                                        btnText: "Submit",
                                                        tapFunction: () async {
                                                          // List<
                                                          //     Map<String,
                                                          //         String>> a = [];
                                                          //
                                                          // for (int i = 0;
                                                          // i <
                                                          //     EditselectedPlants[
                                                          //     index]
                                                          //         .length;
                                                          // i++) {
                                                          //   Map<String, String>
                                                          //   b = {};
                                                          //   b["plantCode"] =
                                                          //   EditselectedPlants[
                                                          //   index][i];
                                                          //   a.add(b);
                                                          // }
                                                          // Validate plant and division selection
                                                          if (!validatePlantDivisionSelection()) {
                                                            // buildSnackBar("Error", "Cannot update user: Please select the plant for any selected divisions");
                                                            return;
                                                          }


                                                          updateStatus(
                                                              cityName: value[index]
                                                                  .cityName,
                                                              createdBy: value[index]
                                                                  .createdBy,
                                                              districtName:
                                                              value[index]
                                                                  .districtName,
                                                              emailId: value[index]
                                                                  .emailId ??
                                                                  "",
                                                              employeeName:
                                                              value[index].employeeName ??
                                                                  "",
                                                              mobileNumber:
                                                              value[index].mobileNumber ??
                                                                  "",
                                                              postalCode:
                                                              value[index]
                                                                  .postalCode,
                                                              roleId: value[index]
                                                                  .roleId,
                                                              roleName: value[index]
                                                                  .roleName,
                                                              staffCode: value[index]
                                                                  .staffCode,
                                                              stateName: value[index]
                                                                  .emailId,
                                                              supplierCode:
                                                              value[index]
                                                                  .supplierCode,
                                                              supplierName:
                                                              value[index]
                                                                  .supplierName,
                                                              updatedBy:
                                                              value[index]
                                                                  .updatedBy,
                                                              userName:
                                                              value[index]
                                                                  .userName,
                                                              userPlantMappedList: generateUserPlantMappedList(),
                                                              status: statusSwitch[index].value,
                                                              employeeCode: value[index].employeeCode.toString());
                                                          Navigator.pop(context);
                                                          setState(() {
                                                            // getUsersFromAPI();
                                                          });
                                                        }),
                                                  ),
                                                  buttonLabel2: "Cancel",
                                                );
                                              },
                                            );

                                          } else {
                                            // debugPrint('Index: $index, User: ${userData[index].userName}, Email: ${userData[index].emailId}, ReportAccess: ${userData[index].reportAccess}, Status: ${userData[index].status}');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState){
                                                    return CustomPopup(
                                                      title: "Edit",
                                                      columnChildrens: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(width: 20),
                                                            Wrap(
                                                              runSpacing: 10,
                                                              spacing: 20,
                                                              children: [


                                                                disabledCustomTextField(
                                                                    label: "User Type",
                                                                    controller: userTypeController,
                                                                    hint: "Logistic"
                                                                ),

                                                                customTextField(
                                                                  label: "Employee Code",
                                                                  controller: employeeCodeController,
                                                                  hint: 'Enter Employee Code',
                                                                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(height: 16),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                          child: Wrap(
                                                            alignment: WrapAlignment.start,
                                                            runSpacing: 10,
                                                            spacing: 30,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  customTextField3(
                                                                    label: "User Name",
                                                                    controller: nameController,
                                                                    hint: 'Enter Username',
                                                                  ),
                                                                  const SizedBox(width: 30),
                                                                  disabledCustomTextField(
                                                                      label: "Email",
                                                                      controller: emailController,
                                                                      hint: "email id"
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  customTextField(
                                                                    label: "Mobile Number",
                                                                    controller: mobileController,
                                                                    hint: "Enter mobile no.",
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(height: 16),

                                                        const Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Text(
                                                              "Select Plants",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  "Roboto",
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                          ],
                                                        ),

                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                          child: Wrap(
                                                            spacing: 10.0,
                                                            runSpacing: 10.0,
                                                            children:
                                                            List.generate(
                                                              avlList.length,
                                                                  (a) {
                                                                String plantCode =
                                                                avlList.keys
                                                                    .elementAt(
                                                                    a);
                                                                String plantName =
                                                                avlList.values
                                                                    .elementAt(
                                                                    a);

                                                                plantCheckboxStatesList[
                                                                index][a]
                                                                    .value =
                                                                    EditselectedPlants[
                                                                    index]
                                                                        .contains(
                                                                        plantCode);

                                                                return ValueListenableBuilder(
                                                                  valueListenable:
                                                                  plantCheckboxStatesList[
                                                                  index][a],
                                                                  builder: (
                                                                      BuildContext
                                                                      context,
                                                                      bool value,
                                                                      Widget?
                                                                      child) {
                                                                    // Set the initial value based on whether the plantCode is in EditselectedPlants

                                                                    return Row(
                                                                      mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                      children: [
                                                                        Checkbox(
                                                                          value:
                                                                          value,
                                                                          onChanged:
                                                                              (
                                                                              newValue) {
                                                                            setState(
                                                                                    () {
                                                                                  plantCheckboxStatesList[index][a]
                                                                                      .value =
                                                                                      newValue ??
                                                                                          false;
                                                                                });

                                                                            if (plantCheckboxStatesList[index][a]
                                                                                .value) {
                                                                              EditselectedPlants[index]
                                                                                  .add(
                                                                                  plantCode);
                                                                            } else {
                                                                              EditselectedPlants[index]
                                                                                  .remove(
                                                                                  plantCode);
                                                                            }
                                                                          },
                                                                        ),
                                                                        Text(
                                                                            plantName),
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
                                                                      style:
                                                                      TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w100,
                                                                        fontFamily:
                                                                        "Roboto",
                                                                      ),
                                                                    ),
                                                                    ValueListenableBuilder<
                                                                        bool>(
                                                                      valueListenable:
                                                                      statusSwitch[
                                                                      index],
                                                                      builder:
                                                                          (context,
                                                                          data,
                                                                          child) {
                                                                        return Switch(
                                                                          value: data,
                                                                          onChanged:
                                                                              (
                                                                              newValue) {
                                                                            setState(
                                                                                    () {
                                                                                  // print(
                                                                                  //     newValue);

                                                                                  statusSwitch[index]
                                                                                      .value =
                                                                                      newValue;
                                                                                });
                                                                          },
                                                                          activeTrackColor:
                                                                          ColorConstant
                                                                              .redbar,
                                                                          inactiveTrackColor:
                                                                          Colors
                                                                              .grey,
                                                                          inactiveThumbColor:
                                                                          Colors
                                                                              .white,
                                                                        );
                                                                      },
                                                                    ),
                                                                    const Text(
                                                                      "Yes",
                                                                      style:
                                                                      TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w100,
                                                                        fontFamily:
                                                                        "Roboto",
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            wSpace(20),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "Report Access",
                                                                  style: TextStyle(
                                                                    color: value[index].roleName == "LOGISTIC"
                                                                        ? Color(0xff616161)
                                                                        : Colors.grey,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "No",
                                                                      style: TextStyle(
                                                                        color: value[index].roleName == "LOGISTIC"
                                                                            ? Colors.black
                                                                            : Colors.grey,
                                                                        fontWeight: FontWeight.w100,
                                                                        fontFamily: "Roboto",
                                                                      ),
                                                                    ),
                                                                    ValueListenableBuilder<bool>(
                                                                      valueListenable: reportSwitch[index],
                                                                      builder: (context, value, child) {
                                                                        bool isToggleEnabled = userData1.value[index].roleName == "LOGISTIC";

                                                                        return Switch(
                                                                          value: isToggleEnabled ? value : true, // Force true for MIS_USER
                                                                          onChanged: isToggleEnabled
                                                                              ? (newValue) => reportSwitch[index].value = newValue
                                                                              : null,
                                                                          activeTrackColor: ColorConstant.redbar,
                                                                          inactiveTrackColor: Colors.grey,
                                                                          inactiveThumbColor: Colors.white,
                                                                        );
                                                                      },
                                                                    ),
                                                                    /*ValueListenableBuilder<bool>(
                                                                      valueListenable: reportSwitch[index],
                                                                      builder: (context, data, child) {
                                                                        return Switch(
                                                                          value: data,
                                                                          onChanged:(newValue) {
                                                                            // reportSwitch[index].value = newValue;
                                                                            setState((){
                                                                              reportSwitch[index].value = newValue;
                                                                            });
                                                                          },
                                                                          activeTrackColor: ColorConstant.redbar,
                                                                          inactiveTrackColor: Colors.grey,
                                                                          inactiveThumbColor: Colors.white,
                                                                        );
                                                                      },
                                                                    ),*/
                                                                    Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                        color: value[index].roleName == "LOGISTIC"
                                                                            ? Colors.black
                                                                            : Colors.grey,
                                                                        fontWeight: FontWeight.w100,
                                                                        fontFamily: "Roboto",
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                      buttonWidget: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: button(
                                                            btnText: "Submit",
                                                            tapFunction: () async {
                                                              List<
                                                                  Map<String,
                                                                      String>> a = [
                                                              ];

                                                              for (int i = 0;
                                                              i <
                                                                  EditselectedPlants[
                                                                  index]
                                                                      .length;
                                                              i++) {
                                                                Map<String, String>
                                                                b = {};
                                                                b["plantCode"] =
                                                                EditselectedPlants[
                                                                index][i];
                                                                a.add(b);
                                                              }

                                                              // await updateUserDetails(context, index);
                                                              if(mobileController.text.length!= 10){
                                                                buildSnackBarAlert("Alert", "Mobile number must be 10 digits");
                                                                return;
                                                              }
                                                              if(employeeCodeController.text.isEmpty ||
                                                                  nameController.text.isEmpty ||
                                                                  mobileController.text.isEmpty){
                                                                buildSnackBarAlert("Alert", "All fields are required to filled");
                                                              }else {
                                                                saveUserDetails(
                                                                  ctx: context,
                                                                  roleName: userTypeController
                                                                      .text,
                                                                  employeeCode: employeeCodeController
                                                                      .text,
                                                                  userName: nameController
                                                                      .text,
                                                                  emailId: emailController
                                                                      .text,
                                                                  mobileNumber: mobileController
                                                                      .text,
                                                                  // reportAccess: reportSwitch[index].value,
                                                                  reportAccess: value[index].roleName == "MIS_USER"
                                                                      ? true  // Force true for MIS_USER
                                                                      : reportSwitch[index].value, // Use toggle value for LOGISTIC
                                                                  isStatus: statusSwitch[index]
                                                                      .value,
                                                                  selectedPlants: EditselectedPlants[index],
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  // getUsersFromAPI();
                                                                });
                                                              }
                                                            }),
                                                      ),
                                                      buttonLabel2: "Cancel",
                                                    );

                                                  },
                                                );
                                              },
                                            );
                                          }

                                        },
                                        child: Image.asset(
                                          "assets/images/editicon.png",
                                          height: 16,
                                          width: 16,
                                        ),
                                      ),
                                      wSpace(5),
                                      InkWell(
                                        onTap: () {
                                          //delete user
                                          deleteUser(
                                              userEmail: value[index]
                                                  .emailId
                                                  .toString(),
                                              userCode: value[index]
                                                  .employeeCode
                                                  .toString());
                                          setState(() {});
                                        },
                                        child: Image.asset(
                                          "assets/images/deleteicon.png",
                                          height: 16,
                                          width: 16,
                                        ),
                                      ),
                                      wSpace(5),
                                      Image.asset(
                                        "assets/images/sms.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      wSpace(5),
                                      Image.asset(
                                        "assets/images/mail.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Row(
                      children: [
                        size.width > 600
                            ? ValueListenableBuilder(
                                valueListenable: userData1,
                                builder: (BuildContext context,
                                    List<UsersModel> value, Widget? child) {
                                  return Expanded(
                                    flex: 1,
                                    child: Text(
                                        "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${userDataLength.value.length} entries",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal)),
                                  );
                                },
                              )
                            : Container(),
                        size.width > 600
                            ? const SizedBox(
                                width: 20,
                              )
                            : Container(),
                        buildValueListenableBuilder()
                      ],
                    ),
                  ),
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

  String buildPlantNames(List<UserPlantMappedList>? userPlantMappedList) {
    if (userPlantMappedList == null || userPlantMappedList.isEmpty) {
      return "No Plants";
    }

    return userPlantMappedList.map((plant) => plant.plantName ?? "").join(", ");
  }

  Widget radioActionBtn(
      {required String txt, VoidCallback? tapAction, Color? txtClr}) {
    txtClr ?? txtClr == ColorConstant.redbar;
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: tapAction,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xff727272),
              width: 0.5,
            ),
            color: const Color(0xffFFFFFF)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Center(
            child: Text(
              txt,
              style:
                  TextStyle(fontSize: 12, color: txtClr, fontFamily: 'Roboto'),
            ),
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<List<UsersModel>> buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: userDataLength,
      builder: (BuildContext context, List<UsersModel> value, Widget? child) {
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

          return Row(
            children: pageWidgets,
          );
        });
      },
    );
  }
}
