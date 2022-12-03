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

Future<void> main() async {
  runApp(MobileYP());
}

class MobileYP extends StatelessWidget {
  const MobileYP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mobile YP.",
      theme: ThemeData(
        primarySwatch: MaterialColor(lightColorScheme.primary.value,color),
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

class _currentPage extends State<MainApp> {
  dynamic currentPage = 0;
  dynamic publiccc  = Colors.green;
  dynamic onlinecc = Colors.black;
  dynamic settings = Colors.black;
  var title = "行動延平";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.campaign),
            icon: Icon(Icons.campaign_outlined),
            label: '網路聯絡簿',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outlined),
            label: '公告欄',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.upload),
            icon: Icon(Icons.upload_outlined),
            label: '聯絡簿上傳',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: '設定',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: OnlineCC(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: publicCC(),
        ),
        Container(
          color: lightColorScheme.onPrimary,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: Settings(),
        ),
      ][currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/bu2.aspx');
          var response = await http.get(url);
          var document = parse(response.body);
          var grid = document.getElementById("GridView1")?.innerHtml;
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Hello!'),
              content: SingleChildScrollView(
                child: Text(grid!),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        backgroundColor: lightColorScheme.secondaryContainer,
        child: Icon(
            Icons.info_outlined,
          color: lightColorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}


