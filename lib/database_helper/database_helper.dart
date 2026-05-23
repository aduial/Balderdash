import 'dart:async';
import 'dart:io' as io;

import 'package:balderdash/model/author.dart';
import 'package:balderdash/model/category.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/model/template.dart';
import 'package:balderdash/model/type.dart';
import 'package:balderdash/model/vocabulary.dart';
import 'package:balderdash/views/category_view.dart';
import 'package:balderdash/views/project_view.dart';
import 'package:balderdash/views/template_view.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = "balderdash.db";
  static final _dbVersion = 1;
  static final _typeTableName = "type";
  static final _authorTableName = "author";
  static final _projectTableName = "project";
  static final _templateTableName = "template";
  static final _categoryTableName = "category";
  static final _vocabularyTableName = "vocabulary";

  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  late io.Directory documentsDirectory;
  late String dbPath;
  late bool dbExists;

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  // return database if already available in App directory
  // else, copy from assets folder to app directory
  Future<Database> _initDB() async {
    // check if database is present in application doc directory
    documentsDirectory = await getApplicationDocumentsDirectory();
    dbPath = join(documentsDirectory.path, _dbName);
    dbExists = await io.File(dbPath).exists();

    // print("hier");
    print(dbPath);
    // if no database found
    if (!dbExists) {
      // Copy from asset directory
      ByteData data = await rootBundle.load(join("assets", _dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await io.File(dbPath).writeAsBytes(bytes, flush: true);
    }
    //return database
    return await openDatabase(
        dbPath,
        version: 4,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // rename column to repurpose as Markov indicator
      await db.execute('ALTER TABLE vocabulary RENAME COLUMN useThis TO isCFG;');
    }
    if (oldVersion < 3) {
      // rename column to repurpose as Markov indicator
      await db.execute("INSERT INTO category (id, parentId, name, comment) VALUES(19, 1, 'Markov', NULL);");
    }
  }

  // Future<void> makeBackup(bool withTimestamp) async {
  //   io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String dbPath = join(documentsDirectory.path, _dbName);
  //   int timestamp = DateTime.now().millisecondsSinceEpoch;
  //   // io.File(dbPath).copy("backup/database.db.$timestamp");
  //   if (withTimestamp) {
  //     io.File(dbPath).copy(
  //         "/Users/luthien/git/aduial/balderdash/backup/balderdash.db.$timestamp");
  //   } else {
  //     io.File(dbPath)
  //         .copy("/Users/luthien/git/aduial/balderdash/backup/balderdash.db");
  //   }
  // }

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
        content TEXT NOT NULL DEFAULT "<html><head></head><body></body></html>",
        isHtml INTEGER NOT NULL DEFAULT 1,
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
        isCFG INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY(projectId) REFERENCES $_projectTableName(id)
        FOREIGN KEY(categoryId) REFERENCES $_categoryTableName(id)
        UNIQUE(projectId, title)
      )
      ''');
  }

  // get list of authors
  Future<List<Author>> getAuthors() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db.query(_authorTableName, orderBy: 'name ASC');
    List<Author> authors = [];
    for (var result in results) {
      Author author = Author.fromMap(result);
      authors.add(author);
    }
    return authors;
  }

  // get Category
  Future<Author> getAuthor(int id) async {
    final db = await database;
    final map = await db.rawQuery(
        "SELECT * FROM $_authorTableName WHERE "
        "id = ? "
        "ORDER BY id asc; ",
        [id]);
    if (map.isNotEmpty) {
      return Author.fromMap(map.first);
    } else {
      throw Exception("Author with ID $id not found");
    }
  }

  // get filtered list of Authors
  Future<List<Author>> getFilteredAuthors(String searchTerm) async {
    final db = await database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT * "
        "FROM $_authorTableName "
        "WHERE name like %?% ",
        [searchTerm]);
    List<Author> authors = [];
    for (var result in results) {
      Author author = Author.fromMap(result);
      authors.add(author);
    }
    return authors;
  }

  // Inserting and updating an Author
  Future<Author> upsertAuthor(Author author) async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_authorTableName WHERE id = ?;", [author.id]));
    if (count == 0) {
      await db.insert(_authorTableName, author.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_authorTableName, author.toMap(),
          where: "id = ?", whereArgs: [author.id]);
    }
    return author;
  }

  // Delete Author
  Future<int> deleteAuthor(Author author) async {
    final db = await database;
    return await db.delete(
      _authorTableName,
      where: "id = ?",
      whereArgs: [author.id],
    );
  }

  // Inserting and updating a category
  Future<Category> upsertCategory(Category category) async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_categoryTableName WHERE id = ?;",
        [category.id]));
    if (count == 0) {
      await db.insert(_categoryTableName, category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_categoryTableName, category.toMap(),
          where: "id = ?", whereArgs: [category.id]);
    }
    return category;
  }

  // get Category
  Future<Category> getCategory(int id) async {
    final db = await database;
    final map = await db.rawQuery(
        "SELECT * FROM $_categoryTableName WHERE "
        "id = ? "
        "ORDER BY id asc; ",
        [id]);
    if (map.isNotEmpty) {
      return Category.fromMap(map.first);
    } else {
      throw Exception("Category with ID $id not found");
    }
  }

  // get list of categories
  Future<List<Category>> getCategoriesAbove(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      "SELECT * FROM $_categoryTableName WHERE "
      "id > $id "
      "ORDER BY id asc; ",
    );
    List<Category> categories = [];
    for (var result in results) {
      Category category = Category.fromMap(result);
      categories.add(category);
    }
    return categories;
  }

  // get list of CategoryViews
  Future<List<CategoryView>> getCategoryViews() async {
    final db = await database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT c.id, c.parentId, IFNULL(cp.name, 'n/a') AS parent, c.name, c.comment "
        "FROM $_categoryTableName c "
        "LEFT OUTER JOIN $_categoryTableName cp ON c.parentId = cp.id; ");
    List<CategoryView> categoryViews = [];
    for (var result in results) {
      CategoryView categoryView = CategoryView.fromMap(result);
      categoryViews.add(categoryView);
    }
    return categoryViews;
  }

  // get filtered list of CategoryViews
  Future<List<CategoryView>> getFilteredCategoryViews(String searchTerm) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT c.id, c.parentId, IFNULL(cp.name, 'n/a') AS parent, c.name, c.comment "
        "FROM $_categoryTableName c "
        "LEFT OUTER JOIN $_categoryTableName cp ON c.parentId = cp.id "
        "WHERE c.name like '%$searchTerm%'; ");
    List<CategoryView> categoryViews = [];
    for (var result in results) {
      CategoryView categoryView = CategoryView.fromMap(result);
      categoryViews.add(categoryView);
    }
    return categoryViews;
  }

  // get children of a parent category
  Future<List<Category>> getChildCategories(int parentId) async {
    final db = await database;
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
    final db = await database;
    return await db.delete(
      _categoryTableName,
      where: "id = ?",
      whereArgs: [categoryView.id],
    );
  }

  // Inserting and updating a Project
  Future<Project> upsertProject(Project project) async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_projectTableName WHERE id = ?", [project.id]));
    if (count == 0) {
      await db.insert(_projectTableName, project.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_projectTableName, project.toMap(),
          where: "id = ?", whereArgs: [project.id]);
    }
    return project;
  }

  // get list of projects starting at id = ?
  Future<List<Project>> getProjectsAbove(int id, bool noNonsense) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT * FROM $_projectTableName WHERE id > ? "
            "AND typeId > ${noNonsense ? 1 : 0} "
            "ORDER BY id ASC; ", [id]);
    List<Project> projects = [];
    for (var result in results) {
      Project project = Project.fromMap(result);
      projects.add(project);
    }
    return projects;
  }

  // get a specific project
  Future<Project> getProject(int id) async {
    final db = await database;
    final map = await db
        .rawQuery("SELECT * FROM $_projectTableName WHERE id = ?", [id]);
    if (map.isNotEmpty) {
      return Project.fromMap(map.first);
    } else {
      throw Exception("Project with ID $id not found");
    }
  }

  // get a specific project
  Future<Project?> getProjectByTitle(String title) async {
    final db = await database;
    final map = await db.rawQuery(
        "SELECT * FROM $_projectTableName WHERE lower(title) = ?", [title]);
    if (map.isNotEmpty) {
      return Project.fromMap(map.first);
    } else {
      return null;
    }
  }

  // get list of Project views above id = 1
  Future<List<ProjectView>> getProjectViews(bool noNonsense) async {
    final db = await database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT p.id, p.typeId, t.name AS type, p.authorId, a.name AS author, p.title, p.notes "
        "FROM $_projectTableName p "
        "JOIN $_typeTableName t ON p.typeId = t.id "
        "JOIN $_authorTableName a ON p.authorId = a.id "
        "WHERE typeId > ${noNonsense ? 1 : 0}; ");
    List<ProjectView> projectViews = [];
    for (var result in results) {
      ProjectView projectView = ProjectView.fromMap(result);
      projectViews.add(projectView);
    }
    return projectViews;
  }

  // get filtered list of Project views
  Future<List<ProjectView>> getFilteredProjectViews(String searchTerm, bool noNonsense) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT p.id, p.typeId, t.name AS type, p.authorId, a.name AS author, p.title, p.notes "
        "FROM $_projectTableName p "
        "JOIN $_typeTableName t ON p.typeId = t.id "
        "JOIN $_authorTableName a ON p.authorId = a.id "
        "WHERE p.title like '%$searchTerm%'; "
        "AND typeId > ${noNonsense ? 1 : 0} ");
    List<ProjectView> projectViews = [];
    for (var result in results) {
      ProjectView projectView = ProjectView.fromMap(result);
      projectViews.add(projectView);
    }
    return projectViews;
  }

  // get a specific projectView
  Future<ProjectView> getProjectView(int id) async {
    final db = await database;
    final map = await db.rawQuery(
        "SELECT p.id, p.typeId, t.name AS type, p.authorId, a.name AS author, p.title, p.notes "
        "FROM $_projectTableName p "
        "JOIN $_typeTableName t ON p.typeId = t.id "
        "JOIN $_authorTableName a ON p.authorId = a.id "
        "WHERE p.id = ?;",
        [id]);
    if (map.isNotEmpty) {
      return ProjectView.fromMap(map.first);
    } else {
      throw Exception("Project with ID $id not found");
    }
  }

  // get list of projects of a certain type
  Future<List<Project>> getProjectsByType(int typeId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(_projectTableName,
        where: "typeId = ?", whereArgs: [typeId], orderBy: 'title ASC');
    List<Project> projects = [];
    for (var result in results) {
      Project project = Project.fromMap(result);
      projects.add(project);
    }
    return projects;
  }

  // get list of all projects of a certain author
  Future<List<Project>> getProjectsByAuthor(int authorId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(_projectTableName,
        where: "authorId = ?", whereArgs: [authorId], orderBy: 'title ASC');
    List<Project> projects = [];
    for (var result in results) {
      Project project = Project.fromMap(result);
      projects.add(project);
    }
    return projects;
  }

  // Delete Project by View
  Future<int> deleteProject(ProjectView project) async {
    final db = await database;
    return await db.delete(
      _projectTableName,
      where: "id = ?",
      whereArgs: [project.id],
    );
  }

  // Inserting and updating a Template
  Future<Template> upsertTemplate(Template template) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT * FROM $_templateTableName WHERE projectId = ? "
        "AND title = ? AND isHtml = ?",
        [template.projectId, template.title, template.isHtml]);
    var count = results.length;
    if (count == 0) {
      await db.insert(_templateTableName, template.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      if (results.isNotEmpty) {
        Template foundTemplate = Template.fromMap(results.first);
        template.id = foundTemplate.id;
        await db.update(_templateTableName, template.toMap(),
            where: 'id = ?', whereArgs: [template.id]);
      }
    }
    return template;
  }

  // get list of templates
  Future<List<Template>> getTemplates() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db.query(_templateTableName, orderBy: 'id ASC');
    List<Template> templates = [];
    for (var result in results) {
      Template template = Template.fromMap(result);
      templates.add(template);
    }
    return templates;
  }

  // get list of templateviews
  Future<List<TemplateView>> getTemplateViews() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT t.id, t.projectId, p.title AS project, t.title, t.content, t.isHtml, t.notes "
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
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT t.id, t.projectId, p.title AS project, t.title, t.content, t.isHtml, t.notes "
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

  // get Template by title and projectId
  Future<List<Template>> getTemplatesByProject(int projectId) async {
    final db = await database;
    final results = await db.rawQuery("SELECT * FROM $_templateTableName "
        "WHERE projectId = $projectId "
        "ORDER BY id asc; ");
    List<Template> templates = [];
    for (var result in results) {
      Template template = Template.fromMap(result);
      templates.add(template);
    }
    return templates;
  }

  Future<bool> anyTemplatesForProject(int projectId) async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_templateTableName WHERE projectId = ?",
        [projectId]));
    return (count! > 0);
  }

  // Delete Template
  Future<int> deleteTemplate(TemplateView template) async {
    final db = await database;
    return await db.delete(
      _templateTableName,
      where: "id = ?",
      whereArgs: [template.id],
    );
  }

  // get a specific type
  Future<Type> getType(int id) async {
    final db = await database;
    final map =
        await db.rawQuery("SELECT * FROM $_typeTableName WHERE id = ?", [id]);
    if (map.isNotEmpty) {
      return Type.fromMap(map.first);
    } else {
      throw Exception("Type with ID $id not found");
    }
  }

  // get list of types
  Future<List<Type>> getTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db.query(_typeTableName, orderBy: 'name ASC');
    List<Type> types = [];
    for (var result in results) {
      Type type = Type.fromMap(result);
      types.add(type);
    }
    return types;
  }

  // Inserting and updating a Type
  Future<Type> upsertType(Type type) async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $_typeTableName WHERE id = ?", [type.id]));
    if (count == 0) {
      await db.insert(_typeTableName, type.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update(_typeTableName, type.toMap(),
          where: "id = ?", whereArgs: [type.id]);
    }
    return type;
  }

  // get filtered list of project types
  Future<List<Type>> getFilteredTypes(String searchTerm) async {
    final db = await database;
    // final List<Map<String, dynamic>> results = await db.query(_vocabularyTableName, orderBy: 'title ASC');
    final List<Map<String, dynamic>> results = await db.rawQuery("SELECT * "
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
    final db = await database;
    return await db.delete(
      _typeTableName,
      where: "id = ?",
      whereArgs: [type.id],
    );
  }

  // get a specific type
  Future<Vocabulary> getVocabulary(int id) async {
    final db = await database;
    final map = await db
        .rawQuery("SELECT * FROM $_vocabularyTableName WHERE id = ?", [id]);
    if (map.isNotEmpty) {
      return Vocabulary.fromMap(map.first);
    } else {
      throw Exception("Vocabulary with ID $id not found");
    }
  }

  // copy vocabularies with ID in supplied List to another project
  Future<int> batchCopyVocabularies(
      List<int> vocsToCopy, int newProjectId) async {
    int i = 0;
    for (int vocId in vocsToCopy) {
      Vocabulary voc = await getVocabulary(vocId);
      Vocabulary voCopy = copyVocToProject(voc, newProjectId);
      await upsertVocabulary(voCopy);
      i++;
    }
    return i;
  }

  // move vocabularies with ID in supplied List to another project
  Future<int> batchMoveVocabularies(
      List<int> vocsToMove, int newProjectId) async {
    int i = 0;
    for (int vocId in vocsToMove) {
      Vocabulary voc = await getVocabulary(vocId);
      voc.projectId = newProjectId;
      await upsertVocabulary(voc);
      i++;
    }
    return i;
  }

  // Inserting and updating a vocabulary
  Future<Vocabulary> upsertVocabulary(Vocabulary vocabulary) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT * FROM $_vocabularyTableName WHERE projectId = ? "
        "AND title = ?; ",
        [vocabulary.projectId, vocabulary.title]);
    var count = results.length;
    if (count == 0) {
      // print("insert");
      vocabulary.id = await db.insert(_vocabularyTableName, vocabulary.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      if (results.isNotEmpty) {
        // print("update");
        Vocabulary foundTemplate = Vocabulary.fromMap(results.first);
        vocabulary.id = foundTemplate.id;
        await db.update(_vocabularyTableName, vocabulary.toMap(),
            where: 'id = ?', whereArgs: [vocabulary.id]);
      }
    }
    return vocabulary;
  }

  Vocabulary copyVocToProject(Vocabulary from, int projectId) {
    return Vocabulary.fromMap({
      "categoryId": from.categoryId,
      "projectId": projectId,
      "title": from.title,
      "content": from.content,
      "comment": from.comment,
      "isCFG": from.isCFG,
    });
  }

  Future<List<VocabularyView>> getVocabularyViewByTitle(String title) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db
        .rawQuery("SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
        "p.title AS project, v.title, v.content, v.comment, v.isCFG "
        "FROM $_vocabularyTableName v "
        "JOIN $_projectTableName p ON v.projectId = p.id "
        "JOIN $_categoryTableName c ON v.categoryId = c.id "
        "WHERE upper(v.title) = '$title'; ");
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  // get VocabularyView list
  Future<List<VocabularyView>> getVocabularyViews() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db
        .rawQuery("SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
            "p.title AS project, v.title, v.content, v.comment, v.isCFG "
            "FROM $_vocabularyTableName v "
            "JOIN $_projectTableName p ON v.projectId = p.id "
            "JOIN $_categoryTableName c ON v.categoryId = c.id "
            "ORDER BY v.projectId asc, v.title asc; ");
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  // get VocabularyViews containing a string
  Future<List<VocabularyView>> getVocabularyViewsContaining(String searchTerm) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db
        .rawQuery("SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
        "p.title AS project, v.title, v.content, v.comment, v.isCFG "
        "FROM $_vocabularyTableName v "
        "JOIN $_projectTableName p ON v.projectId = p.id "
        "JOIN $_categoryTableName c ON v.categoryId = c.id "
        "WHERE v.content like '%$searchTerm%' "
        "ORDER BY v.projectId asc, v.title asc; ");
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  Future<List<VocabularyView>> getVocabularyViewList(Set<int> usingSet) async {
    List<VocabularyView> vocabularyViews = [];
    for (int id in usingSet) {
      vocabularyViews.add(await getVocabularyView(id));
    }
    return vocabularyViews;
    // return Future.value(vocabularyViews);
  }

  // get single VocabularyView
  Future<VocabularyView> getVocabularyView(int id) async {
    final db = await database;
    final map = await db.rawQuery(
        "SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
        "p.title AS project, v.title, v.content, v.comment, v.isCFG "
        "FROM $_vocabularyTableName v "
        "JOIN $_projectTableName p ON v.projectId = p.id "
        "JOIN $_categoryTableName c ON v.categoryId = c.id "
        "WHERE v.id = ?;",
        [id]);
    if (map.isNotEmpty) {
      return VocabularyView.fromMap(map.first);
    } else {
      throw Exception("VocabularyView with ID $id not found");
    }
  }

  // get filtered VocabularyView list
  Future<List<VocabularyView>> getFilteredVocabularyViews(
      String searchTerm) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db
        .rawQuery("SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
            "p.title AS project, v.title, v.content, v.comment, v.isCFG "
            "FROM $_vocabularyTableName v "
            "JOIN $_projectTableName p ON v.projectId = p.id "
            "JOIN $_categoryTableName c ON v.categoryId = c.id "
            "WHERE v.title like '%$searchTerm%' "
            "ORDER BY v.projectId asc, v.title asc; ");
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  // get Vocabulary by title and projectId
  Future<List<Vocabulary>> getVocabulariesByProject(int projectId) async {
    final db = await database;
    final results = await db.rawQuery("SELECT * FROM $_vocabularyTableName "
        "WHERE projectId = $projectId "
        "AND content != '' "
        "ORDER BY id asc; ");
    List<Vocabulary> vocabularies = [];
    for (var result in results) {
      Vocabulary vocabulary = Vocabulary.fromMap(result);
      vocabularies.add(vocabulary);
    }
    return vocabularies;
  }

  // get Library Vocabulary used by Project <projectId> Library
  // note that the NOT EXISTS clause prevents including Library
  // vocabularies with the same title as project vocabularies
  Future<List<Vocabulary>> getUsedLibraryVocabularies(int projectId) async {
    final db = await database;
    final results = await db.rawQuery(
        "SELECT * FROM $_vocabularyTableName AS lvoc "
        "WHERE EXISTS ( "
          "SELECT * FROM vocabulary AS pvoc "
            "WHERE ( upper(pvoc.content) LIKE '%{' || lvoc.title || '}%' "
                 "OR upper(pvoc.content) LIKE '%{^' || lvoc.title || '}%' ) "
            "AND pvoc.projectId = $projectId) "
        "AND NOT EXISTS ( "
            "SELECT * FROM vocabulary AS pvoc "
            "WHERE lvoc.title = pvoc.title "
            "AND pvoc.projectId = $projectId) "
        "AND lvoc.projectId = 1");
    List<Vocabulary> vocabularies = [];
    for (var result in results) {
      Vocabulary vocabulary = Vocabulary.fromMap(result);
      vocabularies.add(vocabulary);
    }
    return vocabularies;
  }

  // get Vocabulary by title and projectId, Library (projectId = 1) always included
  Future<List<Vocabulary>> getVocabularyByTitleAndProject(
      String searchTerm, int projectId) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT * FROM $_vocabularyTableName "
        "WHERE title = '$searchTerm' "
        "AND (projectId = $projectId OR projectId = 1) "
        "AND isCFG = 1;");
    List<Vocabulary> vocabularies = [];
    for (var result in results) {
      Vocabulary vocabulary = Vocabulary.fromMap(result);
      vocabularies.add(vocabulary);
    }
    return vocabularies;
  }

  // get Vocabulary by title and projectId, Library (projectId = 1) always included
  Future<Vocabulary> getSingleVocabByTitleAndProject(
      String searchTerm, int projectId) async {
    final db = await database;
    final map = await db.rawQuery("SELECT * FROM $_vocabularyTableName "
        "WHERE title = '$searchTerm' "
        "AND (projectId = $projectId OR projectId = 1) "
        "AND isCFG = 1;");
    if (map.isNotEmpty) {
      return Vocabulary.fromMap(map.first);
    } else {
      throw Exception(
          "Vocabulary with title '$searchTerm' not found for this project");
    }
  }


  // get list of vocabularyViews filtered on title, project and category
  Future<List<VocabularyView>> getFilteredVocabulariesBPAC(
      String searchTerm, int projectId, int categoryId, bool findUsage, bool showNoNonsense) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
        "SELECT v.id, v.categoryId, c.name AS category, v.projectId, "
        "p.title AS project, v.title, v.content, v.comment, v.isCFG "
        "FROM $_vocabularyTableName v "
        "JOIN $_projectTableName p ON v.projectId = p.id "
        "JOIN $_categoryTableName c ON v.categoryId = c.id "
        "${vocabularyWhereClause(searchTerm, projectId, categoryId, findUsage, showNoNonsense)}");
    List<VocabularyView> vocabularyViews = [];
    for (var result in results) {
      VocabularyView vocabularyView = VocabularyView.fromMap(result);
      vocabularyViews.add(vocabularyView);
    }
    return vocabularyViews;
  }

  // get Vocabulary by title and projectId, Library (projectId = 1) always included
  Future<Vocabulary> getVocabularyById(int id) async {
    final db = await database;
    final map = await db.rawQuery("SELECT * FROM $_vocabularyTableName "
        "WHERE id = '$id'; ");
    if (map.isNotEmpty) {
      return Vocabulary.fromMap(map.first);
    } else {
      throw Exception(
          "Vocabulary with ID '$id' not found");
    }
  }

  // Delete Vocabulary via id
  Future<int> deleteVocabularyById(int id) async {
    final db = await database;
    return await db.delete(
      _vocabularyTableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Delete Vocabulary via view
  Future<int> deleteVocabulary(VocabularyView vocabularyView) async {
    final db = await database;
    return await db.delete(
      _vocabularyTableName,
      where: "id = ?",
      whereArgs: [vocabularyView.id],
    );
  }

  // Delete Vocabularies for Project
  Future<void> deleteProjectVocabularies(int projectId) async {
    final db = await database;
    await db.delete(
      _vocabularyTableName,
      where: "projectId = ?",
      whereArgs: [projectId],
    );
  }

  String vocabularyWhereClause(
      String searchTerm, int projectId, int categoryId, bool findUsage, bool showNoNonsense) {
    final whereClause = StringBuffer('WHERE 1 = 1 ');
    String orderByClause = '';
    if (findUsage && searchTerm.isNotEmpty) {
      whereClause.write(
          "AND (lower(v.content) like '%:=$searchTerm}%' OR lower(v.content) like '%{^$searchTerm}%' OR lower(v.content) like '%{$searchTerm}%')");
      if (projectId > 1){
        whereClause.write(" AND v.projectId = $projectId; ");
      } else {
        whereClause.write("; ");
      }

          // "AND (v.content like '%{$searchTerm}%' OR v.content like '%{^$searchTerm}%') "
          // "AND (v.projectId = $projectId OR v.projectId = 1); ");
    } else {
      if (searchTerm.isNotEmpty) {
        whereClause.write("AND v.title like '%$searchTerm%' ");
      }
      if (projectId > 1) {
        // always include Library vocabularies (projectId = 1)
        whereClause.write("AND (v.projectId = $projectId OR v.projectId = 1) ");
        orderByClause =
            "ORDER BY v.projectId desc, v.categoryId asc, v.title asc;";
      } else {
        orderByClause =
            "ORDER BY v.projectId asc, v.categoryId asc, v.title asc;";
      }
      if (categoryId > 1) {
        whereClause.write("AND v.categoryId = $categoryId ");
      }
      if (showNoNonsense){
        whereClause.write("AND p.typeId > 1 ");
      }
    }
    whereClause.write(orderByClause);
    return whereClause.toString();
  }

// insert from import sql
  Future<void> executeQuery(String sql) async {
    final db = await database;
    await db.rawQuery(sql);
  }

  Future<int> insertAndGetId(String sql) async {
    final db = await database;
    return await db.rawInsert(sql);
  }

  // Future insertVoc(String sql) async {
  //   Database db = await instance.database;
  //   try {
  //     await db.rawInsert(sql);
  //   } on DatabaseException catch (e) {
  //     if (e.isUniqueConstraintError()) {
  //       await _update(product);
  //     }
  //   }
  // }
}
