class Admin {
  int id;
  String name;
  String password;
  String rememberToken;

  Admin.fromjson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.password = map['password'];
    this.rememberToken = map['rememberToken'];
  }

  tojson() {
    Map<String, dynamic> map;
    map['id'] = this.id;
    map['name'] = this.name;
    map['password'] = this.password;
    map['rememberToken'] = this.rememberToken;
    return map;
  }
}
