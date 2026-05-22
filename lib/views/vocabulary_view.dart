/*
  View with joined string values
 */

class VocabularyView {
  int? id;
  int? categoryId;
  String? category;
  int? projectId;
  String? project;
  String? title;
  String? content;
  String? comment;
  int? isCFG;

  VocabularyView({
    this.id,
    this.categoryId,
    this.category,
    this.projectId,
    this.project,
    this.title,
    this.content,
    this.comment,
    this.isCFG});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "categoryId": categoryId,
      "category": category,
      "projectId": projectId,
      "project": project,
      "title": title,
      "content": content,
      "comment": comment,
      "isCFG": isCFG
    };
  }

  static VocabularyView fromMap(Map map) {
    VocabularyView vocabularyView = VocabularyView();
    vocabularyView.id = map['id'];
    vocabularyView.categoryId = map['categoryId'];
    vocabularyView.category = map['category'];
    vocabularyView.projectId = map['projectId'];
    vocabularyView.project = map['project'];
    vocabularyView.title = map['title'];
    vocabularyView.content = map['content'];
    vocabularyView.comment = map['comment'];
    vocabularyView.isCFG = map['isCFG'];
    return vocabularyView;
  }
}
