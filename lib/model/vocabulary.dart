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

  Vocabulary({
    this.id,
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
}
