import '../config/config.dart';

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
  String? content;
  int? isHtml;
  String? notes;

  Template(
      {this.id,
      this.projectId,
      this.title,
      this.content,
      this.isHtml,
      this.notes});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "title": title,
      "content": content,
      "isHtml": isHtml,
      "notes": notes
    };
  }

  static Template fromMap(Map map) {
    Template template = Template();
    template.id = map['id'];
    template.projectId = map['projectId'];
    template.title = map['title'];
    template.content = map['content'];
    template.isHtml = map['isHtml'];
    template.notes = map['notes'];
    return template;
  }

  String dump() {
    return "$projectId$sep1$title$sep2$content$sep3$isHtml$sep4$notes";
  }

  static Template fromDump(String dump, int projectId) {
    RegExp tplPattern =
        RegExp(r'^\d+§1§(\w+?)§2§(.+?)§3§(\d)§4§(\w*?)', dotAll: true);
    Template template = Template();
    template.projectId = projectId;
    template.title = tplPattern.firstMatch(dump)?.group(1) ?? '';
    template.content = tplPattern.firstMatch(dump)?.group(2) ?? '';
    template.isHtml = int.parse(tplPattern.firstMatch(dump)?.group(3) ?? '1');
    template.notes = tplPattern.firstMatch(dump)?.group(4) ?? '';
    return template;
  }
}
