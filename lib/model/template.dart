/*
  The Template entity contains HTML templates that can be used together
  with .data files (the original Nonsense files with vocabularies containing
  entries) and the nonsense.pl perl executable to generate dynamic web pages
  containing Nonsense
 */
class Template {
  int? id;
  int? projectId;
  String? title;
  String? html;
  String? notes;

  Template({
    this.id,
    this.projectId,
    this.title,
    this.html,
    this.notes
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "title": title,
      "html": html,
      "notes": notes
    };
  }

  static Template fromMap(Map map) {
    Template template = Template();
    template.id = map['id'];
    template.projectId = map['projectId'];
    template.title = map['title'];
    template.html = map['html'];
    template.notes = map['notes'];
    return template;
  }
}
