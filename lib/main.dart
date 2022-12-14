import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:mobile_yp/public_cc.dart";
import 'package:local_auth/local_auth.dart';
import "package:mobile_yp/settings.dart";
import "package:mobile_yp/online_cc.dart";
import 'package:mobile_yp/themes/blue.dart';
import 'package:mobile_yp/themes/green.dart';
import 'package:mobile_yp/themes/orange.dart';
import 'package:mobile_yp/themes/purple.dart';
import 'package:mobile_yp/themes/red.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:mobile_yp/themes/theme.dart';
import 'package:mobile_yp/view.dart';
import 'package:animations/animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Map<int, Color> color =
{
  50:Color.fromRGBO(50,107,0, .1),
  100:Color.fromRGBO(50,107,0, .2),
  200:Color.fromRGBO(50,107,0, .3),
  300:Color.fromRGBO(50,107,0, .4),
  400:Color.fromRGBO(50,107,0, .5),
  500:Color.fromRGBO(50,107,0, .6),
  600:Color.fromRGBO(50,107,0, .7),
  700:Color.fromRGBO(50,107,0, .8),
  800:Color.fromRGBO(50,107,0, .9),
  900:Color.fromRGBO(50,107,0, 1),
};

String? eventValidation = "";
String? viewstateGenerator = "";
String? viewState = "";
String? ASPCookie = "";
String? eventValidation2 = "";
String? viewstateGenerator2 = "";
String? viewState2 = "";
String? ASPCookie2 = "";
String? eventValidation3 = "";
String? viewstateGenerator3 = "";
String? viewState3 = "";



Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final Object? savedTheme = prefs.get("savedTheme");
  final Object? savedCS = prefs.get("savedCS");
  if (savedTheme != null){
    setDisplayMode = savedTheme.toString();
    if (savedTheme.toString() == "深色")
      preferredTheme = ThemeMode.dark;
    else if  (savedTheme.toString() == "淺色")
      preferredTheme = ThemeMode.light;
    else if  (savedTheme.toString() == "系統預設")
      preferredTheme = ThemeMode.system;
  }
  if (savedCS != null){
    setColourMode = savedCS.toString();
    if (savedCS.toString() == "延平綠")
      preferredCS = green;
    else if  (savedCS.toString() == "深夜藍")
      preferredCS = blue;
    else if  (savedCS.toString() == "低調紫")
      preferredCS = purple;
    else if  (savedCS.toString() == "熱血紅")
      preferredCS = red;
    else if  (savedCS.toString() == "陽光橘")
      preferredCS = orange;
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

class __MobileYPState extends State<MobileYP>{
  @override

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


class MainApp extends StatefulWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MainApp> createState() => _currentPage();

}
int currentPage = 0;
class _currentPage extends State<MainApp> {

  void initState() {
    super.initState();
    result = getCC();
    personalResult = displayChkCode();
  }

  Future<Widget> displayChkCode () async {
    var getPage = await http.get(Uri.https('lds.yphs.tp.edu.tw', 'tea/tu2.aspx'));
    viewstateGenerator2 = parse(getPage.body).getElementById("__VIEWSTATEGENERATOR")?.attributes['value'];
    eventValidation2 = parse(getPage.body).getElementById("__EVENTVALIDATION")?.attributes['value'];
    viewState2 = parse(getPage.body).getElementById("__VIEWSTATE")?.attributes['value'];
    TextEditingController chkCodeController = TextEditingController();
    Directory dir = await getTemporaryDirectory();
    var getValidate = await http.get(
        Uri.https('lds.yphs.tp.edu.tw', 'tea/validatecode.aspx'),
        headers: {
          "cookie":"ASP.NET_SessionId=f1ugporoajrevet1tlo0c4vo"
        }
    );
    File tempfile = File(dir.path + "/validate.png");
    await tempfile.writeAsBytes(getValidate.bodyBytes);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(tempfile),
        TextField(
          controller: chkCodeController,
        ),
        ElevatedButton(
            onPressed: () {
              personalResult = Future.value(CircularProgressIndicator());
              setState(() {

              });
              personalResult = personalCC(chkCodeController.text);
            },
            child: Text("登入")
        )
      ],
    );
  }

  var title = "行動延平";


  void setStateFromChild (index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(

        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (int index) {
            setState(() {
              currentPage = index;
            });
          },
          selectedIndex: currentPage,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.info),
              icon: Icon(Icons.info_outlined),
              label: '公告欄',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.campaign),
              icon: Icon(Icons.campaign_outlined),
              label: '網路聯絡簿',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.upload),
              icon: Icon(Icons.upload_outlined),
              label: '聯絡簿上傳',
            )
          ],
        ),
      ),
      body: <Widget>[
        Container(
        color: Colors.green,
        alignment: Alignment.center,
        child: publicCC(),
      ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: OnlineCC(),
        ),
        Container(
          color: Theme.of(context).colorScheme.onPrimary,
          alignment: Alignment.center,
          child: const Text('Under construction',style: TextStyle(fontSize: 40),),
        )
      ][currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          personalResult = returnCC();
          showAboutDialog(
            context: context,
            applicationName: "行動延平. Mobile YP.",
            applicationVersion: "1.0 beta",
            children: [
              // Text("Why use that crappy old website when you have an optimised version in the palm of your hands?")
              FutureBuilder<Widget>(
                future: personalResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text("");
                  }

                  // By default, show a loading spinner.
                  return Text("");
                },
              )
            ]
          );
        },
        child: Icon(
            Icons.info_outlined,
        ),
      ),
    );
  }
}


