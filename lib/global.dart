import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreecement/features/login/controller/login_controller.dart';
import 'package:shreecement/main.dart';
import 'features/common/controller/controller.dart';

class App {
  static SharedPreferences? localStorage;

  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}

// //production url --

// String baseUrl = "https://prodsahyog.shreecement.com/app";
// String domain = "prodsahyog.shreecement.com";

//qa url --

String baseUrl = "https://qasahyogapi.shreecement.com/app";
String domain = "qasahyogapi.shreecement.com";


// //dev url --

  // String baseUrl = "https://devsahyogapi.shreecement.com/app";
  // String domain = "devsahyogapi.shreecement.com";

const character_length = 50;

//!
// Future<void> logout() async {
//   final loginControl = Get.find<LoginController>();
//   Get.reset();
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.clear();
//
//   Get.offAll(() => const MyApp());
//
//   if (loginControl.continue1.value == true) {
//     loginControl.toggle();
//   }
// }
//  final Config config = Config(
//   tenant: "9f1c2f43-4f34-4175-8eae-b4f2f45ee740",
//   clientId: "1b4ebb58-03ad-4e52-b851-2533951cca9e",
//   scope: "openid profile email",
//   // redirectUri is Optional as a default is calculated based on app type/web location
//   // redirectUri: "your redirect url available in azure portal",
//   navigatorKey: navigatorKey,
//   webUseRedirect: false, // default is false - on web only, forces a redirect flow instead of popup auth
//   //Optional parameter: Centered CircularProgressIndicator while rendering web page in WebView
//   loader: const Center(child: CircularProgressIndicator()),
//   postLogoutRedirectUri: 'http://your_base_url/logout', //optional
// );
//
// final AadOAuth oauth = AadOAuth(config);

Future<void> logout() async {
  final control = Get.put(Controller());

  control.resetCurrentIndex();

  final loginControl = Get.put(LoginController());

  if (loginControl.continue1.value == true) {
    loginControl.toggle();
  }
  // oauth.logout();

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await sp!.clear();
}

//new
