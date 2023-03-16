import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share_plus/share_plus.dart';

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


class ViewC extends StatefulWidget {
  @override
  ViewC({
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
    return stateView(title: title, agency: agency, date: date, count: count);
  }
}


class stateView extends State<ViewC> {
  stateView({
    required this.title,required this.agency,required this.date, required this.count,
  });
  final String title;
  final String agency;
  final String date;
  final int count;

  var actualContent = ["null"];
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
          color: Theme.of(context).colorScheme.onSecondaryContainer
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
              onPressed: (){
                content = getContentOfCC(count);
                setState(() {

                });
              },
              icon: Icon(Icons.refresh_outlined)
          ),
          IconButton(
              onPressed: (){
                if (actualContent.toString().contains("null") == false && link.contains("null") == false){
                  var newContent = "主旨：" + title + "\n\n";
                  for (var x = 0;x < actualContent.length;x++){
                    newContent += actualContent[x] + "\n";
                  }
                  newContent += "\n\n連結： " + link;
                  Share.share(newContent,subject: title);
                }else if (actualContent.toString().contains("null") == false && link.contains("null") == true){
                  var newContent = "主旨：" + title + "\n\n";
                  for (var x = 0;x < actualContent.length;x++){
                    newContent += actualContent[x] + "\n";
                  }
                  Share.share(newContent,subject: title);
                }else {
                  showDialog(context: context, builder: (context){
                    return ErrorDesc(errordesc: "沒有分享的內容",);
                  });
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
                      Padding(
                          padding: EdgeInsets.only(left:20,bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.person_outlined,size: 30,color: Theme.of(context).colorScheme.onSecondaryContainer),
                              Padding(padding: EdgeInsets.only(left: 15),
                                child: FutureBuilder<List>(
                                  future: content,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(snapshot.data![0],
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("");
                                    }

                                    // By default, show a loading spinner.
                                    return Text("");
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
                              actualContent = snapshot.data![1];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(snapshot.data![1].length, (index) =>
                                    Text(snapshot.data![1][index].trim(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                                          letterSpacing: 2,
                                          height: 1.7
                                      ),
                                    )                          ),
                              );
                            } else if (snapshot.hasError) {
                              actualContent = ["null"];
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
                  future: content,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data![2].length != 1){
                        link = snapshot.data![2];
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
                                    message: snapshot.data![2],
                                    child: ElevatedButton(
                                        clipBehavior: Clip.hardEdge,
                                        onPressed: () {
                                          _launchURL(context, snapshot.data![2]);
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