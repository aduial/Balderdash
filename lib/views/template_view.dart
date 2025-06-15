/*
  View with joined string values
 */

class TemplateView {
  int? id;
  int? projectId;
  String? project;
  String? title;
  String? html;
  String? notes;

  TemplateView({
    this.id,
    this.projectId,
    this.project,
    this.title,
    this.html,
    this.notes});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "project": project,
      "title": title,
      "html": html,
      "notes": notes
    };
  }

  static TemplateView fromMap(Map map) {
    TemplateView templateView = TemplateView();
    templateView.id = map['id'];
    templateView.projectId = map['projectId'];
    templateView.project = map['project'];
    templateView.title = map['title'];
    templateView.html = map['html'];
    templateView.notes = map['notes'];
    return templateView;
  }
}
