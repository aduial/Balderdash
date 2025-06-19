import 'dart:async';
import 'package:flutter/services.dart';

import 'package:nonsense/model/author.dart';
import 'package:nonsense/model/category.dart';
import 'package:nonsense/model/project.dart';
import 'package:nonsense/views/project_view.dart';
import 'package:nonsense/views/category_view.dart';
import 'package:nonsense/model/template.dart';
import 'package:nonsense/views/template_view.dart';
import 'package:nonsense/model/type.dart';
import 'package:nonsense/model/vocabulary.dart';
import 'package:nonsense/views/vocabulary_view.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DatabaseHelper {


  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();
  late Database _database;

  static const _dbName = "nonsense.db";
  static const _dbVersion = 1;
  static const _typeTableName = "type";
  static const _authorTableName = "author";
  static const _projectTableName = "project";
  static const _templateTableName = "template";
  static const _categoryTableName = "category";
  static const _vocabularyTableName = "vocabulary";

  Future<Database> get database async {
    // _database = await initiateDatabase();
    _database = await _initDB(_dbName);
    return _database;
  }

  // return database if already available in App directory
  // else, copy from assets folder to app directory
  Future<Database> _initDB(String dbName) async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, dbName);
    bool dbExists = await io.File(dbPath).exists();
    if (!dbExists) {
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await io.File(dbPath).writeAsBytes(bytes, flush: true);
    }
    print('DB location: $dbPath');
    return await openDatabase(dbPath, version: _dbVersion);
  }

  // deprecated
  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_typeTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $_authorTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $_projectTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        typeId INTEGER,
        authorId INTEGER,
        title TEXT NOT NULL DEFAULT "New project",
        notes TEXT,
        FOREIGN KEY(typeId) REFERENCES $_typeTableName(id),
        FOREIGN KEY(authorId) REFERENCES $_authorTableName(id)
      )
      ''');
    await db.execute('''
      CREATE TABLE $_templateTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        projectId INTEGER,
        html TEXT NOT NULL DEFAULT "<html><head></head><body></body></html>",
        notes TEXT,
        FOREIGN KEY(projectId) REFERENCES $_projectTableName(id)
      )
      ''');
    await db.execute('''
      CREATE TABLE $_categoryTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        parentId INTEGER,
        name TEXT NOT NULL DEFAULT "New category",
        comment TEXT,
        FOREIGN KEY(parentId) REFERENCES $_categoryTableName(id)
      )
      ''');
    await db.execute('''
      CREATE TABLE $_vocabularyTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        projectId INTEGER,
        categoryId INTEGER,
        title TEXT NOT NULL DEFAULT "NEW",
        content TEXT,
        comment TEXT,
        useThis INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY(projectId) REFERENCES $_projectTableName(id)
        FOREIGN KEY(categoryId) REFERENCES $_categoryTableName(id)
        UNIQUE(projectId, title)
      )
      ''');
  }
  // get list of authors
  Future<List<Author>> getAuthors() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
        _authorTableName,
        orderBy: 'name ASC')
    ;
    List<Author> authors = [];
    for (var result in results) {
      Author author = Author.fromMap(result);
      authors.add(author);
    }
    return authors;
  }


  // get Category
  Future<Author> getAuthor(int id) async {
    final db = await instance.database;
    final map = await db.rawQuery(
        "SELECT * FROM $_authorTableName WHERE "
            "id = ? "
            "ORDER BY id asc; ", [id]
    );
    if (map.isNotEmpty) {
      return Author.fromMap(map.first);
    } else {
      throw Exception("Author with ID $id not found");
    }
  }

  // get filtered list of Authors
  Future<List<Author>> getFilteredAuthors(String searchTerm) async {
    Database db = await instance.database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT * "
            "FROM $_authorTableName "
            "WHERE name like %?% ",[searchTerm]
    );
    List<Author> authors = [];
    for (var result in results) {
      Author author = Author.fromMap(result);
      authors.add(author);
    }
    return authors;
  }

  // Inserting and updating an Author
  Future<Author> upsertAuthor(Author author) async {
    Database db = await instance.database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_authorTableName WHERE id = ?;", [author.id]));
    if (count == 0) {
      await db.insert(_authorTableName, author.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_authorTableName, author.toMap(), where: "id = ?", whereArgs: [author.id]);
    }
    return author;
  }

  // Delete Author
  Future<int> deleteAuthor(Author author) async {
    Database db = await instance.database;
    return await db.delete(
      _authorTableName,
      where: "id = ?",
      whereArgs: [author.id],
    );
  }

  // Inserting and updating a category
  Future<Category> upsertCategory(Category category) async {
    Database db = await instance.database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_categoryTableName WHERE id = ?;", [category.id]));
    if (count == 0) {
      await db.insert(_categoryTableName, category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_categoryTableName, category.toMap(), where: "id = ?", whereArgs: [category.id]);
    }
    return category;
  }

  // get Category
  Future<Category> getCategory(int id) async {
    final db = await instance.database;
    final map = await db.rawQuery(
        "SELECT * FROM $_categoryTableName WHERE "
            "id = ? "
            "ORDER BY id asc; ", [id]
    );
    if (map.isNotEmpty) {
      return Category.fromMap(map.first);
    } else {
      throw Exception("Category with ID $id not found");
    }
  }

  // get list of categories
  Future<List<Category>> getCategories() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(_categoryTableName, orderBy: 'name ASC');
    List<Category> categories = [];
    for (var result in results) {
      Category category = Category.fromMap(result);
      categories.add(category);
    }
    return categories;
  }

  // get list of CategoryViews
  Future<List<CategoryView>> getCategoryViews() async {
    Database db = await instance.database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT c.id, c.parentId, IFNULL(cp.name, 'n/a') AS parent, c.name, c.comment "
            "FROM $_categoryTableName c "
            "LEFT OUTER JOIN $_categoryTableName cp ON c.parentId = cp.id "
            "WHERE c.id > 1");
    List<CategoryView> categoryViews = [];
    for (var result in results) {
      CategoryView categoryView = CategoryView.fromMap(result);
      categoryViews.add(categoryView);
    }
    return categoryViews;
  }

  // get filtered list of CategoryViews
  Future<List<CategoryView>> getFilteredCategoryViews(String searchTerm) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT c.id, c.parentId, IFNULL(cp.name, 'n/a') AS parent, c.name, c.comment "
            "FROM $_categoryTableName c "
            "LEFT OUTER JOIN $_categoryTableName cp ON c.parentId = cp.id "
            "WHERE c.name like '%$searchTerm%' "
            "AND c.id > 1; "
    );
    List<CategoryView> categoryViews = [];
    for (var result in results) {
      CategoryView categoryView = CategoryView.fromMap(result);
      categoryViews.add(categoryView);
    }
    return categoryViews;
  }

  // get children of a parent category
  Future<List<Category>> getChildCategories(int parentId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(_categoryTableName,
        where: "parentId = ?", whereArgs: [parentId]);
    List<Category> categories = [];
    for (var result in results) {
      Category category = Category.fromMap(result);
      categories.add(category);
    }
    return categories;
  }

  // Delete Category
  Future<int> deleteCategory(CategoryView categoryView) async {
    Database db = await instance.database;
    return await db.delete(
      _categoryTableName,
      where: "id = ?",
      whereArgs: [categoryView.id],
    );
  }

  // Inserting and updating a Project
  Future<Project> upsertProject(Project project) async {
    Database db = await instance.database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_projectTableName WHERE id = ?", [project.id]));
    if (count == 0) {
      await db.insert(_projectTableName, project.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_projectTableName, project.toMap(), where: "id = ?", whereArgs: [project.id]);
    }
    return project;
  }

  // get list of projects
  Future<List<Project>> getProjects() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(_projectTableName, orderBy: 'title ASC');
    List<Project> projects = [];
    for (var result in results) {
      Project project = Project.fromMap(result);
      projects.add(project);
    }
    return projects;
  }

  // get a specific project
  Future<Project> getProject(int id) async {
    Database db = await instance.database;
    final map = await db.rawQuery(
        "SELECT * FROM $_projectTableName WHERE id = ?",[id]
    );
    if (map.isNotEmpty) {
      return Project.fromMap(map.first);
    } else {
      throw Exception("Project with ID $id not found");
    }
  }

  // get list of Project views
  Future<List<ProjectView>> getProjectViews() async {
    Database db = await instance.database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT p.id, p.typeId, t.name AS type, p.authorId, a.name AS author, p.title, p.notes "
            "FROM $_projectTableName p "
            "JOIN $_typeTableName t ON p.typeId = t.id "
            "JOIN $_authorTableName a ON p.authorId = a.id;");
    List<ProjectView> projectViews = [];
    for (var result in results) {
      ProjectView projectView = ProjectView.fromMap(result);
      projectViews.add(projectView);
    }
    return projectViews;
  }


  // get filtered list of Project views
  Future<List<ProjectView>> getFilteredProjectViews(String searchTerm) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT p.id, p.typeId, t.name AS type, p.authorId, a.name AS author, p.title, p.notes "
            "FROM $_projectTableName p "
            "JOIN $_typeTableName t ON p.typeId = t.id "
            "JOIN $_authorTableName a ON p.authorId = a.id "
            "WHERE p.title like '%$searchTerm%'; "
    );
    List<ProjectView> projectViews = [];
    for (var result in results) {
      ProjectView projectView = ProjectView.fromMap(result);
      projectViews.add(projectView);
    }
    return projectViews;
  }

  // get a specific projectView
  Future<ProjectView> getProjectView(int id) async {
    Database db = await instance.database;
    final map = await db.rawQuery(
        "SELECT p.id, p.typeId, t.name AS type, p.authorId, a.name AS author, p.title, p.notes "
            "FROM $_projectTableName p "
            "JOIN $_typeTableName t ON p.typeId = t.id "
            "JOIN $_authorTableName a ON p.authorId = a.id "
            "WHERE p.id = ?;",[id]
    );
    if (map.isNotEmpty) {
      return ProjectView.fromMap(map.first);
    } else {
      throw Exception("Project with ID $id not found");
    }
  }

  // get list of projects of a certain type
  Future<List<Project>> getProjectsByType(int typeId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(_projectTableName,
        where: "typeId = ?", whereArgs: [typeId],
        orderBy: 'title ASC');
    List<Project> projects = [];
    for (var result in results) {
      Project project = Project.fromMap(result);
      projects.add(project);
    }
    return projects;
  }

  // get list of all projects of a certain author
  Future<List<Project>> getProjectsByAuthor(int authorId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
        _projectTableName,
        where: "authorId = ?", whereArgs: [authorId],
        orderBy: 'title ASC');
    List<Project> projects = [];
    for (var result in results) {
      Project project = Project.fromMap(result);
      projects.add(project);
    }
    return projects;
  }

  // Delete Project by View
  Future<int> deleteProject(ProjectView project) async {
    Database db = await instance.database;
    return await db.delete(
      _projectTableName,
      where: "id = ?",
      whereArgs: [project.id],
    );
  }

  // Inserting and updating a Template
  Future<Template> upsertTemplate(Template template) async {
    Database db = await instance.database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_templateTableName WHERE id = ?", [template.id]));
    if (count == 0) {
      await db.insert(_templateTableName, template.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_templateTableName, template.toMap(), where: "id = ?", whereArgs: [template.id]);
    }
    return template;
  }


  // get list of templates
  Future<List<Template>> getTemplates() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
        _templateTableName,
        orderBy: 'id ASC');
    List<Template> templates = [];
    for (var result in results) {
      Template template = Template.fromMap(result);
      templates.add(template);
    }
    return templates;
  }

  // get list of templateviews
  Future<List<TemplateView>> getTemplateViews() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT t.id, t.projectId, p.title AS project, t.title, t.html, t.notes "
            "FROM $_templateTableName t "
            "JOIN $_projectTableName p ON t.projectId = p.id;");
    List<TemplateView> templateViews = [];
    for (var result in results) {
      TemplateView templateView = TemplateView.fromMap(result);
      templateViews.add(templateView);
    }
    return templateViews;
  }

  // get filtered list of templateviews
  Future<List<TemplateView>> getFilteredTemplateViews(String searchTerm) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT t.id, t.projectId, p.title AS project, t.title, t.html, t.notes "
            "FROM $_templateTableName t "
            "JOIN $_projectTableName p ON t.projectId = p.id "
            "WHERE p.title like '%$searchTerm%';");
    List<TemplateView> templateViews = [];
    for (var result in results) {
      TemplateView templateView = TemplateView.fromMap(result);
      templateViews.add(templateView);
    }
    return templateViews;
  }

  // Delete Template
  Future<int> deleteTemplate(TemplateView template) async {
    Database db = await instance.database;
    return await db.delete(
      _templateTableName,
      where: "id = ?",
      whereArgs: [template.id],
    );
  }

  // get a specific type
  Future<Type> getType(int id) async {
    Database db = await instance.database;
    final map = await db.rawQuery(
        "SELECT * FROM $_typeTableName WHERE id = ?",[id]
    );
    if (map.isNotEmpty) {
      return Type.fromMap(map.first);
    } else {
      throw Exception("Type with ID $id not found");
    }
  }

  // get list of types
  Future<List<Type>> getTypes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(_typeTableName, orderBy: 'name ASC');
    List<Type> types = [];
    for (var result in results) {
      Type type = Type.fromMap(result);
      types.add(type);
    }
    return types;
  }

  // Inserting and updating a Type
  Future<Type> upsertType(Type type) async {
    Database db = await instance.database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_typeTableName WHERE id = ?", [type.id]));
    if (count == 0) {
      await db.insert(_typeTableName, type.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_typeTableName, type.toMap(), where: "id = ?", whereArgs: [type.id]);
    }
    return type;
  }

  // get filtered list of project types
  Future<List<Type>> getFilteredTypes(String searchTerm) async {
    Database db = await instance.database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT * "
            "FROM $_typeTableName "
            "WHERE name like %$searchTerm%");
    List<Type> types = [];
    for (var result in results) {
      Type type = Type.fromMap(result);
      types.add(type);
    }
    return types;
  }

  // Delete Type
  Future<int> deleteType(Type type) async {
    Database db = await instance.database;
    return await db.delete(
      _typeTableName,
      where: "id = ?",
      whereArgs: [type.id],
    );
  }


  // get a specific type
  Future<Vocabulary> getVocabularyByTitleAndProject(String searchTerm, int projectId) async {
    Database db = await instance.database;
    final map = await db.rawQuery(
        "SELECT * FROM $_vocabularyTableName "
            "WHERE title = '$searchTerm' "
            "AND projectId = $projectId "
            "AND useThis = 1;");
    if (map.isNotEmpty) {
      return Vocabulary.fromMap(map.first);
    } else {
      throw Exception("Vocabulary with title '$searchTerm' not found for this project");
    }
  }

  // Inserting and updating a vocabulary
  Future<Vocabulary> upsertVocabulary(Vocabulary vocabulary) async {
    Database db = await instance.database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_vocabularyTableName WHERE id = ?", [vocabulary.id]));
    if (count == 0) {
      await db.insert(_vocabularyTableName, vocabulary.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_vocabularyTableName, vocabulary.toMap(), where: "id = ?", whereArgs: [vocabulary.id]);
    }
    return vocabulary;
  }



  // get VocabularyView list
  Future<List<VocabularyView>> getVocabularyViews() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
            "p.title AS project, v.title, v.content, v.comment, v.useThis "
            "FROM $_vocabularyTableName v "
            "JOIN $_projectTableName p ON v.projectId = p.id "
            "JOIN $_categoryTableName c ON v.categoryId = c.id");
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  // get filtered VocabularyView list
  Future<List<VocabularyView>> getFilteredVocabularyViews(String searchTerm) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
            "p.title AS project, v.title, v.content, v.comment, v.useThis "
            "FROM $_vocabularyTableName v "
            "JOIN $_projectTableName p ON v.projectId = p.id "
            "JOIN $_categoryTableName c ON v.categoryId = c.id "
            "WHERE v.title like '%$searchTerm%';"
    );
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  // get list of vocabularyViews filtered on title, project and category
  Future<List<VocabularyView>> getFilteredVocabulariesBPAC(String searchTerm, int projectId, int categoryId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
            "p.title AS project, v.title, v.content, v.comment, v.useThis "
            "FROM $_vocabularyTableName v "
            "JOIN $_projectTableName p ON v.projectId = p.id "
            "JOIN $_categoryTableName c ON v.categoryId = c.id "
            "${vocabularyWhereClause(searchTerm, projectId, categoryId)}");
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  // Delete Vocabulary via view
  Future<int> deleteVocabulary(VocabularyView vocabularyView) async {
    Database db = await instance.database;
    return await db.delete(
      _vocabularyTableName,
      where: "id = ?",
      whereArgs: [vocabularyView.id],
    );
  }
}

String vocabularyWhereClause(String searchTerm, int projectId, int categoryId){
  final whereClause = StringBuffer('WHERE 1 = 1 ');
  if (searchTerm.isNotEmpty) {
    whereClause.write("AND v.title like '%$searchTerm%' ");
  }
  if (projectId > 0) {
    whereClause.write("AND v.projectId = $projectId ");
  }
  if (categoryId > 0) {
    whereClause.write("AND v.categoryId = $categoryId ");
  }
  whereClause.write(";");
  return whereClause.toString();
}
