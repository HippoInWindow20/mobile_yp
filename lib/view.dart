
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:mobile_yp/color_schemes.g.dart";
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import "package:mobile_yp/custom_color.g.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future<List> content = Future.value([]);

Future<List> getContentOfCC (count) async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/bu2.aspx');
  var response = await http.post(
    url,
    headers: {
    "Content-Type":"application/x-www-form-urlencoded",
    "cookie":ASPCookie!
  },
      body: {
        "__EVENTTARGET": "GridView1",
        "__EVENTARGUMENT":"count\$" + count.toString(),
        "__LASTFOCUS":"",
        "__VIEWSTATE":viewState,
        "__VIEWSTATEGENERATOR":viewstateGenerator,
        "__EVENTVALIDATION":eventValidation,
        "DL1":"不分",
        "DL2":"不分",
        "DL3":"全部",
      },
  );
  var document = parse(response.body);
  var person = document.getElementById("Label14")?.innerHtml;
  person = person?.substring(44,person.length - 7);
  var innerContent = document.getElementById("Label16")?.innerHtml.split("<br>");
  innerContent![0] = innerContent[0].substring(44,innerContent[0].length);
  innerContent[innerContent.length - 1] = innerContent[innerContent.length - 1].substring(0,innerContent[innerContent.length - 1].length - 7);
  var link = document.getElementsByTagName("a")[0].innerHtml;
  return [person,innerContent,link];
}

class View extends StatelessWidget {
  const View({
    Key? key, required this.title,required this.agency,required this.date, required this.count,
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  final int count;
  @override

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
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        backgroundColor: lightColorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: lightColorScheme.secondaryContainer,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 30,
                          color: lightColorScheme.onSecondaryContainer
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left:20,bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.apartment,size: 30,color: lightColorScheme.onSecondaryContainer),
                          Padding(padding: EdgeInsets.only(left: 15),
                            child: Text(agency,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: lightColorScheme.onSecondaryContainer
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
                          Icon(Icons.calendar_month_outlined,size: 30),
                          Padding(padding: EdgeInsets.only(left: 15),
                            child: Text(date,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: lightColorScheme.onSecondaryContainer
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
                          Icon(Icons.person_outlined,size: 30),
                          Padding(padding: EdgeInsets.only(left: 15),
                            child: FutureBuilder<List>(
                              future: content,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data![0],
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: lightColorScheme.onSecondaryContainer,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return ErrorCard(errorCode: snapshot.error.toString());
                                }

                                // By default, show a loading spinner.
                                return Center(
                                    child: CircularProgressIndicator()
                                );
                              },
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
                    future: content,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(snapshot.data![1].length, (index) =>
                              Text(snapshot.data![1][index].trim(),
                                style: TextStyle(
                                    fontSize: 22,
                                    color: lightColorScheme.onSecondaryContainer,
                                  letterSpacing: 2,
                                  height: 1.7
                                ),
                              )                          ),
                        );
                      } else if (snapshot.hasError) {
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
              future: content,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data![2].length != 1){
                    return Padding(
                        padding: EdgeInsets.only(left:20,bottom: 15,right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("連結",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: lightColorScheme.primary,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 15),
                              child: Tooltip(
                                child: ElevatedButton(
                                    clipBehavior: Clip.hardEdge,
                                    onPressed: () {
                                      _launchURL(context, snapshot.data![2]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.language_outlined),
                                          Padding(padding: EdgeInsets.only(left: 10),
                                              child: Text("訪問連結",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 20
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                    )
                                ),
                                message: snapshot.data![2],
                              ),
                            )
                          ],
                        )
                    );
                  }else{
                    return Padding(padding: EdgeInsets.only());
                  }
                } else if (snapshot.hasError) {
                  return ErrorCard(errorCode: snapshot.error.toString());
                }
                // By default, show a loading spinner.
                return Center(
                    child: CircularProgressIndicator()
                );
              },
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 50)),
          ],
        ),
      ),
    );
  }
}