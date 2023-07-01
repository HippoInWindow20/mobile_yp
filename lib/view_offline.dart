import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mobile_yp/view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

Future<List> content = Future.value([]);



class OfflineView extends StatefulWidget {
  @override
  OfflineView({
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
    required this.link,
    required this.content
  });
  final String title;
  final String agency;
  final String date;
  final int count;
  final String link;
  final List content;
  State<StatefulWidget> createState() {
    return stateOfflineView(title: title, agency: agency, date: date, count: count,link: link,content: content);
  }
}


class stateOfflineView extends State<OfflineView> {
  stateOfflineView({
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
    required this.content,
    required this.link,
  });
  final String title;
  final String agency;
  final String date;
  final int count;
  final List content;
  final String link;

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
                var query = isInSaved(title);
                if (query == -1){
                  savedContent.add([title,content,link]);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("已新增至收藏")
                      )
                  );
                }else{
                  savedContent.removeAt(query);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("已從收藏移除")
                      )
                  );
                }
                setState(() {

                });

              },
              icon: isInSaved(title) != -1 ? Icon(Icons.star) : Icon(Icons.star_border)
          ),
          IconButton(
              onPressed: (){
                if (content.toString().contains("null") == false && link.contains("null") == false){
                  var newContent = "主旨：" + title + "\n\n";
                  for (var x = 0;x < content.length;x++){
                    newContent += content[x] + "\n";
                  }
                  newContent += "\n\n連結： " + link;
                  Share.share(newContent,subject: title);
                }else if (content.toString().contains("null") == false && link.contains("null") == true){
                  var newContent = "主旨：" + title + "\n\n";
                  for (var x = 0;x < content.length;x++){
                    newContent += content[x] + "\n";
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
                        child: Html(
                          onLinkTap: (String? link, str, element ) {
                            _launchURL(context, link);
                          },
                          style:{
                            "span": Style(
                                letterSpacing: 2,
                                fontSize: FontSize(22)
                            ),
                            "p": Style(
                                letterSpacing: 2,
                                fontSize: FontSize(22)
                            ),
                          },
                          data: content[0].trim(),
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
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15),
                      child: Tooltip(
                        message: link,
                        child: ElevatedButton(
                            clipBehavior: Clip.hardEdge,
                            onPressed: () {
                              _launchURL(context, link);
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
                    ),
                    TextButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: link));
                          // copied successfully
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("已複製連結至剪貼簿")
                              )
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 10),
                                child: Icon(Icons.copy_outlined,size: 30),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                                  child: Text("複製連結",
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
                    )
                  ],
                )
              ),
                Padding(padding: EdgeInsets.symmetric(vertical: 50)),
              ],
            ),
          ),
        ),

      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.language_outlined)
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.copy_outlined)
            )
          ],
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