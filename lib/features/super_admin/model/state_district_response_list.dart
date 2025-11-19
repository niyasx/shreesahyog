import 'package:shreecement/features/preBidding/apiModels/district.dart';

// A class representing a district with its code and name

// A class representing a state with its code, name, and districts
class StateDistrict {
  final String transporterCode; // Code identifying the transporter
  final String stateCode; // Unique code for the state
  final String stateName; // Name of the state
  final List<DistrictResponseList>
      districtDetails; // List of districts in the state

  StateDistrict({
    required this.transporterCode,
    required this.stateCode,
    required this.stateName,
    required this.districtDetails,
  });

  // Factory method to create a StateDistrict from JSON
  factory StateDistrict.fromJson(Map<String, dynamic> json) {
    var districtList = json['districtDetails'] as List;
    List<DistrictResponseList> districts = districtList
        .map((item) => DistrictResponseList.fromJson(item))
        .toList();

    return StateDistrict(
      transporterCode: json['transporterCode'],
      stateCode: json['stateCode'],
      stateName: json['stateName'],
      districtDetails: districts,
    );
  }

  // Convert a StateDistrict to JSON
  Map<String, dynamic> toJson() {
    return {
      'transporterCode': transporterCode,
      'stateCode': stateCode,
      'stateName': stateName,
      'districtDetails': districtDetails.map((d) => d.toJson()).toList(),
    };
  }
}

// A class representing the entire response with a list of state-district information
class StateDistrictResponse {
  final String responseMessage; // Message describing the response
  final List<StateDistrict> responseList; // List of StateDistrict objects

  StateDistrictResponse({
    required this.responseMessage,
    required this.responseList,
  });

  // Factory method to create a StateDistrictResponse from JSON
  factory StateDistrictResponse.fromJson(Map<String, dynamic> json) {
    var stateList = json['responseList'] as List;
    List<StateDistrict> states =
        stateList.map((item) => StateDistrict.fromJson(item)).toList();

    return StateDistrictResponse(
      responseMessage: json['responseMessage'],
      responseList: states,
    );
  }

  // Convert a StateDistrictResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'responseMessage': responseMessage,
      'responseList': responseList.map((s) => s.toJson()).toList(),
    };
  }
}
