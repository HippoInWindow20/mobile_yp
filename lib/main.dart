import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:mobile_yp/admin_list.dart';
import 'package:mobile_yp/personal.dart';
import "package:mobile_yp/public_cc.dart";
import 'package:mobile_yp/saved.dart';
import 'package:mobile_yp/schedule.dart';
import "package:mobile_yp/settings.dart";
import "package:mobile_yp/online_cc.dart";
import 'package:mobile_yp/text_size.dart';
import 'package:mobile_yp/themes/blue.dart';
import 'package:mobile_yp/themes/green.dart';
import 'package:mobile_yp/themes/orange.dart';
import 'package:mobile_yp/themes/purple.dart';
import 'package:mobile_yp/themes/red.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:mobile_yp/themes/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin.dart';
// import 'home.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(50, 107, 0, .1),
  100: Color.fromRGBO(50, 107, 0, .2),
  200: Color.fromRGBO(50, 107, 0, .3),
  300: Color.fromRGBO(50, 107, 0, .4),
  400: Color.fromRGBO(50, 107, 0, .5),
  500: Color.fromRGBO(50, 107, 0, .6),
  600: Color.fromRGBO(50, 107, 0, .7),
  700: Color.fromRGBO(50, 107, 0, .8),
  800: Color.fromRGBO(50, 107, 0, .9),
  900: Color.fromRGBO(50, 107, 0, 1),
};

String? ASPCookie = "";
String? eventValidationCal = "";
String? viewstateGeneratorCal = "";
String? viewStateCal = "";
String OnlineCCStep = "validation";
String savedContent = r'''{"items":[]}''';
List<String> savedContentManual = [];
String savedCCContent = r'''{"items":[]}''';
List<String> savedCCContentManual = [];

// class CCTemplate {
//   final String title;
//   final String agency;
//   final String date;
//   final String actualContent;
//
//   CCTemplate(this.title, this.agency, this.date, this.actualContent);
//
//   CCTemplate.fromJson(Map<String, dynamic> json, int number)
//       : title = json[number]['title'] as String,
//         agency = json[number]['agency'] as String,
//         date = json[number]['date'] as String,
//         actualContent = json['actualContent'] as String;
//
//   Map<String, dynamic> toJson() => {
//     'title': title,
//     'agency': agency,
//     'date':date,
//     'actualContent':actualContent
//   };
// }

// List<String> TitlesList = adminSwitch ? ["公告欄","收藏","網路聯絡簿","行事曆","聯絡簿上傳","設定"] : ["公告欄","收藏","網路聯絡簿","行事曆","設定"];
List<String> TitlesList =
    adminSwitch ? ["公告欄", "網路聯絡簿", "聯絡簿上傳", "設定"] : ["公告欄", "網路聯絡簿", "設定"];

