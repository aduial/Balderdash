import 'package:flutter/material.dart';
import 'package:nonsense/model/type.dart';
import 'package:nonsense/database_helper/database_helper.dart';
import 'package:nonsense/config/colours.dart';
import 'package:nonsense/config/config.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TypePage extends StatefulWidget {
  const TypePage({super.key});

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  late DatabaseHelper dbHelper;
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
    dbHelper = DatabaseHelper.instance;
    _refreshTypeList();
  }

  onSearch(String value) {
    searchTerm = value;
    _refreshTypeList();
  }

  void _refreshTypeList() {
    setState(() {
      if (searchTerm == '') {
        _types = dbHelper.getTypes();
      } else {
        _types = dbHelper.getFilteredTypes(searchTerm);
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
                if (type != null){
                  type?.name = nameController.text;
                } else {
                  type ??= Type.fromMap({
                    "name": nameController.text
                  });
                }
              }
              await dbHelper.upsertType(type!);
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
    var padding = MediaQuery.paddingOf(context);
    double displayHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
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
                hintText: "filter project types",
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: offWhite),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(fontSize: 14, color: notepaperWhite),
              ),
            ),
          )),
      body: FutureBuilder<List<Type>>(
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
                  padding: EdgeInsets.fromLTRB(5.0 * toScale, 2.0 * toScale,
                      5.0 * toScale, 5.0 * toScale),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: toScale, color: tanteRia),
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
                            type.name!,
                            style: TextStyle(
                                color: veryVeryDark
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                              color: veryVeryDark,
                            onPressed: () {
                              _showForm(type);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: veryVeryDark,
                            onPressed: () async {
                              final bool isDelete = await showConfirmationAlertDialog(
                                context,
                                title: 'Delete ${type.name!}?',
                                message: "Do you want to delete project type ${type.name!}? You cannot undo this!" ,
                                positiveText: 'Delete',
                                negativeText: 'Cancel',
                                highlightNegative: true,
                              );
                              if(isDelete){
                                await dbHelper.deleteType(type);
                                _refreshTypeList();
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
  ) ?? false;
}
