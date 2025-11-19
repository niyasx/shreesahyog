import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/tokenMapping/api/token_mapping_apis.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../common/controller/controller.dart';

class TokenMapping extends StatefulWidget {
  const TokenMapping({super.key});

  @override
  State<TokenMapping> createState() => _TokenMappingState();
}

class _TokenMappingState extends State<TokenMapping> {
  final control = Get.put(Controller());
  RxBool loaderScreen = false.obs;

  List<TokenMappingResponseList> originalTokenList = [];

  ValueNotifier<List<TokenMappingResponseList>> tokenMappingListResponseList =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    fetchPreBidList();
  }

  fetchPreBidList() async {
    loaderScreen.value = true;
    final TokenMappingModel response =
        await TokenMappingApi().getTokenMapingDiList(ctx: context);
    loaderScreen.value = false;
    originalTokenList = response.responseList ?? [];
    tokenMappingListResponseList.value = List.from(originalTokenList);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      tokenMappingListResponseList.value = List.from(originalTokenList);
      return;
    }

    List<TokenMappingResponseList> filteredData = originalTokenList
        .where((value) =>
            value.plantId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.division
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    tokenMappingListResponseList.value = filteredData;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      appBarText: "Token Mapping",
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await fetchPreBidList();
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tableHeading(heading: "Organisation List"),
                  searchBar(
                      size: size.width,
                      onChanged: (value) {
                        filterData(value);
                      }),
                  ValueListenableBuilder(
                    valueListenable: tokenMappingListResponseList,
                    builder: (BuildContext context,
                        List<TokenMappingResponseList> value, Widget? child) {
                      if (value.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text("No data found"),
                          ),
                        );
                      }
                      return Container(
                        color: Colors.grey.shade200,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Sr.No",
                                        flx: 1,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Org Code",
                                        flx: 3,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Organisation Name",
                                        flx: 5,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Division",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Deliveries Awarded",
                                        flx: 3,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Actions",
                                        flx: 2,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                  ],
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: value.length,
                                    itemBuilder: (_, index) {
                                      Color clr;
                                      index % 2 != 0
                                          ? clr = const Color(0xffF6F6F6)
                                          : clr = Colors.white;
                                      return Row(
                                        children: [
                                          column(
                                            colColor: clr,
                                            columnTitle: "${index + 1}",
                                            flx: 1,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                                value[index].plantId.toString(),
                                            flx: 3,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                                value[index].plantName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                                value[index].division ?? "",
                                            flx: 4,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            selectable: false,
                                            colColor: clr,
                                            columnTitle: value[index]
                                                .diNumber
                                                .toString(),
                                            flx: 3,
                                            clr: ColorConstant.redbar,
                                            funx: () {
                                              try {
                                                sp?.setString("plantId",
                                                    "${value[index].plantId}");
                                                control.currentIndex.value = 18;
                                              } catch (e) {
                                                // print("error $e");
                                              }
                                            },
                                          ),
                                          imgCell(
                                              tapAction: () {
                                                try {
                                                  sp?.setString("plantId",
                                                      "${value[index].plantId}");
                                                  control.currentIndex.value =
                                                      18;
                                                } catch (e) {
                                                  // print("error $e");
                                                }
                                              },
                                              colColor: clr,
                                              imgPath:
                                                  "assets/images/searchicon.png",
                                              icnClr: Colors.indigo,
                                              icnSize: 16,
                                              flx: 2),
                                        ],
                                      );
                                    }),
                                vSpace(15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable:
                                            tokenMappingListResponseList,
                                        builder: (BuildContext context,
                                            List<TokenMappingResponseList>
                                                value,
                                            Widget? child) {
                                          if (value.isEmpty) {
                                            return Center(child: Container());
                                          }
                                          return Expanded(
                                            flex: 2,
                                            child: Text(
                                                "Showing 1 to ${value.length} of ${value.length} entries",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable:
                                            tokenMappingListResponseList,
                                        builder: (BuildContext context,
                                            List<TokenMappingResponseList>
                                                value,
                                            Widget? child) {
                                          if (value.isEmpty) {
                                            return Center(child: Container());
                                          } else if (value.length <= 10) {
                                            return Row(
                                              children: [
                                                navBox(
                                                    boxWidth: 25,
                                                    text: "1",
                                                    txtClr: Colors.white,
                                                    bgClr:
                                                        ColorConstant.redbar),
                                              ],
                                            );
                                          } else if (value.length <= 20) {
                                            return Row(
                                              children: [
                                                navBox(
                                                    boxWidth: 25,
                                                    text: "1",
                                                    txtClr: Colors.white,
                                                    bgClr:
                                                        ColorConstant.redbar),
                                                navBox(
                                                    boxWidth: 25,
                                                    text: "2",
                                                    txtClr:
                                                        ColorConstant.redbar),
                                              ],
                                            );
                                          } else if (value.length <= 30) {
                                            Row(
                                              children: [
                                                navBox(
                                                    boxWidth: 25,
                                                    text: "1",
                                                    txtClr: Colors.white,
                                                    bgClr:
                                                        ColorConstant.redbar),
                                                navBox(
                                                    boxWidth: 25,
                                                    text: "2",
                                                    txtClr:
                                                        ColorConstant.redbar),
                                                navBox(
                                                    boxWidth: 25,
                                                    text: "3",
                                                    txtClr:
                                                        ColorConstant.redbar),
                                              ],
                                            );
                                          }
                                          return Row(
                                            children: [
                                              navBox(
                                                  boxWidth: 70,
                                                  text: "Previous"),
                                              navBox(
                                                  boxWidth: 25,
                                                  text: "1",
                                                  txtClr: Colors.white,
                                                  bgClr: ColorConstant.redbar),
                                              navBox(
                                                  boxWidth: 25,
                                                  text: "2",
                                                  txtClr: ColorConstant.redbar),
                                              navBox(
                                                  boxWidth: 25,
                                                  text: "3",
                                                  txtClr: ColorConstant.redbar),
                                              navBox(
                                                  boxWidth: 50,
                                                  text: "Next",
                                                  txtClr: ColorConstant.redbar),
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Obx(() => Visibility(
                visible: loaderScreen.value,
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