Future<void> main() async {
  ASPCookie = "ASP.NET_SessionId=" + cookieGenerator(24);
  ASPCookie2 = "ASP.NET_SessionId=" + cookieGenerator(24);
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final Object? savedTheme = prefs.get("savedTheme");
  final Object? savedCS = prefs.get("savedCS");
  final Object? savedNumber = prefs.get("savedNumber");
  final Object? savedPwd = prefs.get("savedPwd");
  final Object? savedSerial = prefs.get("savedSerial");
  final Object? savedBD = prefs.get("savedBD");
  final Object? savedAccount = prefs.get("savedAccount");
  final Object? savedAdminPwd = prefs.get("savedAdminPwd");
  final Object? savedClass = prefs.get("savedClass");
  final bool? savedAdminSwitch = prefs.getBool("showAdmin");
  final int? savedGrade = prefs.getInt("savedGrade");
  final Object? prefsSavedContent = prefs.get("savedContent");
  final Object? prefsSavedCCContent = prefs.get("savedCCContent");
  final int? savedTextSize = prefs.getInt("savedTextSize");
  if (savedTheme != null) {
    setDisplayMode = savedTheme.toString();
    if (savedTheme.toString() == "深色")
      preferredTheme = ThemeMode.dark;
    else if (savedTheme.toString() == "淺色")
      preferredTheme = ThemeMode.light;
    else if (savedTheme.toString() == "系統預設") preferredTheme = ThemeMode.system;
  }
  if (savedCS != null) {
    setColourMode = savedCS.toString();
    if (savedCS.toString() == "延平綠")
      preferredCS = green;
    else if (savedCS.toString() == "深夜藍")
      preferredCS = blue;
    else if (savedCS.toString() == "低調紫")
      preferredCS = purple;
    else if (savedCS.toString() == "熱血紅")
      preferredCS = red;
    else if (savedCS.toString() == "陽光橘") preferredCS = orange;
  }
  if (savedNumber != null) {
    defaultNumber = savedNumber.toString();
  }
  if (savedPwd != null) {
    defaultPwd = savedPwd.toString();
  }
  if (savedSerial != null) {
    defaultSerial = savedSerial.toString();
  }
  if (savedBD != null) {
    defaultBD = savedBD.toString();
  }
  if (savedAdminSwitch != null) {
    adminSwitch = savedAdminSwitch;
  }
  if (savedAccount != null) {
    defaultAccount = savedAccount.toString();
  }
  if (savedAdminPwd != null) {
    defaultAdminPwd = savedAdminPwd.toString();
  }
  if (savedClass != null) {
    defaultClass = savedClass.toString();
  }
  if (savedGrade != null) {
    selectedGrade = savedGrade;
  }
  if (prefsSavedContent != null) {
    savedContent = prefsSavedContent.toString();
  }
  if (prefsSavedCCContent != null) {
    savedCCContent = prefsSavedCCContent.toString();
  }
  if (savedTextSize != null) {
    TextScaling = savedTextSize.toDouble();
  }
  runApp(MobileYP());
}

ThemeMode preferredTheme = ThemeMode.system;

class MobileYP extends StatefulWidget {
  const MobileYP({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __MobileYPState();
  }

  static __MobileYPState of(BuildContext context) =>
      context.findAncestorStateOfType<__MobileYPState>()!;
}

class __MobileYPState extends State<MobileYP> {
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      preferredTheme = themeMode;
    });
  }

  void changeColour(List<ColorScheme> colour) {
    setState(() {
      preferredCS = colour;
    });
  }

  void setStateFunc() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "行動延平. Mobile YP.",
      darkTheme: ThemeData(
        colorScheme: preferredCS[1],
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      themeMode: preferredTheme,
      theme: ThemeData(
        colorScheme: preferredCS[0],
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: MainApp(),
    );
  }
}

Future<File> beforeChk() async {
  var getPage = await http.get(Uri.https('lds.yphs.tp.edu.tw', 'tea/tu2.aspx'));
  viewstateGenerator2 = parse(getPage.body)
      .getElementById("__VIEWSTATEGENERATOR")
      ?.attributes['value'];
  eventValidation2 = parse(getPage.body)
      .getElementById("__EVENTVALIDATION")
      ?.attributes['value'];
  viewState2 =
      parse(getPage.body).getElementById("__VIEWSTATE")?.attributes['value'];
  Directory dir = await getTemporaryDirectory();
  var getValidate = await http.get(
      Uri.https('lds.yphs.tp.edu.tw', 'tea/validatecode.aspx'),
      headers: {"cookie": ASPCookie2!});
  var randomNumber = cookieGenerator(8);
  File tempfile = File(dir.path + "/${randomNumber}.png");
  await tempfile.writeAsBytes(getValidate.bodyBytes);
  return tempfile;
}

class MainApp extends StatefulWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MainApp> createState() => _currentPage();
}

int currentPage = 0;

class _currentPage extends State<MainApp> {
  void setStateFunc() {
    setState(() {});
  }

