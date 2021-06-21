class Activity {
  int id;
  String type;
  String activityPerformed;

  Activity.fromjson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.type = map['Type'];
    this.activityPerformed = map['Change'];
  }
}

// https://nile-map.herokuapp.com

// 1|GRCvfecivRZdORr0u951Xo3Q2Ku5YqW8ETOlMzGs
