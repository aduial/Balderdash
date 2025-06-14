/*
  View with joined string values
 */

class ProjectView {

  int? id;
  int? typeId;
  String? type;
  int? authorId;
  String? author;
  String? title;
  String? notes;

  ProjectView({
    this.id,
    this.typeId,
    this.type,
    this.authorId,
    this.author,
    this.title,
    this.notes});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "typeId": typeId,
      "type": type,
      "authorId": authorId,
      "author": author,
      "title": title,
      "notes": notes
    };
  }

  static ProjectView fromMap(Map map) {
    ProjectView projectView = ProjectView();
    projectView.id = map['id'];
    projectView.typeId = map['typeId'];
    projectView.type = map['type'];
    projectView.authorId = map['authorId'];
    projectView.author = map['author'];
    projectView.title = map['title'];
    projectView.notes = map['notes'];
    return projectView;
  }
}
