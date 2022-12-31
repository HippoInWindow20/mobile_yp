
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:mobile_yp/color_schemes.g.dart";
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import "package:mobile_yp/custom_color.g.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

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
      "cookie":"ASP.NET_SessionId=f1ugporoajrevet1tlo0c4vo"
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

class ViewPrivate extends StatelessWidget {
  const ViewPrivate({
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondaryContainer
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Hero(
        tag: "main" + count.toString(),
        child: Material(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).colorScheme.onSecondaryContainer
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left:20,bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.apartment,size: 30,color: Theme.of(context).colorScheme.onSecondaryContainer),
                              Padding(padding: EdgeInsets.only(left: 15),
                                child: Text(agency,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context).colorScheme.onSecondaryContainer
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
                              Icon(Icons.calendar_month_outlined,size: 30,color: Theme.of(context).colorScheme.onSecondaryContainer),
                              Padding(padding: EdgeInsets.only(left: 15),
                                child: Text(date,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Theme.of(context).colorScheme.onSecondaryContainer
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![0],
                                    style: TextStyle(
                                      fontSize: 18
                                    ),
                                  )
                                ],
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
                  future: contentPrivate,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data![1].length > 1){
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