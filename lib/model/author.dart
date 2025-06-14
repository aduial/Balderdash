/*
  The Author entity is the owner of a Project
 */
class Author {
  int? id;
  String? name;

  Author({
      this.id,
      this.name
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name
    };
  }

  static Author fromMap(Map map) {
    Author author = Author();
    author.id = map['id'];
    author.name = map['name'];
    return author;
  }
}
