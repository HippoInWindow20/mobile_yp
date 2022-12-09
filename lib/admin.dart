
import 'package:flutter/material.dart';
import 'package:mobile_yp/color_schemes.g.dart';
import 'package:mobile_yp/online_cc.dart';
import 'package:mobile_yp/public_cc.dart';
import 'package:mobile_yp/settings.dart';
import 'package:settings_ui/settings_ui.dart';

bool adminSwitch = true;

class adminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return __adminState();
  }
}

class __adminState extends State<adminPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: lightColorScheme.background,
      ),
      body:SettingsList(
       lightTheme:SettingsThemeData(
            settingsSectionBackground: lightColorScheme.background,
            settingsListBackground: lightColorScheme.background
        ) ,
        sections: [
          SettingsSection(
            title: Text("資訊股長設定",
              style: TextStyle(
                  fontSize: 50,
                  color: lightColorScheme.onBackground
              ),
            ), tiles: [],
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                title: Text('資訊股長上傳',style: SettingsTitleTextStyle,),
                description: Text('顯示上傳選項',style: SettingsSubtitleTextStyle),
                initialValue: adminSwitch,
                onToggle: (bool value) {
                  adminSwitch = value;
                  setState(() {

                  });
                },
              ),
              SettingsTile.navigation(
                title: Text('設定帳號密碼',style: SettingsTitleTextStyle,),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        toolbarHeight: 0,
                      ),
                      body: Center(
                        child: Wrap(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 20),
                              child: Text("修改帳號密碼",
                                style: TextStyle(
                                    fontSize: 50,
                                    color: lightColorScheme.onBackground
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    focusColor: lightColorScheme.primary,
                                    prefixIcon: Icon(Icons.person_outlined),
                                    labelText: "帳號",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock_outlined),
                                    suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: () {  },),
                                    labelText: "密碼",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.sensor_door_outlined),
                                    labelText: "導班",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("取消"),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStatePropertyAll(
                                        Size(
                                            MediaQuery.of(context).size.width,50
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("儲存"),
                                    style: ButtonStyle(
                                      fixedSize: MaterialStatePropertyAll(
                                        Size(
                                            MediaQuery.of(context).size.width,50
                                        )
                                      ),
                                    ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),
                    );
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