
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool adminSwitch = false;
String defaultAccount = "";
String defaultAdminPwd = "";
String defaultClass = "";
bool obscureAdmin = true;
IconData eye2 = Icons.visibility_outlined;

class adminPage extends StatefulWidget {
  @override
  adminPage({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  State<StatefulWidget> createState() {
    return __adminState(setStateCallBack: setStateCallBack);
  }
}

class __adminState extends State<adminPage>{
  @override
  __adminState({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
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
            title: Text("資訊股長設定",
              style: TextStyle(
                  fontSize: 50,
                  color: Theme.of(context).colorScheme.onBackground
              ),
            ), tiles: [],
          ),
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                title: Text('資訊股長上傳',style: SettingsTitleTextStyle,),
                description: Text('顯示上傳選項',style: SettingsSubtitleTextStyle),
                initialValue: adminSwitch,
                onToggle: (bool value) async {
                  adminSwitch = value;
                  setState(() {

                  });
                  setStateCallBack();
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.setBool("showAdmin", adminSwitch);
                },
              ),
              if (adminSwitch == true)
                SettingsTile.navigation(
                  title: Text('設定帳號密碼',style: SettingsTitleTextStyle,),
                  onPressed: (context) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return editAdmin();
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

class editAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return editAdminState();
  }
}

class editAdminState extends State<editAdmin> {

  final AccountController = TextEditingController(text: defaultAccount);
  final AdminPwdController = TextEditingController(text: defaultAdminPwd);
  final ClassController = TextEditingController(text: defaultClass);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(
        child: Wrap(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 20),
              child: Text("修改帳號密碼",
                style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.onBackground
                ),
              ),
            ),
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: TextFormField(
                  controller: AccountController,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outlined),
                    hintText: "上傳帳號",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                   ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                    focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                    labelText: '帳號',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground
                        )
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground
                        )
                    )
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: TextFormField(
                  controller: AdminPwdController,
                  obscureText: obscureAdmin,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(eye2),
                        color: Theme.of(context).colorScheme.onBackground,
                        onPressed: () {
                          setState(() {
                            if (obscureAdmin == true) {
                              obscureAdmin = false;
                              eye2 = Icons.visibility_off_outlined;
                            }else {
                              obscureAdmin = true;
                              eye2 = Icons.visibility_outlined;
                            }
                          });
                        },),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                      labelText: '密碼',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground
                          )
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground
                          )
                      )
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ClassController,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.sensor_door_outlined),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                      labelText: '導班',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground
                          )
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground
                          )
                      )
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },

                  style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(
                        Size(
                            (MediaQuery.of(context).size.width / 2 - 32),50
                        ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                    elevation: MaterialStatePropertyAll(0),

                  ),
                  child: Text("取消",style: TextStyle(fontSize: 20),),
                ),
              ),
            ),
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    defaultAccount = AccountController.text;
                    defaultAdminPwd = AdminPwdController.text;
                    defaultClass = ClassController.text;
                    var prefs = await SharedPreferences.getInstance();
                    await prefs.setString("savedAccount", AccountController.text);
                    await prefs.setString("savedAdminPwd", AdminPwdController.text);
                    await prefs.setString("savedClass", ClassController.text);
                    Navigator.of(context).pop();
                  },
                  child: Text("儲存",style: TextStyle(fontSize: 20),),
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                        Size(
                            (MediaQuery.of(context).size.width / 2 - 32),50
                        ),
                      ),
                      backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                      elevation: MaterialStatePropertyAll(0)
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}