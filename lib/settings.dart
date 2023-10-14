
import 'package:flutter/material.dart';
import 'package:mobile_yp/themes/blue.dart';
import 'package:mobile_yp/themes/green.dart';
import 'package:mobile_yp/main.dart';
import 'package:mobile_yp/personal.dart';
import 'package:mobile_yp/themes/orange.dart';
import 'package:mobile_yp/themes/purple.dart';
import 'package:mobile_yp/themes/red.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:mobile_yp/admin.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool sampleSwitch = true;
Object? setDisplayMode = "系統預設";
Object? setColourMode = "延平綠";
class Settings extends StatefulWidget {
  @override
  Settings({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;

  @override
  State<StatefulWidget> createState() {
    return __SettingsState(setStateCallBack: setStateCallBack);
  }
}

class __SettingsState extends State<Settings>{
  __SettingsState({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  void setStateExtend (){
    setState(() {
    });
  }


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
      body:SettingsList(
       lightTheme:SettingsThemeData(
            settingsSectionBackground: Theme.of(context).colorScheme.background,
            settingsListBackground: Theme.of(context).colorScheme.background
        ) ,
        sections: [

          // SettingsSection(
          //   tiles: <SettingsTile>[
          //     SettingsTile.navigation(
          //       leading: Icon(Icons.account_circle_outlined),
          //       title: Text('Username',style: SettingsTitleTextStyle,),
          //       description: Text("學號：12345678\n導班：1234"),
          //       onPressed: (context) {
          //
          //       },
          //     ),
          //
          //   ],
          // ),

          SettingsSection(
            title: Text("一般",
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.contrast_outlined),
                title: Text('主題',style: SettingsTitleTextStyle,),
                value: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(setDisplayMode.toString(),style: SettingsSubtitleTextStyle,),
                ),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(10),
                          title: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("主題"),
                          ),
                          content: ModeSelection(setStateCallBack: setStateExtend,),
                        );
                      }
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.palette_outlined),
                title: Text('主色系',style: SettingsTitleTextStyle,),
                value: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(setColourMode.toString(),style: SettingsSubtitleTextStyle,),
                ),
                onPressed: (context) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(10),
                          title: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("主色系"),
                          ),
                          content: ColourSelection(setStateCallBack: setStateExtend,),
                        );
                      }
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.format_size_outlined),
                title: Text('字體大小',style: SettingsTitleTextStyle,),
                value: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("系統預設",style: SettingsSubtitleTextStyle,),
                ),
                onPressed: (context) {

                },
              ),
            ],
          ),
          SettingsSection(
            title: Text("帳號設定",
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.admin_panel_settings_outlined),
                title: Text('資訊股長上傳',style: SettingsTitleTextStyle,),
                onPressed: (context) {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) {
                            return adminPage(setStateCallBack: setStateCallBack);
                          }
                      )
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.contact_mail_outlined),
                title: Text('個人資訊',style: SettingsTitleTextStyle,),
                onPressed: (context) {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) {
                            return personal();
                          }
                      )
                  );
                },
              )

            ],
          ),
          SettingsSection(
            title: Text("",
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.info_outlined),
                title: Text('關於應用程式',style: SettingsTitleTextStyle,),
                description: Text(
                  "版本 1.2.1",
                  style: SettingsSubtitleTextStyle,
                ),
                onPressed: (context) {
                  showAboutDialog(
                      context: context,
                    applicationVersion: "1.2.1",
                    applicationLegalese: "The school's IT team has changed the majority of the layout, making it a fucking pain the ass to code."
                  );
                },
              ),

            ],
          ),
        ],
      ),
    );
  }

}

class ModeSelection extends StatefulWidget {
  ModeSelection({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  @override
  State<StatefulWidget> createState() {
    return __ModeSelection(setStateCallBack: setStateCallBack);
  }

}

class __ModeSelection extends State<ModeSelection>{
   __ModeSelection({
    required this.setStateCallBack,
  });

  final Function setStateCallBack;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        RadioItem(setStateFunction: setStateCallBack,value: "淺色",thememode: ThemeMode.light,),
        RadioItem(setStateFunction: setStateCallBack,value: "深色",thememode: ThemeMode.dark,),
        RadioItem(setStateFunction: setStateCallBack,value: "系統預設",thememode: ThemeMode.system,),
      ],
    );
  }
}

class RadioItem extends StatefulWidget {
  RadioItem({
    required this.setStateFunction,
    required this.value,
    required this.thememode
  });
  final Function setStateFunction;
  final Object value;
  final ThemeMode thememode;
  @override
  State<StatefulWidget> createState() {
    return __RadioItem(value: value,setStateFunc: setStateFunction, thememode: thememode);
  }


}

class __RadioItem  extends State<RadioItem>{
  __RadioItem({
    required this.setStateFunc,
    required this.value,
    required this.thememode,
  });
  final Function setStateFunc;
  final Object value;
  final ThemeMode thememode;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Container(
          width: 250,
          child: Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: value,
                    groupValue: setDisplayMode,
                    onChanged: (value) async {
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.setString("savedTheme", value.toString());

                      setState(() {
                        setDisplayMode = value;
                      });
                      setStateFunc();
                      Navigator.pop(context);
                      MobileYP.of(context).changeTheme(thememode);
                    }
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                    fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () async {
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("savedTheme", value.toString());
        setState(() {
          setDisplayMode = value;
        });
        setStateFunc();
        Navigator.pop(context);
        MobileYP.of(context).changeTheme(thememode);
      },
    );
  }
}

//Colour Selection

class ColourSelection extends StatefulWidget {
  ColourSelection({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  @override
  State<StatefulWidget> createState() {
    return __ColourSelection(setStateCallBack: setStateCallBack);
  }

}

class __ColourSelection extends State<ColourSelection>{
  __ColourSelection({
    required this.setStateCallBack,
  });

  final Function setStateCallBack;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        RadioItemColour(setStateFunction: setStateCallBack,value: "延平綠",colour: green,),
        RadioItemColour(setStateFunction: setStateCallBack,value: "深夜藍",colour: blue,),
        RadioItemColour(setStateFunction: setStateCallBack,value: "低調紫",colour: purple,),
        RadioItemColour(setStateFunction: setStateCallBack,value: "熱血紅",colour: red,),
        RadioItemColour(setStateFunction: setStateCallBack,value: "陽光橘",colour: orange,),
      ],
    );
  }
}

class RadioItemColour extends StatefulWidget {
  RadioItemColour({
    required this.setStateFunction,
    required this.value,
    required this.colour
  });
  final Function setStateFunction;
  final Object value;
  final List<ColorScheme> colour;
  @override
  State<StatefulWidget> createState() {
    return __RadioItemColour(value: value,setStateFunc: setStateFunction, colour: colour);
  }


}

class __RadioItemColour  extends State<RadioItemColour>{
  __RadioItemColour({
    required this.setStateFunc,
    required this.value,
    required this.colour,
  });
  final Function setStateFunc;
  final Object value;
  final List<ColorScheme> colour;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Container(
          width: 250,
          child: Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: value,
                    groupValue: setColourMode,
                    onChanged: (value) async {
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.setString("savedCS", value.toString());

                      setState(() {
                        setColourMode = value;
                      });
                      setStateFunc();
                      Navigator.pop(context);
                      MobileYP.of(context).changeColour(colour);
                    }
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                    fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () async {
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("savedCS", value.toString());
        setState(() {
          setColourMode = value;
        });
        setStateFunc();
        Navigator.pop(context);
        MobileYP.of(context).changeColour(colour);
      },
    );
  }
}