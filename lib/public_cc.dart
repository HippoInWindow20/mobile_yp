
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import "package:mobile_yp/color_schemes.g.dart";
import "package:mobile_yp/custom_color.g.dart";
import 'package:mobile_yp/main.dart';
import 'package:mobile_yp/view.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
Future<List> result = Future.value([]);


Future<List> getCC () async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/bu2.aspx');
  var response = await http.get(url);
  var document = parse(response.body);
  var TDs = document.getElementsByTagName("td");
  viewstateGenerator = document.getElementById("__VIEWSTATEGENERATOR")?.attributes['value'];
  eventValidation = document.getElementById("__EVENTVALIDATION")?.attributes['value'];
  viewState = document.getElementById("__VIEWSTATE")?.attributes['value'];
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

class publicCC extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _publicCCState();
  }

}




class _publicCCState extends State<publicCC> {
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
          IconButton(onPressed: () {
            setState(() {
              result = getCC();
            });
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List>(
          future: result,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: List.generate(snapshot.data!.length, (index) =>
                  ListCard(title: snapshot.data![index][0], agency: snapshot.data![index][1], date: snapshot.data![index][2], count: snapshot.data![index][3])
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
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
              content = getContentOfCC();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {return View(title: title,agency: agency,date: date,count: count,);}));

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