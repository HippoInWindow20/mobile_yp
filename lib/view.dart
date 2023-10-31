import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mobile_yp/saved.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

Future<List> content = Future.value([]);

Future<List> getContentOfCC (String link) async {
  var uri = Uri.parse(link);
  var response = await http.get(uri);
  var document = parse(response.body);
  var contentTry = document.getElementsByClassName("content")[0];
  var content = "";
  if (contentTry.children.length != 0){
    for (var i = 0;i < contentTry.children.length;i++){
      content += contentTry.children[i].outerHtml;
    }
    content = "<p>" + content + "</p>";
    content = content.replaceAll("color: #000000", "");
    content = content.replaceAll("<label>", "<strong>");
    content = content.replaceAll("</label>", "</strong>");
    content = content.replaceAll("<div", "<p");
    content = content.replaceAll("</div>", "</p>");
  }else{

  }

  var linkExists = document.getElementsByClassName("modal_download");
  String? linkAttach = "";
  if (linkExists.length != 0){
    linkAttach = linkExists[0].children[0].attributes['href'].toString();
  }
  return [[content],linkAttach];

}

int isInSaved(String title) {
  var isSaved = false;
  int i = 0;
  int result = -1;
  while (isSaved == false && i < savedContent.length){
    if (savedContent[i][0].toString() == title){
      isSaved = true;
    }
    i++;
  }
  return isSaved == true ? i - 1 : result;
}


class ViewC extends StatefulWidget {
  @override
  ViewC({
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
    required this.url
  });
  final String title;
  final String agency;
  final String date;
  final int count;
  final String url;
  State<StatefulWidget> createState() {
    return stateView(title: title, agency: agency, date: date, count: count,url: url);
  }
}


class stateView extends State<ViewC> {
  stateView({
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
    required this.url
  });
  final String title;
  final String agency;
  final String date;
  final int count;
  final String url;

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
          color: Theme.of(context).colorScheme.onPrimaryContainer
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: FutureBuilder(
                              future: content,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CustomScrollView(
                                    shrinkWrap: true,
                                    slivers: [
                                      SliverToBoxAdapter(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Text("顯示原始碼",
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                        child: Text(snapshot.data.toString()),
                                      ),
                                      SliverToBoxAdapter(
                                        child: TextButton(
                                          child: Text("關閉"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                }else{
                                  return Text("");
                                }
                              }
                          ),
                        ),
                      );
                    }
                );
              },
              icon: Icon(Icons.code)
          ),
          IconButton(
              onPressed: () {
                _launchURL(context, url);
              },
              icon: Icon(Icons.open_in_browser)
          ),
          IconButton(
              onPressed: () async {
                var query = isInSaved(title);
                if (query == -1){
                  savedContent.add([title,agency,date,actualContent,link]);
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
                // var prefs = await SharedPreferences.getInstance();
                // await prefs.setStringList("savedContent", savedContent);
                savedResult = formatSaved();
                setState(() {

                });
              },
              icon: isInSaved(title) != -1 ? Icon(Icons.star) : Icon(Icons.star_border)
          ),
          IconButton(
              onPressed: (){
                content = getContentOfCC(url);
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
                    padding: EdgeInsets.only(left:10,right: 10),
                    child: Padding(padding: EdgeInsets.only(left:5,right: 5),
                        child: FutureBuilder<List>(
                          future: content,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              actualContent = snapshot.data![0];
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(snapshot.data![0].length, (index) =>
                                      SelectionArea(
                                          child: Html(
                                            shrinkWrap: true,
                                            onLinkTap: (String? link, str, element ) {
                                              _launchURL(context, link);
                                            },
                                            style:{
                                              "span": Style(
                                                  letterSpacing: 2,
                                                  fontSize: FontSize(22),
                                                  textOverflow: TextOverflow.clip
                                              ),
                                              "u": Style(
                                                  textOverflow: TextOverflow.clip
                                              ),
                                              "strong": Style(
                                                  letterSpacing: 2,
                                                  fontSize: FontSize(22),
                                                  textOverflow: TextOverflow.clip
                                              ),
                                              "p": Style(
                                                  letterSpacing: 2,
                                                  fontSize: FontSize(22),
                                                  textOverflow: TextOverflow.clip

                                              ),
                                              "td":Style(
                                                  border: Border.fromBorderSide(BorderSide(color: Color(0xFFFFFFFF))),
                                                  padding: HtmlPaddings(
                                                    left: HtmlPadding(5),
                                                    right: HtmlPadding(5),
                                                    top: HtmlPadding(5),
                                                    bottom: HtmlPadding(5),
                                                  )
                                              ),
                                            },
                                            data: snapshot.data![0][index].trim(),
                                            extensions: [
                                              TableHtmlExtension(),
                                              TagWrapExtension(
                                                  tagsToWrap: {"table"},
                                                  builder: (child) {
                                                    return SingleChildScrollView(
                                                      child: child,
                                                      scrollDirection: Axis.horizontal,
                                                    );
                                                  }
                                              )
                                            ],
                                          )
                                      )
                                  ),
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
                      if (snapshot.data![1].length != 0){
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