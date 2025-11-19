// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shreecement/features/biddingProcess/manualdiallotment_action_screen.dart';
import 'package:shreecement/features/biddingProcess/unlinked_deliveries.dart';
import 'package:shreecement/features/biddingprocesslogisitc/CancelStartBid.dart';
import 'package:shreecement/features/biddingprocesslogisitc/transporter_action_screen.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidTranspoter.dart';
import 'package:shreecement/features/biddingprocesslogisitc/startBidTimerScreen.dart';
import 'package:shreecement/features/biddingprocesslogisitc/startbid_logisticts_action.dart';
import 'package:shreecement/features/biddingprocesslogisitc/delink_logistics.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/screens/home_screen.dart';
import 'package:shreecement/features/common/screens/manage_users.dart';
import 'package:shreecement/features/common/screens/profile_page.dart';
import 'package:shreecement/features/common/screens/transporter_dashboard_screen.dart';
import 'package:shreecement/features/common/widgets/customdrawer.dart';
import 'package:shreecement/features/invoicing/transporter_invoicing/edit_fright_details.dart';
import 'package:shreecement/features/invoicing/transporter_invoicing/freightbill_transporter2.dart';
import 'package:shreecement/features/invoicing/transporter_invoicing/transporter_freight_bill.dart';
import 'package:shreecement/features/invoicing/transporter_invoicing/validate_freight_bill_transporter.dart';
import 'package:shreecement/features/invoicing/transporter_invoicing/view_frieght_bill_transporter.dart';
import 'package:shreecement/features/invoicing/transporter_invoicing/view_invoice_transporter.dart';
import 'package:shreecement/features/masterdata/screens/master_data_section.dart';
import 'package:shreecement/features/biddingProcess/manualdiallotment.dart';
import 'package:shreecement/features/preBidding/screens/pre_bidding_process.dart';
import 'package:shreecement/features/preBidding/screens/transporter_prebid/transporter_pre_bidding_process.dart';
import 'package:shreecement/features/preBidding/screens/transporter_prebid/transporter_pre_bidding_process2.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_action.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_linking.dart';
import 'package:shreecement/features/tokenMapping/screens/token_mapping_submit.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/utils/image_string.dart';
import 'package:shreecement/utils/styletextconstant.dart';

import '../../lr_gr_printing/screens/lr_gr_printing_screen1.dart';
import '../../lr_gr_printing/screens/lr_gr_printing_screen2.dart';
import '../../preBidding/screens/pre_bidding_process2.dart';
import '../../biddingProcess/start_bid_logistics.dart';


///home screeen for transporter and transporter staffs,
class HomeScreenTR extends StatefulWidget {
  const HomeScreenTR({super.key});

  @override
  State<HomeScreenTR> createState() => _HomeScreenTRState();
}

class _HomeScreenTRState extends State<HomeScreenTR> {
  final control = Get.put(Controller());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //linking pending
  List<Widget> screens = [
    const DashBoardScreen2(), //0
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

    //invoicing
    const TransporterFreightBill(), //25
    const ValidateFreightBillTransporter(), //26
    const ViewFrieghtBillTransporter(), //27
    const ViewInvoiceTransporter(), //28
    const FreightBill2Transporter(), //29

    const LrGrPrinting(), //30
    const LrGrPrintingScreen2(), //31

    const TransporterPreBiddingProcess(), //32
    const TransporterPreBidProcess2(), //33

    const EditFreightBillTransporter() //34
  ];

  @override
  Widget build(BuildContext context) {
    final username = sp?.getString("userName");

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
        /*MyCustomAppBar(openDrawer:() => openDrawer(), ),*/
        drawer: const CustomDrawer(),
        body: Stack(
          children: [
            Obx(() => screens.elementAt(control.currentIndex.value)),
             Obx(() => Visibility(
                visible: isOtherLinkLoading.value,
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
      ),
    );
  }

  void openDrawer() {
    Navigator.of(context).pop();

    //_scaffoldKey.currentState?.openDrawer();
  }
}
