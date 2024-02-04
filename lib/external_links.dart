import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import 'package:settings_ui/settings_ui.dart';

class LinksOpen extends StatefulWidget {
  const LinksOpen({ super.key });

  @override
  State<LinksOpen> createState() => _LinksOpenState();
}

class _LinksOpenState extends State<LinksOpen> {
  @override

  Widget build(BuildContext context) {
    TextStyle SettingsTitleTextStyle = TextStyle(
        fontSize: 25,
        color: Theme.of(context).colorScheme.onBackground
    );
    TextStyle SettingsSubtitleTextStyle = TextStyle(
      fontSize: 15,
      color: Theme.of(context).colorScheme.onSecondaryContainer,

    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("附件、連結"),
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
            children: [
              Text("附件"),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text("hi again")
                  ],
                ),
              )
            ],
          ),
        ),
      )
      );
  }
}