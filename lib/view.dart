import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_yp/external_links.dart';
import 'package:mobile_yp/main.dart';
import "package:mobile_yp/public_cc.dart";
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mobile_yp/saved.dart';
import 'package:mobile_yp/tags.dart';
import 'package:mobile_yp/text_size.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

Future<List> content = Future.value([]);

Future<List> getContentOfCC(String link) async {
  var uri = Uri.parse(link);
  var response = await http.get(uri);
  var document = parse(response.body);
  var contentTry = document.getElementsByClassName("content")[0];
  var content = "";
  if (contentTry.children.length != 0) {
    for (var i = 0; i < contentTry.children.length; i++) {
      content += contentTry.children[i].outerHtml;
    }
    content = "<p>" + content + "</p>";
    content = content.replaceAll("color: #000000", "");
    content = content.replaceAll("<label>", "<strong>");
    content = content.replaceAll("</label>", "</strong>");
    // content = content.replaceAll("<div", "<p");
    // content = content.replaceAll("</div>", "</p>");
  } else {}

  var linkExists = document.getElementsByClassName("modal_download");
  var names = document.getElementsByClassName("modal_name");
  var sizes = document.getElementsByClassName("modal_size");
  List? linkAttach = [];
  if (linkExists.length != 0) {
    for (var k = 0; k < linkExists.length; k++) {
      linkAttach.add([
        names[k].innerHtml.toString(),
        sizes[k].innerHtml.toString(),
        linkExists[k].children[0].attributes['href'].toString()
      ]);
    }
  }

  var extExists = document.getElementsByClassName("url_link blue");
  List? ext = [];
  if (extExists.length != 0) {
    for (var m = 0; m < extExists.length; m++) {
      ext.add([
        extExists[m].children[0].innerHtml.toString(),
        extExists[m].attributes['href'].toString()
      ]);
    }
  }
  return [
    [content],
    linkAttach,
    ext
  ];
}

int isInSaved(String title) {
  var isSaved = false;
  int i = 0;
  int result = -1;
  while (isSaved == false && i < savedContentManual.length) {
    if (savedContentManual[i].toString().contains(title)) {
      isSaved = true;
    }
    i++;
  }
  return isSaved == true ? i - 1 : result;
}

class ViewC extends StatefulWidget {
  @override
  ViewC(
      {required this.title,
      required this.agency,
      required this.date,
      required this.count,
      required this.url,
      required this.tags});

  final String title;
  final String agency;
  final String date;
  final int count;
  final String url;
  final List tags;

  State<StatefulWidget> createState() {
    return stateView(
        title: title,
        agency: agency,
        date: date,
        count: count,
        url: url,
        tags: tags);
  }
}

class stateView extends State<ViewC> {
  stateView(
      {required this.title,
      required this.agency,
      required this.date,
      required this.count,
      required this.url,
      required this.tags});

  final String title;
  final String agency;
  final String date;
  final int count;
  final String url;
  final List tags;

