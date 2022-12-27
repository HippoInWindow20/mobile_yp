
import 'package:flutter/material.dart';
import 'package:mobile_yp/color_schemes.g.dart';
import 'package:mobile_yp/main.dart';
import 'package:mobile_yp/online_cc.dart';
import 'package:mobile_yp/personal.dart';
import 'package:mobile_yp/public_cc.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:mobile_yp/admin.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool sampleSwitch = true;
Object? setDisplayMode = "深色";
class Settings extends StatefulWidget {
  @override


  @override
  State<StatefulWidget> createState() {
    return __SettingsState();
  }
}

class __SettingsState extends State<Settings>{

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body:SettingsList(
       lightTheme:SettingsThemeData(
            settingsSectionBackground: Theme.of(context).colorScheme.background,
            settingsListBackground: Theme.of(context).colorScheme.background
        ) ,
        sections: [
          SettingsSection(
            title: Text("設定",
              style: TextStyle(
                  fontSize: 50,
                  color: Theme.of(context).colorScheme.onBackground
              ),
            ), tiles: [],
          ),
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
                  child: Text('延平綠',style: SettingsSubtitleTextStyle,),
                ),
                onPressed: (context) {

                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.reorder_outlined),
                title: Text('導覽列排序',style: SettingsTitleTextStyle,),
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
                            return adminPage();
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
                      await prefs.setString("savedValue", value.toString());

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
        await prefs.setString("savedValue", value.toString());
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