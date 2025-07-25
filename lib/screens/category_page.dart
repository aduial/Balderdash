import 'package:auto_size_text/auto_size_text.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/screens/category_detail.dart';
import 'package:balderdash/views/category_view.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late DatabaseHelper dbHelper;
  late Future<List<CategoryView>> _categoryViews;
  final ScrollController _scrollController = ScrollController();
  int numItems = 0;
  String searchTerm = '';
  Future<int> _getCategoryListLength() async {
    return await _categoryViews.then((value) {
      return value.length;
    });
  }

  List<CategoryView> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshCategoryViewList();
  }

  onSearch(String value) {
    searchTerm = value;
    _refreshCategoryViewList();
  }

  void _refreshCategoryViewList() {
    setState(() {
      if (searchTerm == '') {
        _categoryViews = dbHelper.getCategoryViews();
      } else {
        _categoryViews = dbHelper.getFilteredCategoryViews(searchTerm);
      }
      _getCategoryListLength().then((value) {
        setState(() {
          numItems = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: cyanNotePaperColour,
          ),
          backgroundColor: regularResultBGColour,
          title: SizedBox(
            height: 30 * scaling,
            child: TextField(
              style: TextStyle(color: offWhite, fontSize: 16 * scaling),
              onChanged: (value) => onSearch(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: inActiveLargeSetColour,
                hintText: "filter categories",
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: offWhite),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * scaling),
                    borderSide: BorderSide.none),
                hintStyle:
                    TextStyle(fontSize: 14 * scaling, color: notepaperWhite),
              ),
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightBlueGrey, blueGrey],
          ),
        ),
        child: FutureBuilder<List<CategoryView>>(
          future: _categoryViews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found'));
            }
            return Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                itemCount: numItems,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final categoryView = snapshot.data![index];
                  return Container(
                    height: 40 * scaling,
                    padding: EdgeInsets.fromLTRB(
                        5.0 * scaling, 0.0, 5.0 * scaling, 0.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: scaling, color: tanteRia),
                      ),
                      color: notepaperWhite,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4 * scaling, 0, 2 * scaling, 0),
                            child: AutoSizeText(
                              categoryView.parent!,
                              style: TextStyle(color: veryVeryDark),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2 * scaling, 0, 2 * scaling, 0),
                            child: AutoSizeText(
                              categoryView.name!,
                              maxLines: 1,
                              style: TextStyle(color: veryVeryDark),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: cyanAppbarColour,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryDetail(
                                      categoryView: categoryView),
                                ),
                              ).then((value) {
                                setState(() {
                                  _refreshCategoryViewList();
                                });
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: cyanAppbarColour,
                            onPressed: () async {
                              final bool isDelete =
                                  await showConfirmationAlertDialog(
                                context,
                                title: 'Delete ${categoryView.name!}?',
                                message:
                                    "Do you want to delete category ${categoryView.name!}? You cannot undo this!",
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                highlightNegative: true,
                              );

                              if (isDelete) {
                                await dbHelper.deleteCategory(categoryView);
                                _refreshCategoryViewList();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cyanNotePaperColour,
        child: const Icon(Icons.add),
        onPressed: () async {
          CategoryView newCategoryView = CategoryView.fromMap({
            // "id": newVCategory.id,
            "parentId": 1,
            "parent": 'n/a',
            "name": newCategoryName,
            "comment": 'comment'
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CategoryDetail(categoryView: newCategoryView),
            ),
          ).then((value) {
            setState(() {
              _refreshCategoryViewList();
            });
          });
        },
      ),
    );
  }
}

Future<bool> showConfirmationAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String positiveText,
  required String negativeText,
  bool highlightPositive = false,
  bool highlightNegative = false,
}) async {
  return await showDialog<bool>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(
                  negativeText.toUpperCase(),
                  style: highlightNegative
                      ? const TextStyle(color: darkAnyMatchColour)
                      : null,
                ),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: Text(
                  positiveText.toUpperCase(),
                  style: highlightPositive
                      ? const TextStyle(color: Colors.red)
                      : null,
                ),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          );
        },
      ) ??
      false;
}
