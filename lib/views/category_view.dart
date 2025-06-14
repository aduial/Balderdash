/*
  View with joined string values
 */

class CategoryView {
  int? id;
  int? parentId;
  String? parent;
  String? name;
  String? comment;

  CategoryView({
    this.id,
    this.parentId,
    this.parent,
    this.name,
    this.comment});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "parentId": parentId,
      "parent": parent,
      "name": name,
      "comment": comment
    };
  }

  static CategoryView fromMap(Map map) {
    CategoryView categoryView = CategoryView();
    categoryView.id = map['id'];
    categoryView.parentId = map['parentId'];
    categoryView.parent = map['parent'];
    categoryView.name = map['name'];
    categoryView.comment = map['comment'];
    return categoryView;
  }
}
