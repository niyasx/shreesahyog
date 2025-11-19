class DiAndInitiatedStatus {
  String diNo;
  bool initiated;

  DiAndInitiatedStatus({
    required this.diNo,
    required this.initiated,
  });

  factory DiAndInitiatedStatus.fromJson(Map<String, dynamic> json) {
    return DiAndInitiatedStatus(
      diNo: json['diNo'],
      initiated: json['initiated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "diNo": diNo,
      "initiated": initiated,
    };
  }
}
