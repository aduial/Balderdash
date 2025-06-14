/*
  The Project entity group Vocabularies and Templates that are used to
  create Nonsense of a particular kind - eg. Doom Metal band names, Medical
  product names, Annie M.G. Schmidt character names, etc.
  Projects are grouped by Author and Type.
 */
class Project {
  int? id;
  int? typeId;
  int? authorId;
  String? title;
  String? notes;

  Project({
      this.id,
      this.typeId,
      this.authorId,
      this.title,
      this.notes
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "typeId": typeId,
      "authorId": authorId,
      "title": title,
      "notes": notes
    };
  }

  static Project fromMap(Map map) {
    Project project = Project();
    project.id = map['id'];
    project.typeId = map['typeId'];
    project.authorId = map['authorId'];
    project.title = map['title'];
    project.notes = map['notes'];
    return project;
  }
}
