import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'admin_list.dart';

class TagsPage extends StatefulWidget {
  @override
  TagsPage({
    required this.tag,
  });
  final String tag;
  State<StatefulWidget> createState() {
    return stateTagsPage(tag: tag);
  }
}


class stateTagsPage extends State {
  stateTagsPage({
    required this.tag,
  });
  final String tag;
  void setStateFunc () {
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("標籤： " + tag),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}