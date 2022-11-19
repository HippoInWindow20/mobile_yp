import "package:flutter/material.dart";
import "package:mobile_yp/public_cc.dart";
import 'package:local_auth/local_auth.dart';
import "package:mobile_yp/settings.dart";
import "package:mobile_yp/online_cc.dart";


void main() => runApp(MobileYP());

class MobileYP extends StatelessWidget {
  const MobileYP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mobile YP.",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobile YP."),
      ),
      body: publicCC(),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('許晉誠',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              accountEmail: Text('學號：11031123'),
              currentAccountPicture: Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 60.0,
                semanticLabel: '設定',
              ),
              decoration: BoxDecoration(color: Colors.green),
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_info_outlined,
                color: Colors.black,
                size: 30,
                semanticLabel: '網路聯絡簿',
              ),
              title: const Text('網路聯絡簿',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.newspaper_outlined,
                color: Colors.black,
                size: 30,
                semanticLabel: '網路聯絡簿',
              ),
              title: const Text('公告欄',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                color: Colors.black,
                size: 30,
                semanticLabel: '設定',
              ),
              title: const Text('設定',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}