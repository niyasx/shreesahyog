class TransporterDashboard {
  int? totalBids;
  int? unmappedDI;
  int? manualBids;
  int? automatedBids;
  int? unlinkedDIRed;
  int? unlinkedDIOrange;
  int? unlinkedDIGreen;

  TransporterDashboard(
      {this.totalBids,
      this.unmappedDI,
      this.manualBids,
      this.automatedBids,
      this.unlinkedDIRed,
      this.unlinkedDIOrange,
      this.unlinkedDIGreen});

  TransporterDashboard.fromJson(Map<String, dynamic> json) {
    totalBids = json['totalBids'];
    unmappedDI = json['unmappedDI'];
    manualBids = json['manualBids'];
    automatedBids = json['automatedBids'];
    unlinkedDIRed = json['unlinkedDIRed'];
    unlinkedDIOrange = json['unlinkedDIOrange'];
    unlinkedDIGreen = json['unlinkedDIGreen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalBids'] = totalBids;
    data['unmappedDI'] = unmappedDI;
    data['manualBids'] = manualBids;
    data['automatedBids'] = automatedBids;
    data['unlinkedDIRed'] = unlinkedDIRed;
    data['unlinkedDIOrange'] = unlinkedDIOrange;
    data['unlinkedDIGreen'] = unlinkedDIGreen;
    return data;
  }
}
