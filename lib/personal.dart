
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String defaultNumber = "";
String defaultPwd = "";
String defaultSerial = "";
String defaultBD = "";
bool obscureText = true;
IconData eye = Icons.visibility_outlined;

class personal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return __personal();
  }
}

class __personal extends State<personal>{
  @override
  Widget build(BuildContext context) {

    return editPersonal();
  }

}

class editPersonal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return editPersonalState();
  }

}

class editPersonalState extends State<editPersonal> {

  final NumberController = TextEditingController(text: defaultNumber);
  final PwdController = TextEditingController(text: defaultPwd);
  final SerialController = TextEditingController(text: defaultSerial);
  final BDController = TextEditingController(text: defaultBD);

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
                  keyboardType: TextInputType.number,
                  controller: NumberController,
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
                  controller: PwdController,
                  obscureText: obscureText,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(eye),
                        color: Theme.of(context).colorScheme.onBackground,
                        onPressed: () {
                          setState(() {
                            if (obscureText == true) {
                              obscureText = false;
                              eye = Icons.visibility_off_outlined;
                            }else {
                              obscureText = true;
                              eye = Icons.visibility_outlined;
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
            // SizedBox(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
            //     child: TextFormField(
            //       controller: SerialController,
            //       style: TextStyle(
            //           color: Theme.of(context).colorScheme.onBackground
            //       ),
            //       decoration: InputDecoration(
            //           prefixIcon: Icon(Icons.key_outlined),
            //           hintStyle: TextStyle(
            //               color: Theme.of(context).colorScheme.onBackground
            //           ),
            //           labelStyle: TextStyle(
            //               color: Theme.of(context).colorScheme.onBackground
            //           ),
            //           focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
            //           labelText: '身分證字號',
            //           enabledBorder: OutlineInputBorder(
            //               borderSide: BorderSide(
            //                   color: Theme.of(context).colorScheme.onBackground
            //               )
            //           ),
            //           border: OutlineInputBorder(
            //               borderSide: BorderSide(
            //                   color: Theme.of(context).colorScheme.onBackground
            //               )
            //           )
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
            //     child: TextFormField(
            //       keyboardType: TextInputType.number,
            //       controller: BDController,
            //       style: TextStyle(
            //           color: Theme.of(context).colorScheme.onBackground
            //       ),
            //       decoration: InputDecoration(
            //           prefixIcon: Icon(Icons.calendar_month_outlined),
            //           hintStyle: TextStyle(
            //               color: Theme.of(context).colorScheme.onBackground
            //           ),
            //           labelStyle: TextStyle(
            //               color: Theme.of(context).colorScheme.onBackground
            //           ),
            //           focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
            //           labelText: '生日',
            //           hintText: "範例：20060101",
            //           enabledBorder: OutlineInputBorder(
            //               borderSide: BorderSide(
            //                   color: Theme.of(context).colorScheme.onBackground
            //               )
            //           ),
            //           border: OutlineInputBorder(
            //               borderSide: BorderSide(
            //                   color: Theme.of(context).colorScheme.onBackground
            //               )
            //           )
            //       ),
            //     ),
            //   ),
            // ),
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
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    defaultNumber = NumberController.text;
                    await prefs.setString("savedNumber", NumberController.text);
                    defaultPwd = PwdController.text;
                    await prefs.setString("savedPwd", PwdController.text);
                    defaultSerial = SerialController.text;
                    await prefs.setString("savedSerial", SerialController.text);
                    defaultBD = BDController.text;
                    await prefs.setString("savedBD", BDController.text);

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