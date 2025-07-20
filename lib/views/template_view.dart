/*
  View with joined string values
 */

class TemplateView {
  int? id;
  int? projectId;
  String? project;
  String? title;
  String? content;
  int? isHtml;
  String? notes;

  TemplateView({
    this.id,
    this.projectId,
    this.project,
    this.title,
    this.content,
    this.isHtml,
    this.notes});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "project": project,
      "title": title,
      "content": content,
      "isHtml": isHtml,
      "notes": notes
    };
  }

  static TemplateView fromMap(Map map) {
    TemplateView templateView = TemplateView();
    templateView.id = map['id'];
    templateView.projectId = map['projectId'];
    templateView.project = map['project'];
    templateView.title = map['title'];
    templateView.content = map['content'];
    templateView.isHtml = map['isHtml'];
    templateView.notes = map['notes'];
    return templateView;
  }
}
