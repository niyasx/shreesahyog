import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/common/models/other_link_response_model.dart';
import 'package:shreecement/features/common/screens/dashboard_screen2.dart';
import 'package:shreecement/features/common/widgets/customdrawer.dart';
import 'package:shreecement/features/login/screens/login_screen.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/features/common/screens/home_screen.dart';
import 'package:shreecement/utils/image_string.dart';
import 'package:universal_html/html.dart' as html;


class TransportOptionScreen extends StatefulWidget {
  const TransportOptionScreen({Key? key}) : super(key: key);

  @override
  State<TransportOptionScreen> createState() => _TransportOptionScreenState();
}

class _TransportOptionScreenState extends State<TransportOptionScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Add listener for page refresh/reload
       _setupBrowserBackButtonHandling();
    
    // Check if transport option has already been selected
    final transportType = sp?.getString("transportType");
    
    if (transportType != null) {
      // User has already made a selection, navigate accordingly
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (transportType == "Outbound") {
          Get.off(() => const HomeScreenTR());
        } else if (transportType == "Inbound") {
          // For inbound, call the API
          _handleInboundSelection();
        }
      });
    }
  }

void _setupBrowserBackButtonHandling() {
    // Add a history entry to the browser
    html.window.history.pushState({}, '', html.window.location.href);
    
    // Listen for browser back button
    html.window.onPopState.listen((event) {
      // When browser back button is pressed, we push another state to prevent
      // actual navigation, and then handle the navigation within our app
      html.window.history.pushState({}, '', html.window.location.href);
      
      // Clear transport type
      sp?.remove("transportType");
      logout();
      
      // Navigate back to login screen
      Get.offAll(() => LoginScreen());
    });
  }
  

  // Handle the inbound selection and API call
  Future<void> _handleInboundSelection() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Call the customerPortApi for inbound
      await inboundPortalApi(
        ctx: context,
      );
    } catch (e) {
      // Show error if API call fails
      if (mounted) {
        showErrorDialogue("Failed to load inbound portal: $e", context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  
  Future<dynamic> inboundPortalApi({
    required BuildContext ctx,
  }) async {
    String url = "$baseUrl/users/getApp";
    try {
      isOtherLinkLoading.value = true;
      String? token = await secureStorage.read("token");
      var res = await http.post(
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
            "appName": "inbound",
          },
        ),
      );

      dynamic jsonResponse;
      try {
        jsonResponse = jsonDecode(res.body);
      } catch (e) {
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
      if (ctx.mounted) {
        showErrorDialogue("An unexpected error occurred", ctx);
      }
    } finally {
      isOtherLinkLoading.value = false;
    }
  }

  Widget _buildOptionButton(String text, VoidCallback onPressed, Color bgColor, Color txtColor) {
    return Container(
      height: 80,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: txtColor)
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: txtColor,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Clear transport type
        sp?.remove("transportType");
        // Navigate back to login screen
        Get.offAll(() => LoginScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.redbar,
          elevation: 0,
          title: const Text(
            'Transport Option',
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.w500
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Clear transport type
              sp?.remove("transportType");
              // Navigate back to login screen
              logout();
              Get.offAll(() => LoginScreen());
            },
          ),
        ),
        body: Stack(
          children: [
            // Background image with blur effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.loginbg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            
            // Content (Transport Selection UI)
            Center(
              child: Container(
                width: 600,
                height: 350,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'Transportation Type',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Subtitle
                    const Text(
                      'Please select your transportation type',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    // Option buttons in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOptionButton(
                          'Inbound',
                          () {
                            // Save selection to SharedPreferences
                            sp?.setString("transportType", "Inbound");
                            // Handle inbound selection with API call
                            _handleInboundSelection();
                          },
                          ColorConstant.color1, 
                          Colors.white
                        ),
                        _buildOptionButton(
                          'Outbound',
                          () {
                            // Save selection to SharedPreferences
                            sp?.setString("transportType", "Outbound");
                            // Navigate to HomeScreen for outbound
                            Get.off(() => const HomeScreenTR());
                          },
                          Colors.white, 
                          ColorConstant.redbar
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}