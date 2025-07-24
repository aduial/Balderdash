import '../config/config.dart';

/*
  The Vocabulary entity contains the elements referred to in the grammar file.
  Can be grouped hierarchically and toggled on and off. The words are separated
  by newline characters, it s much more user friendly to enter many words as
  a block of text than as separate form entries
 */

class Vocabulary {
  int? id;
  int? categoryId;
  int? projectId;
  String? title;
  String? content;
  String? comment;
  int? useThis;

  Vocabulary(
      {this.id,
      this.categoryId,
      this.projectId,
      this.title,
      this.content,
      this.comment,
      this.useThis});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "categoryId": categoryId,
      "projectId": projectId,
      "title": title,
      "content": content,
      "comment": comment,
      "useThis": useThis
    };
  }

  static Vocabulary fromMap(Map map) {
    Vocabulary vocabulary = Vocabulary();
    vocabulary.id = map['id'];
    vocabulary.categoryId = map['categoryId'];
    vocabulary.projectId = map['projectId'];
    vocabulary.title = map['title'];
    vocabulary.content = map['content'];
    vocabulary.comment = map['comment'];
    vocabulary.useThis = map['useThis'];
    return vocabulary;
  }

  String dump() {
    return "$categoryId$sep1$projectId$sep2$title$sep3$content$sep4$comment$sep5$useThis";
  }

  static Vocabulary fromDump(String dump, int projectId) {
    RegExp vocPattern =
        RegExp(r'^(\d+)§1§(\d+)§2§(\w+?)§3§(.*?)§4§(.*?)§5§(\d)', dotAll: true);
    Vocabulary vocabulary = Vocabulary();
    vocabulary.categoryId =
        int.parse(vocPattern.firstMatch(dump)?.group(1) ?? '1');
    vocabulary.projectId = projectId;
    vocabulary.title = vocPattern.firstMatch(dump)?.group(3) ?? '';
    vocabulary.content = vocPattern.firstMatch(dump)?.group(4) ?? '';
    vocabulary.comment = vocPattern.firstMatch(dump)?.group(5) ?? '';
    vocabulary.useThis =
        int.parse(vocPattern.firstMatch(dump)?.group(6) ?? '1');
    // if (vocabulary.title!.isEmpty) {
    //   print("gotcha");
    // }
    return vocabulary;
  }
}
