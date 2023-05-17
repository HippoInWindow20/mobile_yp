
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_yp/themes/green.dart';
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share_plus/share_plus.dart';

Future<List> contentPrivate = Future.value([]);

Future<List> getContentOfOnlineCC (count) async {
  count = (count + 2).toString();
  if (count.length < 2){
    count = "0" + count;
  }
  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tu2-1.aspx');
  var response = await http.post(
    url,
    headers: {
      "Content-Type":"application/x-www-form-urlencoded",
      "cookie":ASPCookie2!
    },
    body: {
      "__EVENTTARGET": "",
      "__EVENTARGUMENT":"",
      "__VIEWSTATE":viewState3,
      "__VIEWSTATEGENERATOR":viewstateGenerator3,
      "__EVENTVALIDATION":eventValidation3,
      "GridViewS\$ctl"+count+"\$but_vf1":"詳細內容"
    },
  );
  var document = parse(response.body);
  var innerContent = document.getElementById("Lab_content")?.innerHtml;
  var LinkCollection = document.getElementsByTagName("a");
  String? link = "";
  if (LinkCollection.length == 1){
    link = LinkCollection[0].attributes['href'];
  }
  return [innerContent,link];
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
    return stateViewPrivate(title: title, agency: agency, date: date, count: count);
  }
}

class stateViewPrivate extends State {
  stateViewPrivate({
    Key? key, required this.title,required this.agency,required this.date, required this.count,
  });
  final String title;
  final String agency;
  final String date;
  final int count;

  var actualContent = "null";
  var link = "null";

  void _launchURL(BuildContext context,link) async {
    try {
      await launch(
        link,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
        ),
        safariVCOption: SafariViewControllerOption(
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
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimaryContainer
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
              onPressed: (){
                contentPrivate = getContentOfOnlineCC(count);
                setState(() {

                });
              },
              icon: Icon(Icons.refresh_outlined)
          ),
          IconButton(
              onPressed: (){
                if (actualContent != "null" && link != "null"){
                  var newContent = "主旨：" + title + "\n\n"+actualContent + "\n\n連結： " + link;
                  Share.share(newContent,subject: title);
                }else if (actualContent != "null" && link == "null"){
                  var newContent = "主旨：" + title + "\n\n"+actualContent;
                  Share.share(newContent,subject: title);
                }else {
                  showDialog(context: context, builder: (context){
                    return ErrorDesc(errordesc: "沒有可分享的內容");
                  }
                  );
                }
              },
              icon: Icon(Icons.share_outlined)
          ),
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
                        child: Text(title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).colorScheme.onPrimaryContainer
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left:20,bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.apartment,size: 30,color: Theme.of(context).colorScheme.onPrimaryContainer),
                              Padding(padding: EdgeInsets.only(left: 15),
                                child: Text(agency,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(left:20,bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.calendar_month_outlined,size: 30,color: Theme.of(context).colorScheme.onPrimaryContainer),
                              Padding(padding: EdgeInsets.only(left: 15),
                                child: Text(date,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(left:10,bottom: 15,right: 10),
                    child: Padding(padding: EdgeInsets.only(top: 15,left:10,right: 10),
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
                                        fontSize: 22,
                                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                                        letterSpacing: 2,
                                        height: 1.7
                                    ),
                                  )
                                ],
                              );
                            } else if (snapshot.hasError) {
                              actualContent = "null";
                              link = "null";
                              return ErrorCard(errorCode: snapshot.error.toString());
                            }

                            // By default, show a loading spinner.
                            return Center(
                                child: CircularProgressIndicator()
                            );
                          },
                        )
                    )
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),


                FutureBuilder<List>(
                  future: contentPrivate,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data![1].length > 1){
                        link = snapshot.data![1];
                        return Padding(
                            padding: EdgeInsets.only(left:20,bottom: 15,right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("連結",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 15),
                                  child: Tooltip(
                                    message: snapshot.data![1],
                                    child: ElevatedButton(
                                        clipBehavior: Clip.hardEdge,
                                        onPressed: () {
                                          _launchURL(context, snapshot.data![1]);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            children: [
                                              Padding(padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Icon(Icons.language_outlined,size: 30),
                                              ),
                                              Padding(padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                                                  child: Text("訪問連結",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight: FontWeight.normal,
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                )
                              ],
                            )
                        );
                      }else{
                        return Padding(padding: EdgeInsets.only());
                      }
                    } else if (snapshot.hasError) {
                      return Text("");
                    }
                    // By default, show a loading spinner.
                    return Text("");
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 50)),
              ],
            ),
          ),
        ),

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
                      Icon(Icons.error_outline_outlined,size: 40,),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "錯誤",
                          style: TextStyle(
                              fontSize: 30
                          ),
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
                          style: TextStyle(
                              fontSize: 20
                          ),
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
                                  color: Theme.of(context).colorScheme.onErrorContainer
                              ),
                            )
                        ),
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