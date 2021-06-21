class Deleted {
  int id;
  String deleted;

  Deleted.fromjson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.deleted = map['Deleted_entity'];
  }
}
