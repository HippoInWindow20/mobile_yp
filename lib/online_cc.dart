
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_yp/main.dart';
import 'package:mobile_yp/settings.dart';
import 'package:mobile_yp/view.dart';
import 'package:mobile_yp/public_cc.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:animations/animations.dart';
import 'package:mobile_yp/view_private.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';



Future<Widget> personalResult = Future.value(Text(""));


Future<Widget> personalCC (String chkCode) async {

  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tu2.aspx');
  var response = await http.post(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":"ASP.NET_SessionId=f1ugporoajrevet1tlo0c4vo"
      },
      body: {
        "__VIEWSTATE": viewState2,
        "__VIEWSTATEGENERATOR": viewstateGenerator2,
        "__EVENTVALIDATION":eventValidation2,
        "chk_id":"學生",
        "tbx_sno": "11031123",
        "tbx_pwd": "shippo123456",
        "txtChkCode": chkCode,
        "but_login_stud":"登入"
      }
  );
  if (response.body.contains("Object moved")) {
    return returnCC();
  }else {
    return Text(response.body);
  }
}

Future<Widget> returnCC () async {

  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tu2-1.aspx');
  var response = await http.get(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":"ASP.NET_SessionId=f1ugporoajrevet1tlo0c4vo"
      },
  );

  var document = parse(response.body);


  viewstateGenerator3 = document.getElementById("__VIEWSTATEGENERATOR")?.attributes['value'];
  eventValidation3 = document.getElementById("__EVENTVALIDATION")?.attributes['value'];
  viewState3 = document.getElementById("__VIEWSTATE")?.attributes['value'];

  List titles = [];
  List agencies = [];
  List dates = [];
  var TDs = document.getElementsByTagName("td");
  for (var i in TDs) {
    if (i.outerHtml.toString().contains('width="70"')){
      var tmp = i.innerHtml;
      var str = tmp.substring(22,(tmp.length - 7));
      agencies.add(str);
    }
  }

  for (var j in TDs) {
    if (j.outerHtml.toString().contains('width="400"')){
      var tmp = j.innerHtml;
      var str = tmp.substring(22,(tmp.length - 7));
      titles.add(str);
    }
  }

  for (var k in TDs) {
    if (k.outerHtml.toString().contains('width="180"')){
      var tmp = k.innerHtml;
      var str = tmp.substring(22,(tmp.length - 7));
      dates.add(str);
    }
  }

  var result = [];

  for (var m = 0;m < dates.length;m++){
    result.add([titles[m],agencies[m],dates[m],m]);
  }


  return Column(
    children: List.generate(
        result.length, (index) =>
        ListCardPrivate(
            title: result[index][0],
            agency: result[index][1],
            date: result[index][2],
            count: result[index][3])
    ),
  );
}




class OnlineCC extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _OnlineCCState();
  }

}


class _OnlineCCState extends State<OnlineCC> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            toolbarHeight: 100,
            title: Text(
              "網路聯絡簿",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 40
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              AppPopupMenu<int>(
                padding: EdgeInsets.all(20),
                menuItems:  [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      '重新整理',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 20
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                        '設定',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 20
                        )
                    ),
                  ),
                ],
                onSelected: (int value) {
                  switch (value){
                    case 1:
                      personalResult = Future.value(Text(""));
                      setState(() {

                      });
                      personalResult = returnCC();
                      break;
                    case 2:
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return gotoSettings(
                                    Settings()
                                );
                              }
                          )
                      );
                      break;
                  }
                },
                onCanceled: () {
                },
                tooltip: "更多選項",
                elevation: 30,
                icon: Icon(Icons.more_vert,size: 30,color: Theme.of(context).colorScheme.onBackground,),
                offset: const Offset(0, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant,
              )
            ],
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<Widget>(
              future: personalResult,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  return ErrorCard(errorCode: snapshot.error.toString());
                }

                return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: CircularProgressIndicator(),
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

class ListCardPrivate extends StatelessWidget {
  const ListCardPrivate({
    Key? key, required this.title, required this.agency, required this.date, required this.count,
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  final int count;

  @override
  Widget build(BuildContext context) {
    return
      Hero(
        tag: "main" + count.toString(),
        child: Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: InkWell(
              onTap: () {
                contentPrivate = getContentOfOnlineCC(count);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return ViewPrivate(title: title,agency: agency,date: date,count: count,);}));

              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20,bottom: 20,right: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20,bottom: 20,right: 5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child:Icon(Icons.apartment_outlined,color: Theme.of(context).colorScheme.onSecondaryContainer,size: 20,),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20,right: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(agency,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20,bottom: 20,right: 5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child:Icon(Icons.calendar_month_outlined,color: Theme.of(context).colorScheme.onSecondaryContainer,size: 20,),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(date,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            )
        ),

      );
  }
}

