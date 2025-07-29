import 'package:balderdash/database_helper/database_helper.dart';
import 'package:balderdash/model/project.dart';
import 'package:balderdash/views/vocabulary_view.dart';
import 'package:flutter/material.dart';

class ProjectDropdown extends StatefulWidget {
  const ProjectDropdown({super.key, required this.vocabularyView});
  final VocabularyView vocabularyView;
  @override
  State<ProjectDropdown> createState() => _ProjectDropdownState();
}

class _ProjectDropdownState extends State<ProjectDropdown> {
  late Future<List<Project>> projects;
  var _selectedValue;

  @override
  void initState() {
    super.initState();
    _getProjectList();
    // late Category _selected;
  }

  void _getProjectList() {
    setState(() {
      projects = DatabaseHelper().getProjectsAbove(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    late Project? selected;
    return FutureBuilder<List<Project>>(
        future: projects,

        // initialData: categories.el,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Text('');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                );
              } else {
                return DropdownButton(
                  value: _selectedValue,
                  onChanged: (dynamic newValue) {
                    setState(() {
                      _selectedValue = newValue;
                    });
                  },
                  items: snapshot.data
                      ?.map<DropdownMenuItem<Project>>((Project selected) {
                    return DropdownMenuItem<Project>(
                      value: selected,
                      child: Text(selected.title!),
                    );
                  }).toList(),
                );
              }
          }
        });
  }
}
