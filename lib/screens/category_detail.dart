import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balderdash/model/category.dart';
import 'package:balderdash/views/category_view.dart';
import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/config/colours.dart';
import 'package:balderdash/config/config.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CategoryDetail extends StatefulWidget {
  final CategoryView categoryView;
  const CategoryDetail({super.key, required this.categoryView});
  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final _parentDDKey = GlobalKey<DropdownSearchState<Category>>();
  final _categoryFormKey = GlobalKey<FormState>();
  late DatabaseHelper dbHelper;
  late Future<List<Category>> _parents;
  late List<CategoryView> cvList;
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController commentController =
      TextEditingController(text: '');

  bool cvListFetched = false;
  bool isExistingCV = false;

  late Category newCategory;
  late int newCategoryId;
  late int newParentId;
  late String newParent;
  late String newName;
  late String newComment;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _refreshLists();
    isExistingCV = (null != widget.categoryView.id);
    newParentId = widget.categoryView.parentId!;
    newParent = widget.categoryView.parent!;
    newName = widget.categoryView.name!;
    newComment =
    widget.categoryView.comment == ""
        ? " "
        : widget.categoryView.comment!;
    if (isExistingCV) {
      newCategoryId = widget.categoryView.id!;
      dbHelper.getCategory(newParentId).then((parent) => _parentDDKey.currentState?.changeSelectedItem(parent));
      }
  }

  void _refreshLists() {
    setState(() {
      _parents = dbHelper.getCategoriesAbove(0);
    });
  }

  setUpdatedParent(int parentId) {
    newParentId = parentId;
  }

  onNameChanged(String name) {
    newName = name;
  }

  initialiseCvList() async {
    if (!cvListFetched) {
      cvList = await dbHelper.getCategoryViews();
      cvListFetched = true;
    }
  }

  onCommentChanged(String comment) async {
    newComment = comment;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.paddingOf(context);
    double displayHeight = MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double deviceScaling = refHeight / displayHeight;
    nameController.text = newName;
    commentController.text = newComment;
    initialiseCvList();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: cyanNotePaperColour,
        ),
        backgroundColor: regularResultBGColour,
        title: Text(
          "Edit ${widget.categoryView.name!}",
          style: TextStyle(color: notepaperWhite),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [notepaperWhite, lightGreenGrey],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Form(
            key: _categoryFormKey,
            child: ListView(padding: EdgeInsets.all(4), children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<Category>(
                      key: _parentDDKey,
                      itemAsString: (item) => item.name!,
                      items: (filter, t) => _parents,
                      onSelected: (Category? item) {
                        setState(() {
                          setUpdatedParent(item!.id!);
                        });
                      },
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                          filled: true,
                          fillColor: offWhite,
                            labelText: 'PARENT CATEGORY',
                          labelStyle:
                              TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                      compareFn: (item, sItem) => item.id == sItem.id,
                      validator: (item) {
                        if (isExistingCV && item?.id == newCategoryId) {
                          return "Sorry, can't self-parent";
                        }
                        return null;
                      },
                      popupProps: PopupProps.modalBottomSheet(
                          showSelectedItems: true,
                          showSearchBox: false,
                          itemBuilder: categoryModalItem),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                      child: TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: offWhite,
                            labelText: 'NAME',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                        maxLines: 1,
                        onChanged: (value) => onNameChanged(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          if (value == newCategoryName) {
                            return "Something else?";
                          }
                          // first find category with the same name
                          List<CategoryView> nameCVList =
                          cvList.where((i) => i.name == value).toList();
                          // of those, take the ones with a different id
                          List<CategoryView> filterCVList =
                          nameCVList.where((j) => j.id != newCategoryId).toList();
                          if (filterCVList.isNotEmpty) {
                            return "'${filterCVList[0].name!}' exist, try again";
                          }
                          return null;
                        },
                      ),
                    ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),
              Row(children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: offWhite,
                        labelText: 'COMMENT',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                    maxLines: 1,
                    onChanged: (value) => onCommentChanged(value),
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                ),
                Expanded(
                  flex: 3,
                  child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: cyanAppbarColour,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () async {
                      if (_categoryFormKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: regularResultBGColour,
                              behavior: SnackBarBehavior.fixed,
                              // margin: EdgeInsets.only(bottom: 0.0),
                              content: Text('Saving category',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              dismissDirection: DismissDirection.none
                          ),
                        );
                        newCategory = Category.fromMap({
                          "id": widget.categoryView.id,
                          "parentId": newParentId,
                          "name": newName,
                          "comment": newComment,
                        });
                        await dbHelper.upsertCategory(newCategory);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Icon(
                        Icons.save,
                    ),
                  ),
                ),
              ]),
            ]
            ),
          ),
        ),
      ),
    );
  }
}

Widget categoryModalItem(
    BuildContext context, Category item, bool isDisabled, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20),
            color: inActiveMinimalSetColour,
          ),
    child: ListTile(
        selected: isSelected,
        dense: true,
        visualDensity: VisualDensity(vertical: -1),
        title: Text(
          item.name!,
          style: TextStyle(
              fontSize: 14,
              color: isSelected ? offWhite : onPrimaryFixed),
        )),
  );
}

class LowerCaseTextFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue){
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}