  var actualContent = ["null"];
  List links = [
    ["null", "null", "null"]
  ];
  List exts = [
    ["null", "null", "null"]
  ];

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
          //     onPressed: () {
          //       showDialog(
          //           context: context,
          //           builder: (context) {
          //             return Dialog(
          //               child: Padding(
          //                 padding: EdgeInsets.all(20),
          //                 child: FutureBuilder(
          //                     future: content,
          //                     builder: (context, snapshot) {
          //                       if (snapshot.hasData) {
          //                         return CustomScrollView(
          //                           shrinkWrap: true,
          //                           slivers: [
          //                             SliverToBoxAdapter(
          //                               child: Padding(
          //                                 padding: EdgeInsets.only(bottom: 20),
          //                                 child: Text(
          //                                   "顯示原始碼",
          //                                   style: TextStyle(
          //                                     fontSize: 25,
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                             SliverToBoxAdapter(
          //                               child: Text(snapshot.data.toString()),
          //                             ),
          //                             SliverToBoxAdapter(
          //                               child: TextButton(
          //                                 child: Text("關閉"),
          //                                 onPressed: () {
          //                                   Navigator.pop(context);
          //                                 },
          //                               ),
          //                             )
          //                           ],
          //                         );
          //                       } else {
          //                         return Text("");
          //                       }
          //                     }),
          //               ),
          //             );
          //           });
          //     },
          //     icon: Icon(Icons.code)),
          IconButton(
              onPressed: () {
                _launchURL(context, url);
              },
              icon: Icon(Icons.open_in_browser)),
          // IconButton(
          //     onPressed: () async {
          //       var query = isInSaved(title);
          //       if (query == -1){
          //         // savedContent.add([title,agency,date,actualContent,link]);
          //         var awaitSavedJSON = r'''{"title":"'''+title+'''","agency":"'''+agency+'''","date":"'''+date+'''","actualContent":"'''+actualContent[0]+'''","link":"'''+link+'''"}''';
          //         savedContentManual.add(awaitSavedJSON);
          //
          //
          //         ScaffoldMessenger.of(context).removeCurrentSnackBar();
          //         ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //                 content: Text("已新增至收藏")
          //             )
          //         );
          //       }else{
          //         savedContentManual.removeAt(query);
          //         ScaffoldMessenger.of(context).removeCurrentSnackBar();
          //         ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //                 content: Text("已從收藏移除")
          //             )
          //         );
          //       }
          //       savedContent = r'''{"items":'''+savedContentManual.toString()+'''}''';
          //       var prefs = await SharedPreferences.getInstance();
          //       await prefs.setString("savedContent", savedContent);
          //       savedResult = formatSaved();
          //       setState(() {
          //
          //       });
          //     },
          //     icon: isInSaved(title) != -1 ? Icon(Icons.star) : Icon(Icons.star_border)
          // ),
          IconButton(
              onPressed: () {
                content = getContentOfCC(url);
                setState(() {});
              },
              icon: Icon(Icons.refresh_outlined)),
          IconButton(
              onPressed: () {
                if (actualContent.toString().contains("null") == false &&
                    links[0].contains("null") == false) {
                  var newContent = "主旨：" + title + "\n\n";
                  for (var x = 0; x < actualContent.length; x++) {
                    newContent += actualContent[x] + "\n";
                  }
                  newContent += "\n\n連結： \n";
                  for (var x = 0; x < links.length; x++) {
                    newContent += links[x][0].toString() + ":\n";
                    newContent += links[x][2].toString() + "\n\n";
                  }
                  Share.share(newContent, subject: title);
                } else if (actualContent.toString().contains("null") == false &&
                    links[0].contains("null") == true) {
                  var newContent = "主旨：" + title + "\n\n";
                  for (var x = 0; x < actualContent.length; x++) {
                    newContent += actualContent[x] + "\n";
                  }
                  Share.share(newContent, subject: title);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ErrorDesc(
                          errordesc: "沒有分享的內容",
                        );
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
                      Padding(
                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: List.generate(
                                tags.length,
                                (index) => Card(
                                      clipBehavior: Clip.hardEdge,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return gotoSettings(
                                                TagsPage(tag: tags[index]));
                                          }));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "#" + tags[index],
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 15),
                        child: FutureBuilder<List>(
                          future: content,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              actualContent = snapshot.data![0];
                              return SelectionArea(
                                child: HtmlWidget(
                                  snapshot.data![0][0].trim(),
                                  customStylesBuilder: (element) {
                                    if (element.classes
                                        .contains("modal_content")) {
                                      return {'display': 'none'};
                                    }
                                    if (element.classes
                                        .contains("modal_list")) {
                                      return {'display': 'none'};
                                    }
                                    var x = element
                                        .getElementsByTagName("noscript");
                                    for (var y = 0; y < x.length; y++) {
                                      return {'display': 'none'};
                                    }
                                    return {
                                      'font-size': '${TextScaling.round()}px',
                                      'line-height':
                                          '${TextScaling.round() * 1.83333}px'
                                    };
                                  },
                                  onTapImage: (image) {
                                    _launchURL(context, image.sources);
                                  },
                                  onTapUrl: (url) {
                                    _launchURL(context, url);
                                    return true;
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              actualContent = ["null"];
                              links = ["null"];
                              return ErrorCard(
                                  errorCode: snapshot.error.toString());
                            }

                            // By default, show a loading spinner.
                            return Center(
                                child:
                                    CircularProgressIndicator(year2023: false));
                          },
                        ))),
                Padding(padding: EdgeInsets.symmetric(vertical: 50)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FutureBuilder<List>(
        future: content,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //snapshot.data![2] == ext
            if (snapshot.data![1].length != 0 &&
                snapshot.data![2].length != 0) {
              links = snapshot.data![1];
              exts = snapshot.data![2];

              return BottomAppBar(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                showDragHandle: true,
                                context: context,
                                builder: (context) {
                                  return LinksOpen(links: links, exts: exts);
                                });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.file_open_outlined),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "附件",
                                  style: TextStyle(fontSize: 22),
                                ),
                              )
                            ],
                          )),
                    ),
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return LinksOpen(links: links, exts: exts);
                              });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.public_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "連結",
                                style: TextStyle(fontSize: 22),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              );
            } else if (snapshot.data![1].length == 0 &&
                snapshot.data![2].length != 0) {
              exts = snapshot.data![2];

              return BottomAppBar(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return LinksOpen(links: [], exts: exts);
                              });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.public_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "連結",
                                style: TextStyle(fontSize: 22),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              );
            } else if (snapshot.data![1].length != 0 &&
                snapshot.data![2].length == 0) {
              links = snapshot.data![1];

              return BottomAppBar(
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return LinksOpen(links: links, exts: []);
                              });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.file_open_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "附件",
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
