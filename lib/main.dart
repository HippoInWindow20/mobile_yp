import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:mobile_yp/public_cc.dart";
import 'package:local_auth/local_auth.dart';
import "package:mobile_yp/settings.dart";
import "package:mobile_yp/online_cc.dart";
import "package:mobile_yp/color_schemes.g.dart";
import "package:mobile_yp/custom_color.g.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:mobile_yp/view.dart';
import 'package:animations/animations.dart';
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


Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final Object? savedTheme = prefs.get("savedTheme");
  if (savedTheme != null){
    setDisplayMode = savedTheme.toString();
    if (savedTheme.toString() == "深色")
      preferredTheme = ThemeMode.dark;
    else if  (savedTheme.toString() == "淺色")
      preferredTheme = ThemeMode.light;
    else if  (savedTheme.toString() == "系統預設")
      preferredTheme = ThemeMode.system;
  }
  runApp(MobileYP());

}

ThemeMode preferredTheme = ThemeMode.system;

class MobileYP extends StatefulWidget {
  const MobileYP({Key? key}) : super(key: key);

  @override


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

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "行動延平. Mobile YP.",
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      themeMode: preferredTheme,
      theme: ThemeData(
        colorScheme: lightColorScheme,
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
          backgroundColor: Theme.of(context).colorScheme.background,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          iconTheme: MaterialStatePropertyAll(
            IconThemeData(
              color: Theme.of(context).colorScheme.onBackground
            )
          ),
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(
              color: Theme.of(context).colorScheme.onBackground
            )
          )
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
          child: const Text('Page 3'),
        )
      ][currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {


          showAboutDialog(
            context: context,
            applicationName: "行動延平. Mobile YP.",
            applicationVersion: "1.0 beta",
            children: [
              Text("Why use that crappy old website when you have an optimised version in the palm of your hands?")
            ]
          );
        },
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: Icon(
            Icons.info_outlined,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}


