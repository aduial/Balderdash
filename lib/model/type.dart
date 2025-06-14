/*
  The Type entity is used to group Projects (eg. "demo", "classic", "satire"
  "linguistics")
 */
class Type {
  int? id;
  String? name;

  Type({
      this.id,
      this.name
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name
    };
  }

  static Type fromMap(Map map) {
    Type type = Type();
    type.id = map['id'];
    type.name = map['name'];
    return type;
  }
}
