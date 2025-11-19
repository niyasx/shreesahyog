# Shreesahyog - Logistics Management Platform

A comprehensive Flutter-based logistics management application designed to streamline bidding processes, freight billing, and delivery tracking operations for transporters and logistics personnel.

## 📋 Table of Contents

- [Overview](#overview)
- [Project Architecture](#project-architecture)
- [Core Features](#core-features)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Core Modules](#core-modules)
- [Key Concepts](#key-concepts)
- [API Integration](#api-integration)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

Shreesahyog is an enterprise-level logistics management platform that digitizes and automates the complete lifecycle of freight operations. It connects logistics teams with transporters to enable efficient bidding, delivery tracking, and financial management.

### Problem Solved

Traditional logistics operations face challenges with:
- Fragmented communication between logistics teams and transporters
- Manual, error-prone bidding processes
- Complex freight billing and validation workflows
- Lack of real-time delivery tracking
- Inefficient vehicle-to-delivery assignment

Shreesahyog addresses these challenges through a unified, digital platform with clear workflows and real-time data management.

### Key Benefits

- **Operational Efficiency**: Reduces manual tasks and accelerates delivery cycles
- **Transparency**: Provides real-time visibility for all stakeholders
- **Data Accuracy**: Ensures consistent data formatting and validation
- **Security**: Implements robust authentication and secure data storage
- **Scalability**: Modular architecture supports growing operations

## 🏗️ Project Architecture

Shreesahyog follows a layered architecture pattern:

```
┌─────────────────────────────────────────────┐
│        UI Layer (Custom Widgets)            │
│   CustomScaffold, CustomTable, Dropdowns   │
├─────────────────────────────────────────────┤
│   State Management Layer (GetX Controller)  │
│      Global data & navigation control      │
├─────────────────────────────────────────────┤
│      API Service Layer & Data Models        │
│   API Services + DTOs (Data Transfer Obj.)  │
├─────────────────────────────────────────────┤
│     Persistent Storage & Authentication     │
│   SharedPreferences + SecureStorage + Auth  │
├─────────────────────────────────────────────┤
│          Backend Server (REST API)          │
└─────────────────────────────────────────────┘
```

## ✨ Core Features

### 1. **Pre-Bidding Process**
Prepare delivery instructions for bidding with features like:
- Viewing pending deliveries by plant/organization
- Updating freight amounts and remarks
- Grouping deliveries (clubbing) for efficiency
- Managing delivery instruction details

### 2. **Bidding Process**
Execute competitive and manual bidding:
- View available bids across organizations
- Submit freight rate bids as a transporter
- Withdraw bids when needed
- Handle clubbed deliveries (grouped DIs)
- Support manual DI allotments for direct assignments

### 3. **Invoicing & Billing**
Manage the complete billing lifecycle:
- Generate freight bills from completed deliveries
- Update delivery weights, taxes, and charges
- Submit bills for logistics approval
- Validate and approve/reject bills with remarks
- Track bill status and payment records

### 4. **Token Mapping**
Link delivery instructions to vehicles:
- Assign tokens (vehicles) to awarded deliveries
- Capture and verify driver information
- Manage vehicle and owner details
- Enable delivery tracking with identifiable vehicles

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter/Dart
- **State Management**: GetX (Reactive framework)
- **UI Components**: Custom widgets with Tailwind-like styling
- **Navigation**: GetX routing and Material Navigation

### Backend Communication
- **HTTP Client**: Dart http package
- **Data Format**: JSON serialization/deserialization
- **Authentication**: Bearer token (JWT-style)

### Local Storage
- **Preferences**: SharedPreferences (non-sensitive data)
- **Secure Storage**: flutter_secure_storage (encrypted sensitive data)
- **Session Management**: Token-based with expiration

### Design Patterns
- **DTO Pattern**: Data Models for API communication
- **Service Layer Pattern**: API services for backend interaction
- **Singleton Pattern**: Global controller instances
- **Observer Pattern**: GetX Rx variables for reactive UI

## 📁 Project Structure

```
lib/
├── features/
│   ├── login/
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── otp_verification.dart
│   │   ├── authentication/
│   │   │   └── authentication_api.dart
│   │   └── widgets/
│   │       ├── login_box.dart
│   │       ├── custom_button.dart
│   │       └── secure_storage.dart
│   │
│   ├── preBidding/
│   │   ├── screens/
│   │   │   ├── pre_bidding_process.dart
│   │   │   └── pre_bidding_process2.dart
│   │   ├── api/
│   │   │   ├── prebid_list.dart
│   │   │   └── pre_bid_2_api.dart
│   │   └── apiModels/
│   │       ├── prebid_first.dart
│   │       └── pre_bid_2_model.dart
│   │
│   ├── biddingProcess/
│   │   ├── screens/
│   │   │   ├── start_bid_logistics.dart
│   │   │   ├── transporter_action_screen.dart
│   │   │   └── manualdiallotment.dart
│   │   ├── api/
│   │   │   ├── start_bid.dart
│   │   │   ├── transporter_apis.dart
│   │   │   └── manualdiallotment_action_api.dart
│   │   └── models/
│   │       ├── start_bid_model.dart
│   │       └── transporter_action_model.dart
│   │
│   ├── invoicing/
│   │   ├── transporter_invoicing/
│   │   │   └── transporter_freight_bill.dart
│   │   ├── logistics_invoicing/
│   │   │   └── validate_freight_bill.dart
│   │   ├── apis/
│   │   │   ├── freight_bill_api.dart
│   │   │   └── view_freightbill_api.dart
│   │   └── models/
│   │       ├── freight_bill_model.dart
│   │       ├── process_freight_bill_model.dart
│   │       └── validate_freight_logistics_model.dart
│   │
│   ├── tokenMapping/
│   │   ├── screens/
│   │   │   ├── token_mapping.dart
│   │   │   └── token_mapping_linking.dart
│   │   ├── api/
│   │   │   └── token_mapping_apis.dart
│   │   └── models/
│   │       ├── token_mapping_model.dart
│   │       ├── token_list.dart
│   │       ├── token_didetails.dart
│   │       └── token_mapping_link_model.dart
│   │
│   └── common/
│       ├── screens/
│       │   ├── home_screen.dart
│       │   └── token_expire.dart
│       ├── controller/
│       │   └── controller.dart
│       ├── widgets/
│       │   ├── custom_scaffold.dart
│       │   ├── custom_table.dart
│       │   ├── custom_drop_down.dart
│       │   ├── custom_button.dart
│       │   └── appBar2.dart
│       └── models/
│           ├── usersModel.dart
│           └── business_rules.dart
│
├── main.dart
└── global.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK
- Android Studio / Xcode
- A compatible backend API server

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/shreesahyog.git
cd shreesahyog
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure environment**
Create a `lib/global.dart` file with backend configuration:
```dart
const String domain = "your-api-domain.com";
const String baseUrl = "https://your-api-domain.com/api";
```

4. **Run the application**
```bash
flutter run
```

## 📚 Core Modules

### 1. Data Models (DTOs) - Chapter 1
**Purpose**: Act as blueprints for data exchanged with the backend

- Define expected data structure for API requests/responses
- Implement `fromJson()` for deserializing JSON to Dart objects
- Implement `toJson()` for serializing Dart objects to JSON
- Ensure type safety and consistency

**Key Files**:
- `start_bid_model.dart`
- `freight_bill_model.dart`
- `transporter_action_model.dart`
- `token_mapping_model.dart`

### 2. API Service Layer - Chapter 2
**Purpose**: Handle all backend communication with abstraction

- Build HTTP requests with correct headers and authentication
- Manage query parameters and request bodies
- Process responses and handle errors
- Leverage DTOs for data transformation
- Implement retry logic and error handling

**Key Files**:
- `start_bid.dart`
- `freight_bill_api.dart`
- `pre_bid_2_api.dart`
- `token_mapping_apis.dart`

### 3. Persistent Local Storage - Chapter 3
**Purpose**: Store and retrieve data on the device

- **SharedPreferences (sp)**: Non-sensitive data (preferences, filters, user selections)
- **SecureStorageService**: Encrypted storage for tokens and credentials
- Enable offline access to critical data
- Improve performance through caching

**Usage**:
```dart
// Save non-sensitive data
sp?.setString("selectedDivision", "Cement");

// Read non-sensitive data
String division = sp?.getString("selectedDivision") ?? "";

// Save sensitive data
await secureStorage.write("token", authToken);

// Read sensitive data
String? token = await secureStorage.read("token");
```

### 4. Authentication & Session Management - Chapter 4
**Purpose**: Verify user identity and maintain secure sessions

- Login with username/password or SSO
- OTP verification for additional security
- Store authentication tokens securely
- Handle token expiration and refresh
- Implement logout functionality

**Key Components**:
- `LoginScreen`: Username and password input
- `OTPVerificationScreen`: One-time password verification
- `authentication_api.dart`: Backend authentication
- `TokenExpire`: Session expiration handling

### 5. Custom UI Widgets - Chapter 5
**Purpose**: Provide consistent, reusable UI components

- **CustomScaffold**: Standard app structure with AppBar and BottomBar
- **CustomTable**: Styled data table with borders and scrolling
- **CustomDropdownMenu**: Consistent dropdown styling
- **CustomButton**: Standardized button appearance
- **TableColumn widgets**: Individual cell rendering

**Benefits**:
- Consistent look and feel across the app
- Faster development through reuse
- Centralized design changes
- Improved maintainability

### 6. Global State Management - Chapter 6
**Purpose**: Manage shared data and app state globally

**GetX Controller**:
```dart
class Controller extends GetxController {
  static Controller get instance => Get.find();
  
  final RxInt currentIndex = 0.obs;
  final RxString selectedDivision = ''.obs;
  final RxString preBid2PlantId = ''.obs;
  // ... other observables
}
```

**Usage in UI**:
```dart
// Access controller
final control = Get.find<Controller>();

// Update state
control.currentIndex.value = 5;

// Observe changes
Obx(() => Text(control.selectedDivision.value))
```

**Key Benefits**:
- Centralized state management
- Automatic UI updates on state changes
- Decoupled components
- Improved performance (only affected widgets rebuild)

### 7. Pre-Bidding Process Core - Chapter 7
**Purpose**: Prepare delivery instructions before bidding

**Screens**:
- `PreBiddingProcess`: Overview of plants with pending DIs
- `PreBidProcess2`: Detailed DI management and updates

**Workflow**:
1. Filter by Division and DI Type
2. View list of plants with pending deliveries
3. Select a plant to view detailed DIs
4. Update DI information (freight, remarks, etc.)
5. Group deliveries (club DIs) for efficiency

**Key APIs**:
- `PrebidListApi.getPreBidList()`: Fetch overview
- `PreBid2API.getPreBid2DataFromAPI()`: Fetch details
- `PreBid2API.updatePreBid2Data()`: Update individual DI

### 8. Bidding Process Core - Chapter 8
**Purpose**: Manage active bidding and DI assignment

**Screens**:
- `StartBidLogistics`: Bid overview for logistics personnel
- `StartBidTransporterAction`: Active bidding interface for transporters
- `ManualDiallotment`: Manual DI assignment

**Features**:
- View available bids with scheduled times
- Submit freight rate bids
- Manage clubbed DIs (group bidding)
- Withdraw bids
- Manual allotment for direct assignment
- Countdown timer for bid duration

**Key APIs**:
- `StartBidApi.getStartBidData()`: Fetch bid overview
- `TransporterApi.getTransport2DataFromAPI()`: Fetch detailed DIs
- Bid submission and withdrawal endpoints

### 9. Invoicing Process Core - Chapter 9
**Purpose**: Generate and validate freight bills

**Screens**:
- `TransporterFreightBill`: Bill generation and details input
- `ValidateFreightBillLogistics`: Bill approval/rejection

**Workflow**:
1. Search eligible deliveries by filters
2. Select DIs and initiate freight bill
3. Update delivery details (weights, taxes, charges)
4. Process freight bill (creates final bill)
5. Logistics team reviews bill
6. Approve or reject with remarks

**Bill Lifecycle States**:
- Pending: Awaiting approval
- Approved: Ready for payment
- Rejected: Returned for corrections
- Hold: Temporarily on hold

**Key APIs**:
- `FreightBillApi.searchFrieghBill()`: Find eligible DIs
- `FreightBillApi.processFreightBill()`: Generate bill
- `ViewFreightBillApi.validateFReightBillLogisticsApi()`: Fetch for approval
- `ViewFreightBillApi.approveOrRejectFrBillApi()`: Submit decision

### 10. Token Mapping Core - Chapter 10
**Purpose**: Link delivery instructions to vehicles

**Screens**:
- `TokenMapping`: Overview of awarded DIs by plant
- `TokenMappingLinking`: Detailed DI-to-token assignment

**Workflow**:
1. View awarded deliveries for transporter
2. Select a plant to view DIs needing tokens
3. Select an available token (vehicle)
4. Review/edit driver and owner details
5. Confirm smart phone capability
6. Submit mapping

**Data Captured**:
- Driver name and mobile number
- License number
- Owner name and contact
- Vehicle/truck details
- Smart phone capability for app usage

**Key APIs**:
- `TokenMappingApi.getTokenMapingDiList()`: Fetch awarded DIs
- `TokenMappingApi.getTokenNumberList()`: Fetch available tokens
- `TokenMappingApi.getTokenDiDetails()`: Fetch token details
- `TokenMappingApi.submitTokenForm()`: Submit mapping

## 🔑 Key Concepts

### Data Transfer Objects (DTOs)
All communication with the backend uses DTOs to ensure type safety and consistency:

```dart
class StartBidModel {
  String? responseMessage;
  String? responseCode;
  List<StartBidResponseItem>? responseList;

  StartBidModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'] as String?;
    responseCode = json['responseCode'] as String?;
    responseList = (json['responseList'] as List?)
        ?.map((e) => StartBidResponseItem.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'responseMessage': responseMessage,
      'responseCode': responseCode,
      'responseList': responseList?.map((e) => e.toJson()).toList(),
    };
  }
}
```

### Observable State with GetX
GetX Rx variables automatically notify observers of changes:

```dart
// Define observables
final RxInt currentIndex = 0.obs;
final RxString selectedDivision = ''.obs;
final RxBool isLoading = false.obs;

// Update observables
currentIndex.value = 5;
selectedDivision.value = "Cement";
isLoading.value = true;

// Observe in UI
Obx(() => 
  Column(children: [
    Text('Index: ${currentIndex.value}'),
    Text('Division: ${selectedDivision.value}'),
  ])
)
```

### Session Management with Tokens
Authentication tokens are stored securely and included with all API calls:

```dart
// Store token securely after login
await secureStorage.write("token", authToken);

// Retrieve token for API calls
String? token = await secureStorage.read("token");

// Include in request headers
var res = await http.get(uri, headers: {
  "Authorization": "Bearer $token",
  "Content-Type": "application/json",
});
```

### Reactive UI with ValueNotifier
For simpler, local state management:

```dart
ValueNotifier<List<Item>> itemList = ValueNotifier([]);

// Update state
itemList.value = newList;

// Listen in UI
ValueListenableBuilder(
  valueListenable: itemList,
  builder: (context, List<Item> items, child) {
    return ListView(children: items);
  },
)
```

## 🔌 API Integration

### Backend Communication Pattern

All API calls follow this pattern:

1. **Build Request**: Prepare URL, headers, and body
2. **Include Authentication**: Add bearer token from secure storage
3. **Make Request**: Use http package to send request
4. **Handle Response**: Check status code and parse JSON
5. **Transform Data**: Use DTO's fromJson() to convert JSON to Dart objects
6. **Handle Errors**: Show user-friendly error messages

### Example API Call

```dart
Future<StartBidModel> getStartBidData({
  required String division,
  required String ditype,
}) async {
  final queryParameters = {
    'empCode': sp?.getString("employeeCode") ?? "",
    'division': division,
    'diType': ditype
  };
  
  String? token = await secureStorage.read("token");
  
  final uri = Uri.https(
    domain,
    "/app/bidding/plant-wiseDi-Logistics",
    queryParameters,
  );

  try {
    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    if (res.statusCode == 200) {
      final result = jsonDecode(res.body);
      return StartBidModel.fromJson(result);
    } else if (res.statusCode == 403) {
      // Handle token expiration
      navigateToTokenExpireScreen();
    }
  } catch (e) {
    print("Error: $e");
    return StartBidModel(); // Return empty model or handle error
  }
}
```

### Common HTTP Methods

- **GET**: Fetch data (bids list, DI details, bill status)
- **POST**: Submit data (bid, initiate bill, map token)
- **PUT**: Update existing data (update DI details, approve bill)
- **DELETE**: Remove data (rarely used in shreesahyog)

## 🤝 Contributing

### Code Style
- Follow Dart style guide (use `dartfmt`)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep methods focused and single-responsibility

### Adding New Features

1. **Create Data Models**: Define DTOs in `models/` directory
2. **Create API Services**: Implement API methods in `api/` directory
3. **Create Screens/Widgets**: Build UI in `screens/` and `widgets/` directories
4. **Update Controller**: Add necessary state to GetX controller if needed
5. **Test Integration**: Verify the feature works end-to-end

### Pull Request Process

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit changes (`git commit -m 'Add amazing feature'`)
3. Push to branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request with detailed description

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📞 Support

For support, questions, or feedback:
- Open an issue on GitHub
- Contact the development team
- Check the documentation and tutorials

## 🙏 Acknowledgments

Shreesahyog is built with attention to clean architecture, maintainability, and user experience. Special thanks to:
- The Flutter and Dart communities
- GetX for excellent state management
- All contributors and testers

---

**Last Updated**: 2025  
**Version**: 1.0.0  
**Status**: Active Development
