import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:mobile_yp/public_cc.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mobile_yp/saved.dart';
import 'package:mobile_yp/text_size.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'online_cc.dart';

String? eventValidation3 = "";
String? viewstateGenerator3 = "";
String? viewState3 = "";
Future<List> contentPrivate = Future.value([]);

int isInSavedCC(String title) {
  var isSaved = false;
  int i = 0;
  int result = -1;
  while (isSaved == false && i < savedCCContentManual.length) {
    if (savedCCContentManual[i].toString().contains(title)) {
      isSaved = true;
    }
    i++;
  }
  return isSaved == true ? i - 1 : result;
}

Future<List> getContentOfOnlineCC(count) async {
  count = (count + 2).toString();
  if (count.length < 2) {
    count = "0" + count;
  }
  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tu2-1.aspx');
  var response = await http.post(
    url,
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "cookie": ASPCookie2!
    },
    body: {
      "__EVENTTARGET": "",
      "__EVENTARGUMENT": "",
      "__VIEWSTATE": viewState3,
      "__VIEWSTATEGENERATOR": viewstateGenerator3,
      "__EVENTVALIDATION": eventValidation3,
      "GridViewS\$ctl" + count + "\$but_vf1": "詳細內容"
    },
  );
  var document = parse(response.body);
  var innerContent = document.getElementById("Lab_content")?.innerHtml;
  var LinkCollection = document.getElementsByTagName("a");
  String? link = "";
  if (LinkCollection.length == 1) {
    link = LinkCollection[0].attributes['href'];
  }
  return [innerContent, link];
}

class ViewPrivate extends StatefulWidget {
  @override
  ViewPrivate({
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
  });
  final String title;
  final String agency;
  final String date;
  final int count;
  State<StatefulWidget> createState() {
    return stateViewPrivate(
        title: title, agency: agency, date: date, count: count);
  }
}

class stateViewPrivate extends State {
  stateViewPrivate({
    Key? key,
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
  });
  final String title;
  final String agency;
  final String date;
  final int count;

  var actualContent = "null";
  var link = "null";

  void _launchURL(BuildContext context, link) async {
    try {
      await launchUrl(
        link,
        customTabsOptions: CustomTabsOptions(
          colorSchemes:
              CustomTabsColorSchemes(colorScheme: CustomTabsColorScheme.system),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          animations: CustomTabsAnimations(
            startEnter: 'slide_in_right',
            startExit: 'slide_out_left',
            endEnter: 'slide_in_left',
            endExit: 'slide_out_right',
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actionsIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimaryContainer),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       var query = isInSavedCC(title);
          //       if (query == -1){
          //         // savedCCContent.add([title,agency,date,actualContent,link]);
          //         var awaitSavedJSON = r'''{"title":"'''+title+'''","agency":"'''+agency+'''","date":"'''+date+'''","actualContent":"'''+actualContent+'''","link":"'''+link+'''"}''';
          //         savedCCContentManual.add(awaitSavedJSON);
          //         ScaffoldMessenger.of(context).removeCurrentSnackBar();
          //         ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //                 content: Text("已新增至收藏")
          //             )
          //         );
          //       }else{
          //         savedCCContentManual.removeAt(query);
          //         ScaffoldMessenger.of(context).removeCurrentSnackBar();
          //         ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //                 content: Text("已從收藏移除")
          //             )
          //         );
          //       }
          //       savedCCContent = r"""{"items":"""+savedCCContentManual.toString()+"""}""";
          //       var prefs = await SharedPreferences.getInstance();
          //       await prefs.setString("savedCCContent", savedCCContent);
          //       savedResult = formatSaved();
          //       setState(() {
          //
          //       });
          //     },
          //     icon: isInSavedCC(title) != -1 ? Icon(Icons.star) : Icon(Icons.star_border)
          // ),
          IconButton(
              onPressed: () {
                contentPrivate = getContentOfOnlineCC(count);
                setState(() {});
              },
              icon: Icon(Icons.refresh_outlined)),
          IconButton(
              onPressed: () {
                if (actualContent != "null" && link != "null") {
                  var newContent = "主旨：" +
                      title +
                      "\n\n" +
                      actualContent +
                      "\n\n連結： " +
                      link;
                  Share.share(newContent, subject: title);
                } else if (actualContent != "null" && link == "null") {
                  var newContent = "主旨：" + title + "\n\n" + actualContent;
                  Share.share(newContent, subject: title);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ErrorDesc(errordesc: "沒有可分享的內容");
                      });
                }
              },
              icon: Icon(Icons.share_outlined)),
        ],
      ),
      body: Hero(
        tag: "main" + count.toString(),
        child: Material(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.apartment,
                                  size: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  agency,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.calendar_month_outlined,
                                  size: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 15, right: 10),
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: FutureBuilder<List>(
                          future: contentPrivate,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              actualContent = snapshot.data![0];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    snapshot.data![0],
                                    style: TextStyle(
                                        fontSize: TextScaling,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        letterSpacing: 2,
                                        height: 1.7),
                                  )
                                ],
                              );
                            } else if (snapshot.hasError) {
                              actualContent = "null";
                              link = "null";
                              return ErrorCard(
                                  errorCode: snapshot.error.toString());
                            }

                            // By default, show a loading spinner.
                            return Center(
                                child:
                                    CircularProgressIndicator(year2023: false));
                          },
                        ))),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FutureBuilder<List>(
        future: contentPrivate,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data![1].length > 1) {
              link = snapshot.data![1];
              return BottomAppBar(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: TextButton(
                          onPressed: () {
                            _launchURL(context, snapshot.data![1]);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.open_in_new_outlined),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "開啟連結",
                                  style: TextStyle(fontSize: 22),
                                ),
                              )
                            ],
                          )),
                    ),
                    TextButton(
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: snapshot.data![1]));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("已複製連結至剪貼簿")));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.copy_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "複製連結",
                                style: TextStyle(fontSize: 22),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              );
            } else {
              return Padding(padding: EdgeInsets.only());
            }
          } else if (snapshot.hasError) {
            return Text("");
          }
          // By default, show a loading spinner.
          return Text("");
        },
      ),
    );
  }
}

class ErrorDesc extends StatelessWidget {
  const ErrorDesc({
    super.key,
    required this.errordesc,
  });
  final String errordesc;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Wrap(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        size: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "錯誤",
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          errordesc,
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "確定",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer),
                            )),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
