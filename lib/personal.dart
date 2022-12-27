
import 'package:flutter/material.dart';
import 'package:mobile_yp/color_schemes.g.dart';
import 'package:mobile_yp/online_cc.dart';
import 'package:mobile_yp/public_cc.dart';
import 'package:mobile_yp/settings.dart';
import 'package:settings_ui/settings_ui.dart';

bool adminSwitch = true;

class personal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return __personal();
  }
}

class __personal extends State<personal>{
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
    return editPersonal();
  }

}

class editPersonal extends StatelessWidget {
  const editPersonal({
    Key? key,
  }) : super(key: key);

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
              child: Text("修改個人資訊",
                style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.onBackground
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("所有資訊將安全的儲存在您的裝置。",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onBackground
                ),
              ),
            ),
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outlined),
                    hintText: "延平學號",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                   ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                    focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                    labelText: '學號',
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
                  obscureText: true,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        color: Theme.of(context).colorScheme.onBackground,
                        onPressed: () {  },),
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
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key_outlined),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                      labelText: '身分證字號',
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
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground
                      ),
                      focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                      labelText: '生日',
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
                  child: Text("取消",style: TextStyle(fontSize: 20),),
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
            SizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
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