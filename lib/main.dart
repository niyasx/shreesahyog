import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/screens/home_screen_mis.dart';
import 'package:shreecement/features/login/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreecement/features/login/widgets/inbound_outbound_screen.dart';
import 'package:shreecement/features/login/widgets/secure_storage.dart';
import 'features/common/controller/controller.dart';
import 'features/common/screens/dashboard_screen2.dart';
import 'features/common/screens/home_screen.dart';
import 'features/common/screens/homesc3.dart'; 
import 'package:universal_html/html.dart' as html;

SharedPreferences? sp;
final secureStorage = SecureStorageService();
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  // Check token in secure storage and update SharedPreferences
  await checkSecureStorageToken();
  runApp(const MyApp());
}

// AD implementation
final navigatorKey = GlobalKey<NavigatorState>();

final control = Get.put(Controller());


Future<void> checkSecureStorageToken() async {
  try {
    // Get token from secure storage
    String? token = await secureStorage.read("token");
    
    // Store authentication status in SharedPreferences
    // We only store a boolean flag, not the actual token
    if (token != null) {
      await sp?.setBool("isAuthenticated", true);
    } else {
      await sp?.setBool("isAuthenticated", false);
    }
  } catch (e) {
    debugPrint("Error checking secure storage token: $e");
    await sp?.setBool("isAuthenticated", false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // // Add a listener for the unload event to handle closing the browser/tab
    html.window.onUnload.listen((html.Event e) {
      // Clear SharedPreferences or perform any cleanup here
      sp?.setString("currentscreen", control.currentIndex.value.toString());
    });
    // html.window.onBeforeUnload.listen((html.Event e) {
    //   // Clear SharedPreferences or perform any cleanup here
    //
    //   sp?.clear();
    // });

    bool isAuthenticated = false;
    isAuthenticated = sp?.getBool("isAuthenticated") ?? false;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Shree Sahyog V 4.0',
      title: 'Shree Sahyog V19.3-Beta',
      navigatorKey:  navigatorKey,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF002F86),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF002F86)),
        useMaterial3: true,
      ),
// home: isAuthenticated ? HomeScreen() : LoginScreen(),
      home: isAuthenticated ? _getHomeScreenBasedOnRole() : LoginScreen(),
    );
  }
}

// Widget _getHomeScreenBasedOnRole() {
//   if (sp != null) {
//     // Check if sp is not null
//     String? roleId =
//         sp!.getString("roleId"); // Use ! to assert that sp is not null
//     if (roleId == "3" || roleId == "5") {
//       control.currentIndex.value =
//           int.parse(sp!.getString("currentscreen") ?? "0");
//       return const HomeScreenTR();
//     } else if (roleId == "2") {
//       control.currentIndex.value =
//           int.parse(sp!.getString("currentscreen") ?? "0");
//       return const HomeScreen3();
//     }else if (roleId == "6") {
//       control.currentIndex.value =
//           int.parse(sp!.getString("currentscreen") ?? "0");
//       return const HomeScreen4();
//     } else {
//       control.currentIndex.value =
//           int.parse(sp!.getString("currentscreen") ?? "0");
//       return HomeScreen();
//     }
//   } else {
//     // Handle the case where sp is null, maybe return a default screen
//     return const CircularProgressIndicator(); // or any other default widget
//   }
// }


Widget _getHomeScreenBasedOnRole() {
  if (sp != null) {
    // Check if sp is not null
    String? roleId = sp!.getString("roleId");
    
    // For transport roles (3 or 5)
    if (roleId == "3" || roleId == "5") {
      // Check if transportType has been selected
      String? transportType = sp!.getString("transportType");
      
      // If transportType is not set, we need to show the option screen
      if (transportType == null) {
        return const TransportOptionScreen();
      } 
      // If transportType is set, navigate based on the selection
      else {
        control.currentIndex.value = int.parse(sp!.getString("currentscreen") ?? "0");
        
        if (transportType == "Outbound") {
          return const HomeScreenTR();
        } else {
          // Return outbound screen when implemented
          // For now, return to TransportOptionScreen to let the logic there handle navigation
          return const TransportOptionScreen();
        }
      }
    } 
    // For other roles, keep existing logic
    else if (roleId == "2") {
      control.currentIndex.value = int.parse(sp!.getString("currentscreen") ?? "0");
      return const HomeScreen3();
    } else if (roleId == "6") {
      control.currentIndex.value = int.parse(sp!.getString("currentscreen") ?? "0");
      return const HomeScreen4();
    } else {
      control.currentIndex.value = int.parse(sp!.getString("currentscreen") ?? "0");
      return HomeScreen();
    }
  } else {
    // Handle the case where sp is null
    return const CircularProgressIndicator();
  }
}