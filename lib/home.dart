import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'admin_list.dart';


class Homepage extends StatefulWidget {
  final Function setStateCallBack;

  Homepage({
    required this.setStateCallBack,
  });
  @override
  State<StatefulWidget> createState() {
    return HomepageState(setStateCallBack: setStateCallBack);
  }
}



class HomepageState extends State {
  final Function setStateCallBack;

  HomepageState({
    required this.setStateCallBack,
  });
  @override
  Widget build(BuildContext context) {
    ButtonStyle menuTileStyle = ButtonStyle(
        fixedSize: MaterialStatePropertyAll(
            Size(
                (MediaQuery.of(context).size.width/3.5),(MediaQuery.of(context).size.width/3.5)
            )
        )
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 130,
        backgroundColor: Color(0xFF135400),
        title: Text("Mobile YP.",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFffac32),
            fontSize: 40,
            letterSpacing: 2
          ),
        ),
      ),
      body: Center(
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.info_outlined,
                      title: "公告欄",
                      function: () {
                        currentPage = 1;
                      },
                      setState: setStateCallBack,
                    ),
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.announcement_outlined,
                      title: "網路聯絡簿",
                      function: () {
                        currentPage = 2;
                      },
                      setState: setStateCallBack,
                    ),
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.announcement_outlined,
                      title: "lol",
                      function: () {
                      },
                      setState: setStateCallBack,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.info_outlined,
                      title: "公告欄",
                      function: () {
                        currentPage = 1;
                      },
                      setState: setStateCallBack,
                    ),
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.announcement_outlined,
                      title: "網路聯絡簿",
                      function: () {
                        currentPage = 2;
                      },
                      setState: setStateCallBack,
                    ),
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.announcement_outlined,
                      title: "lol",
                      function: () {
                      },
                      setState: setStateCallBack,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.info_outlined,
                      title: "公告欄",
                      function: () {
                        currentPage = 1;
                      },
                      setState: setStateCallBack,
                    ),
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.announcement_outlined,
                      title: "網路聯絡簿",
                      function: () {
                        currentPage = 2;
                      },
                      setState: setStateCallBack,
                    ),
                    MenuTile(
                      menuTileStyle: menuTileStyle,
                      icon: Icons.announcement_outlined,
                      title: "lol",
                      function: () {
                      },
                      setState: setStateCallBack,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.menuTileStyle,
    required this.icon,
    required this.title,
    required this.function,
    required this.setState
  });

  final ButtonStyle menuTileStyle;
  final IconData icon;
  final String title;
  final Function function;
  final Function setState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: menuTileStyle,
        onPressed: () {
        function();
        setState();
        },
        child: Center(
          child: Wrap(
            children: [
              Column(
                children: [
                  Icon(icon),
                  Text(title)
                ],
              )
            ],
          ),
        )
    );
  }
}