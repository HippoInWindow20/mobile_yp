
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:mobile_yp/color_schemes.g.dart";
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import "package:mobile_yp/custom_color.g.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<String> content = Future.value("");

Future<String> getContentOfCC () async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/bu2.aspx');
  var response = await http.post(
    url,
    headers: {
    "Content-Type":"application/x-www-form-urlencoded",
      "accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  },
      body: {
        "__EVENTTARGET": "GridView1",
        "__EVENTARGUMENT":"count\$0",
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
  return document.outerHtml;
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 30,
                    color: lightColorScheme.onPrimaryContainer
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
                      child: Text("蘇明慧",
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
                child: Padding(padding: EdgeInsets.only(top: 15),
                  child: FutureBuilder<String>(
                    future: content,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!,
                          style: TextStyle(
                              fontSize: 20,
                              color: lightColorScheme.onSecondaryContainer
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  )
                )
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Padding(
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
                      child: ElevatedButton(
                        onPressed: () {  },
                        child: Row(
                          children: [
                            Icon(Icons.language_outlined),
                            Padding(padding: EdgeInsets.only(left: 10),
                            child: Text("Hi",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            )
                          ],
                        )
                      )
                    )
                  ],
                )
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 50)),
          ],
        ),
      ),
    );
  }
}