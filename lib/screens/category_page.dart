import 'package:flutter/material.dart';
import 'package:nonsense/screens/category_detail.dart';
import 'package:nonsense/views/category_view.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    var padding = MediaQuery.paddingOf(context);
    double displayHeight =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double toScale = refHeight / displayHeight;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: notepaperWhite,
          ),
          backgroundColor: regularResultBGColour,
          title: Container(
            height: 30,
            child: TextField(
              style: TextStyle(color: offWhite, fontSize: 16),
              onChanged: (value) => onSearch(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: inActiveLargeSetColour,
                hintText: "filter categories",
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: offWhite),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(fontSize: 14, color: notepaperWhite),
              ),
            ),
          )),
      body: FutureBuilder<List<CategoryView>>(
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
                  padding: EdgeInsets.fromLTRB(5.0 * toScale, 2.0 * toScale,
                      5.0 * toScale, 5.0 * toScale),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: toScale, color: tanteRia),
                    ),
                    color: notepaperWhite,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(4, 0, 2, 0),
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
                              2, 0, 2 * toScale, 0),
                          child: AutoSizeText(
                            categoryView.name!,
                            maxLines: 1,
                            style: TextStyle(color: veryVeryDark),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: veryVeryDark,
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
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: veryVeryDark,
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
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
