class Activity {
  int locationId;
  int performedBy;
  String type;
  String activityPerformed;

  Activity.fromjson(Map<String, dynamic> map) {
    this.locationId = map['Location_id'];
    this.performedBy = map['Performed_by'];
    this.type = map['Type'];
    this.activityPerformed = map['Change'];
  }

  tojson() {
    Map<String, dynamic> map;
    map['Location_id'] = this.locationId;
    map['Performed_by'] = this.performedBy;
    map['Type'] = this.type;
    map['Change'] = this.activityPerformed;
    return map;
  }
}
