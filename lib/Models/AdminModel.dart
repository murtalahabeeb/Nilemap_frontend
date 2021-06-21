class Admin {
  int id;
  String name;
  String password;
  String rememberToken;
  Admin();

  Admin.fromjson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.password = map['password'];
    this.rememberToken = map['remember_token'];
  }

  Admin.login(Map<String, dynamic> map) {
    this.id = map['user']['id'];
    this.name = map['user']['name'];
    this.rememberToken = map['token'];
  }

  tojson() {
    Map<String, dynamic> map;
    map['id'] = this.id;
    map['name'] = this.name;
    map['password'] = this.password;
    return map;
  }
}
