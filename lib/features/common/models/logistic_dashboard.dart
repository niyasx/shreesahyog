class LogisticUserDashboard {
  double? scheduledBidCount;
  double? cancelledBidCount;
  double? runningBidCount;
  double? inforceBidCount;
  double? activeBidCount;
  double? totalDiAllotedCount;
  double? manualBidCount;
  double? automatedBidCount;

  LogisticUserDashboard(
      {this.scheduledBidCount,
      this.cancelledBidCount,
      this.runningBidCount,
      this.inforceBidCount,
      this.activeBidCount,
      this.totalDiAllotedCount,
      this.manualBidCount,
      this.automatedBidCount});

  LogisticUserDashboard.fromJson(Map<String, dynamic> json) {
    scheduledBidCount = json['scheduledBidCount'];
    cancelledBidCount = json['cancelledBidCount'];
    runningBidCount = json['runningBidCount'];
    inforceBidCount = json['inforceBidCount'];
    activeBidCount = json['activeBidCount'];
    totalDiAllotedCount = json['totalDiAllotedCount'];
    manualBidCount = json['manualBidCount'];
    automatedBidCount = json['automatedBidCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheduledBidCount'] = scheduledBidCount;
    data['cancelledBidCount'] = cancelledBidCount;
    data['runningBidCount'] = runningBidCount;
    data['inforceBidCount'] = inforceBidCount;
    data['activeBidCount'] = activeBidCount;
    data['totalDiAllotedCount'] = totalDiAllotedCount;
    data['manualBidCount'] = manualBidCount;
    data['automatedBidCount'] = automatedBidCount;
    return data;
  }
}
