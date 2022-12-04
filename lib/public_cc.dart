
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import "package:mobile_yp/color_schemes.g.dart";
import "package:mobile_yp/custom_color.g.dart";
import 'package:mobile_yp/main.dart';
import 'package:mobile_yp/view.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
List list = [];

Route _createRoute(title,agency,date) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => View(title: title,agency: agency,date: date,),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}


Future<List<dynamic>> getCC () async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/bu2.aspx');
  var response = await http.get(url);
  var document = parse(response.body);
  var TDs = document.getElementsByTagName("td");
  List titles = [];
  List agencies = [];
  List dates = [];
  for (var i in TDs) {
    if (i.outerHtml.toString().contains('width="75"')){
      var tmp = i.innerHtml;
      var str = tmp.substring(44,(tmp.length - 7));
      agencies.add(str);
    }
  }

  var As = document.getElementsByTagName("a");
  for (var j in As) {
    var tmp = j.innerHtml;
    var str = tmp.substring(22,(tmp.length - 7));
    titles.add(str);
  }

  var SPANs = document.getElementsByTagName("span");
  for (var k in SPANs) {
    if (k.children.length == 0){
      dates.add(k.innerHtml);
    }
  }
  dates.removeAt(dates.length - 1);
  var result = <dynamic>[];
  for (var y = 0; y < dates.length;y++){
    result.add([titles[y],agencies[y],dates[y],y]);
  }
  return result;
}

class publicCC extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "公告欄",
          style: TextStyle(
              fontSize: 40
          ),
        ),
        backgroundColor: lightColorScheme.background,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(list.length,(index){
              return ListCard(title: list[index][0],agency: list[index][1],date: list[index][2],count: index);
            }
          ),
        ),
      ),
    );
  }


}


class ListCard extends StatelessWidget {
  const ListCard({
    Key? key, required this.title, required this.agency, required this.date, required this.count,
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  final int count;

  @override
  Widget build(BuildContext context) {
    return
      Card(
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          elevation: 0,
          color: lightColorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(_createRoute(title,agency,date));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10,bottom: 10,right: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 0,bottom: 10,right: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(agency,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 0,bottom: 10,right: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(date,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        );
  }
}