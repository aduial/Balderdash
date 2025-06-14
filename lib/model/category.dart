/*
  The Category entity is used to group Vocabularies in a meaningful way:
  eg. Adjectives, Nouns. The parent-child hierarchy allows creating more
  specific vocabulary groups: parent Adjectives, children positiveAdjectives
  and NegativeAdjectives
 */
class Category {
  int? id;
  int? parentId;
  String? name;
  String? comment;

  Category({
    this.id,
    this.parentId,
    this.name,
    this.comment
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "parentId": parentId,
      "name": name,
      "comment": comment
    };
  }

  static Category fromMap(Map map) {
    Category category = Category();
    category.id = map['id'];
    category.parentId = map['parentId'];
    category.name = map['name'];
    category.comment = map['comment'];
    return category;
  }
}
