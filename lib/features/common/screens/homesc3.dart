import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
import 'package:shreecement/features/common/widgets/customdrawer.dart';
import 'package:shreecement/features/masterdata/screens/master_data_section.dart';
import 'package:shreecement/features/biddingProcess/manualdiallotment.dart';
import 'package:shreecement/features/preBidding/screens/pre_bidding_process.dart';
import 'package:shreecement/features/super_admin/view/district_mapping.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_action.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_linking.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_submit.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/utils/image_string.dart';
import 'package:shreecement/utils/styletextconstant.dart';

import '../../preBidding/screens/pre_bidding_process2.dart';
import '../../biddingProcess/start_bid_logistics.dart';
import '../../super_admin/view/bid_report.dart';
///admin and super admin dashboard
class HomeScreen3 extends StatefulWidget {
  const HomeScreen3({super.key});

  @override
  State<HomeScreen3> createState() => _HomeScreen3State();
}

class _HomeScreen3State extends State<HomeScreen3> {
  final control = Get.put(Controller());

  //linking pending
  List<Widget> screens = [
    //0
    const ManageUsers(),
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
    const StartBidLogisticsActionScreen(),
    const ProfilePage(), //23
    const DelinkLogistics(), //24
    const DistrictMapping(), //25
    const BidReports() //26
  ];

  @override
  Widget build(BuildContext context) {
    final username = sp?.getString("userName");
    return SafeArea(
      child: Scaffold(
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
        //appBar: const MyCustomAppBar(),
        body: Obx(() => screens.elementAt(control.currentIndex.value)),
      ),
    );
  }
}

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

Widget customContainer({String? title, Widget? image}) {
  return Container(
    width: 285,
    height: 243,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black38,
          strokeAlign: 1,
        )),
    child: Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            const SizedBox(
              width: 26,
            ),
            Text(
              title ?? "title",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 29,
        ),
        Row(
          children: [
            const SizedBox(
              width: 79,
            ),
            image!
          ],
        )
      ],
    ),
  );
}
