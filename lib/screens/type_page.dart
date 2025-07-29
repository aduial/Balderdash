import 'package:auto_size_text/auto_size_text.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/model/type.dart';
import 'package:flutter/material.dart';

class TypePage extends StatefulWidget {
  const TypePage({super.key});

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  late Future<List<Type>> _types;
  final ScrollController _scrollController = ScrollController();
  int numItems = 0;
  String searchTerm = '';
  Future<int> _getTypeListLength() async {
    return await _types.then((value) {
      return value.length;
    });
  }

  List<Type> filteredTypes = [];

  @override
  void initState() {
    super.initState();
    _refreshTypeList();
  }

  onSearch(String value) {
    searchTerm = value;
    _refreshTypeList();
  }

  void _refreshTypeList() {
    setState(() {
      if (searchTerm == '') {
        _types = DatabaseHelper().getTypes();
      } else {
        _types = DatabaseHelper().getFilteredTypes(searchTerm);
      }
      _getTypeListLength().then((value) {
        setState(() {
          numItems = value;
        });
      });
    });
  }

  void _showForm(Type? type) async {
    final nameController = TextEditingController(text: type?.name);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(type == null ? "New project type" : "Change type name"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text;
              if (name.isNotEmpty) {
                if (type != null) {
                  type?.name = nameController.text;
                } else {
                  type ??= Type.fromMap({"name": nameController.text});
                }
              }
              await DatabaseHelper().upsertType(type!);
              _refreshTypeList();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: yellowNotePaperColour,
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
                hintText: "filter project types",
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: notepaperWhite),
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
        child: FutureBuilder<List<Type>>(
          future: _types,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No project types found'));
            }
            return Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                itemCount: numItems,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final type = snapshot.data![index];
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
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4 * scaling, 0, 2 * scaling, 0),
                            child: AutoSizeText(
                              type.name!,
                              style: TextStyle(color: veryVeryDark),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: yellowAppbarColour,
                            onPressed: () {
                              _showForm(type);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: yellowAppbarColour,
                            onPressed: () async {
                              final bool isDelete =
                                  await showConfirmationAlertDialog(
                                context,
                                title: 'Delete ${type.name!}?',
                                message:
                                    "Do you want to delete project type ${type.name!}? You cannot undo this!",
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                highlightNegative: true,
                              );
                              if (isDelete) {
                                await DatabaseHelper().deleteType(type);
                                _refreshTypeList();
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
        backgroundColor: yellowNotePaperColour,
        child: const Icon(Icons.add),
        onPressed: () {
          _showForm(null);
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