  void initState() {
    super.initState();
    result = getCC();
    personalResult = displayChkCode();
    uploadResult = retrieveAdminList(setStateFunc, context);
    calResult = getCal();
  }

  Future<Widget> displayChkCode() async {
    var tempfile = await beforeChk();
    TextEditingController chkCodeController = TextEditingController();
    return Center(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  tempfile,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: TextFormField(
              controller: chkCodeController,
              decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  labelText: '驗證碼',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onBackground))),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 50, right: 50),
            child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 30)),
                  fixedSize: MaterialStatePropertyAll(
                    Size((MediaQuery.of(context).size.width - 32), 100),
                  ),
                ),
                onPressed: () {
                  personalResult =
                      Future.value(CircularProgressIndicator(year2023: false));
                  setState(() {});
                  personalResult = personalCC(chkCodeController.text, context,
                      displayChkCode, setStateFromMain);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Text("登入"),
                )),
          )
        ],
      ),
    );
  }

  void setStateFromChild(index) {
    setState(() {
      currentPage = index;
    });
  }

  void setStateFromMain() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TitlesList[currentPage]),
      ),
      drawer: NavigationDrawer(
        selectedIndex: currentPage,
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
          Navigator.of(context).pop();
        },
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "測試用戶",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            accountEmail: Text(
              "testaccount@yphs.tp.edu.tw",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          NavigationDrawerDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outlined),
            label: Text('公告欄'),
          ),
          // NavigationDrawerDestination(
          //   selectedIcon: Icon(Icons.star),
          //   icon: Icon(Icons.star_border_outlined),
          //   label: Text('收藏'),
          // ),
          NavigationDrawerDestination(
            selectedIcon: Icon(Icons.announcement),
            icon: Icon(Icons.announcement_outlined),
            label: Text('網路聯絡簿'),
          ),
          // NavigationDrawerDestination(
          //   selectedIcon: Icon(Icons.calendar_month),
          //   icon: Icon(Icons.calendar_month_outlined),
          //   label: Text('行事曆'),
          // ),
          if (adminSwitch == true)
            NavigationDrawerDestination(
              selectedIcon: Icon(Icons.upload),
              icon: Icon(Icons.upload_outlined),
              label: Text('聯絡簿上傳'),
            ),
          NavigationDrawerDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: Text('設定'),
          ),
        ],
      ),
      body: <Widget>[
        // Container(
        //   color: Theme.of(context).colorScheme.onPrimary,
        //   alignment: Alignment.center,
        //   child: Homepage(setStateCallBack: setStateFromMain),
        // ),
        Container(
          color: Theme.of(context).colorScheme.onPrimary,
          alignment: Alignment.center,
          child: publicCC(
            setStateCallBack: setStateFromMain,
          ),
        ),
        // Container(
        //   color: Theme.of(context).colorScheme.onPrimary,
        //   alignment: Alignment.center,
        //   child: savedCC(setStateCallBack: setStateFromMain,),
        // ),
        Container(
          color: Theme.of(context).colorScheme.onPrimary,
          alignment: Alignment.center,
          child: OnlineCC(
            setStateCallBack: setStateFromMain,
            displayChkCode: displayChkCode,
          ),
        ),
        // Container(
        //   color: Theme.of(context).colorScheme.onPrimary,
        //   alignment: Alignment.center,
        //   child: Schedule(setStateCallBack: setStateFromMain,),
        // ),
        if (adminSwitch == true)
          Container(
            color: Theme.of(context).colorScheme.onPrimary,
            alignment: Alignment.center,
            child: UploadCC(
              setStateCallBack: setStateFromMain,
            ),
          ),
        Container(
          color: Theme.of(context).colorScheme.onPrimary,
          alignment: Alignment.center,
          child: Settings(
            setStateCallBack: setStateFromMain,
          ),
        ),
      ][currentPage],
    );
  }
}
