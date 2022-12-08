
import 'package:flutter/material.dart';
import 'package:mobile_yp/color_schemes.g.dart';
import 'package:settings_ui/settings_ui.dart';

bool sampleSwitch = true;
TextStyle SettingsTitleTextStyle = TextStyle(
  fontSize: 25,
  color: lightColorScheme.onBackground
);
TextStyle SettingsSubtitleTextStyle = TextStyle(
    fontSize: 15,
    color: lightColorScheme.onSecondaryContainer,

);

class Settings extends StatefulWidget {
  @override


  @override
  State<StatefulWidget> createState() {
    return __SettingsState();
  }
}

class __SettingsState extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: lightColorScheme.background,
      ),
      body:SettingsList(
        lightTheme: SettingsThemeData(
            settingsSectionBackground: lightColorScheme.background,
            settingsListBackground: lightColorScheme.background
        ),
        sections: [
          SettingsSection(
            title: Text("設定",
              style: TextStyle(
                  fontSize: 50,
                  color: lightColorScheme.onBackground
              ),
            ), tiles: [],
          ),
          SettingsSection(
            title: Text("一般",
              style: TextStyle(
                  fontSize: 20,
                  color: lightColorScheme.primary
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('深色模式',style: SettingsTitleTextStyle,),
                value: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text('關閉',style: SettingsSubtitleTextStyle,),
                ),
                onPressed: (context) {

                },
              ),
              SettingsTile.navigation(
                title: Text('主色系',style: SettingsTitleTextStyle,),
                value: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text('延平綠',style: SettingsSubtitleTextStyle,),
                ),
                onPressed: (context) {

                },
              ),
              SettingsTile.navigation(
                title: Text('導覽列排序',style: SettingsTitleTextStyle,),
                onPressed: (context) {

                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    sampleSwitch = value;
                  });
                },
                initialValue: sampleSwitch,
                title: Text('Enable custom theme',style: SettingsTitleTextStyle,),
              ),
            ],
          ),
          SettingsSection(
            title: Text("帳號設定",
              style: TextStyle(
                  fontSize: 20,
                  color: lightColorScheme.primary
              ),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('資訊股長上傳',style: SettingsTitleTextStyle,),
                onPressed: (context) {

                },
              ),
              SettingsTile.navigation(
                title: Text('網路聯絡簿',style: SettingsTitleTextStyle,),
                onPressed: (context) {

                },
              ),

            ],
          ),
        ],
      ),
    );
  }

}