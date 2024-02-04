
import 'dart:async';
import 'dart:math';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_yp/schedule.dart';
import 'package:mobile_yp/view.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:animations/animations.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class PublicItem {
  final String title;
  final String agency;
  final String date;
  final String url;
  final int count;
  final List tags;
  PublicItem({
    required this.title,
    required this.agency,
    required this.date,
    required this.url,
    required this.count,
    required this.tags
  });
}

bool ShowPinned = true;

Future<List<PublicItem>> result = Future.value([]);

String cookieGenerator (int length){
  var ListChar = "abcdefghijklmnopqrstuvwxyz012345";
  var res = "";
  for (var x = 0;x < length;x++){
    var intValue = Random().nextInt(ListChar.length);
    res += ListChar[intValue].toString();
  }
  return res;
}


Future<List<PublicItem>> getCC () async {
  var url = Uri.https('www.yphs.tp.edu.tw', 'category/news/news1/');
  var response = await http.get(url);
  var document = parse(response.body);
  var TDs = document.getElementsByClassName("nt_table")[0].children[1].children;
  int newsCount = TDs.length;
  List titles = [];
  List agencies = [];
  List dates = [];
  List<PublicItem> result = [];
  List urls = [];
  List tags = [];
  for (var i = 0; i < newsCount;i++){
    List currentTags = [];
    int tagCount = 0;
    if (TDs[i].children[1].getElementsByClassName("sticky_text").length == 1){
      currentTags.add("置頂");
      tagCount+=2;
    }
    if (TDs[i].children[1].getElementsByClassName("file_type news_type_1").length == 1){
      currentTags.add("公告");
      tagCount+=2;
    }
    if (TDs[i].children[1].getElementsByClassName("file_type news_type_2").length == 1){
      currentTags.add("轉知");
      tagCount+=2;
    }
    if (TDs[i].children[1].getElementsByClassName("file_type news_type_3").length == 1){
      currentTags.add("檢定");
      tagCount+=2;
    }
    if (TDs[i].children[1].getElementsByClassName("file_type news_type_4").length == 1){
      currentTags.add("狂賀");
      tagCount+=2;
    }
    if (TDs[i].children[1].getElementsByClassName("file_type news_type_5").length == 1){
      currentTags.add("競賽");
      tagCount+=2;
    }
    if (TDs[i].children[1].getElementsByClassName("file_type news_type_6").length == 1){
      currentTags.add("課程");
      tagCount+=2;
    }
    if (TDs[i].children[1].getElementsByClassName("file_type news_type_7").length == 1){
      currentTags.add("重要");
      tagCount+=2;
    }
    titles.add(trimStr(TDs[i].children[1].children[0].text, tagCount, 0));
    dates.add(TDs[i].children[0].innerHtml);
    agencies.add(TDs[i].children[3].innerHtml);
    urls.add(TDs[i].children[1].children[0].attributes['href'].toString());
    tags.add(currentTags);
  }
  for (var j = 0; j < newsCount;j++){
    result.add(PublicItem(title: titles[j], agency: agencies[j], date: dates[j], url: urls[j],count: j,tags: tags[j]));
  }
  return result;

}

class publicCC extends StatefulWidget {
  publicCC({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;

  @override
  State<StatefulWidget> createState() {
    return _publicCCState(setStateCallBack: setStateCallBack);
  }

}


Widget gotoSettings (child) {
  return PageTransitionSwitcher(
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          child: child,
          transitionType: SharedAxisTransitionType.horizontal,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
        );
      },
    child: child,
    duration: Duration(milliseconds: 1000),
  );
}


class _publicCCState extends State<publicCC> {
  @override
  _publicCCState({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  Widget build(BuildContext context) {

    Future<void> _refresh() async {
      result = getCC();
      _controller.sink.add(SwipeRefreshState.hidden);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FutureBuilder<List<PublicItem>>(
              future: result,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (ShowPinned == true){
                            ShowPinned = false;
                          }else{
                            ShowPinned = true;
                          }
                          setState(() {

                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ShowPinned == true ? Icon(Icons.expand_more,size: 40) : Icon(Icons.expand_less,size: 40),
                              Text("置頂公告",style: TextStyle(fontSize: 20),)
                            ],
                          ),
                        )
                      ),
                      Column(
                        children:
                        // [SwipeRefresh.material(
                        //   shrinkWrap: true,
                        //   stateStream: _stream,
                        //   onRefresh: _refresh,
                        //   padding: const EdgeInsets.symmetric(vertical: 10),
                        //   children: List.generate(snapshot.data!.length, (index) =>
                        //       ListCard(title: snapshot.data![index][0], agency: snapshot.data![index][1], date: snapshot.data![index][2], count: snapshot.data![index][3])
                        //   ),
                        // ),
                        List.generate(snapshot.data!.length, (index) =>
                            ListCard(
                              title: snapshot.data![index].title,
                              agency: snapshot.data![index].agency,
                              date: snapshot.data![index].date,
                              count: snapshot.data![index].count,
                              url: snapshot.data![index].url,
                              tags: snapshot.data![index].tags,
                            )
                        )
                      // ],
                    )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return ErrorCard(errorCode: snapshot.error.toString());
                }

                // By default, show a loading spinner.
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(),
                    )
                );
              },
            ),
          ),
        ],
        ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            // IconButton(
            //   style: ButtonStyle(
            //     padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
            //     iconColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground,)
            //   ),
            //   onPressed: () {
            //     showModalBottomSheet<void>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return Padding(
            //             padding: EdgeInsets.only(top: 30),
            //             child: FilterOptions(),
            //         );
            //       },
            //     );
            //   },
            //   icon: Icon(Icons.tune_outlined),
            // ),
            IconButton(
                onPressed: () {
                  result = Future.value([]);
                  setState(() {

                  });
                  result = getCC();
                },
                icon: Icon(Icons.refresh_outlined)
            ),
          ],
        ),
      ),
      );
  }

}

class FilterOptions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Padding(
              padding: EdgeInsets.only(left: 20,top:20,bottom: 20),
              child: Row(
                children: [
                  Icon(Icons.apartment_outlined,size: 30,),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "處室",
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  )
                ],
              ),
          ),
          onTap: () {},
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.only(left: 20,top:20,bottom: 20),
            child: Row(
              children: [
                Icon(Icons.calendar_month_outlined,size: 30,),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "日期",
                    style: TextStyle(
                        fontSize: 30
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year - 1),
              lastDate: DateTime.now(),
            );
          },
        )
      ],
    );
  }
}




class ListCard extends StatelessWidget {
  const ListCard({
    Key? key,
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
    required this.url,
    required this.tags
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  final int count;
  final String url;
  final List tags;

  @override
  Widget build(BuildContext context) {
    return
      Visibility(
        visible: (tags.contains("置頂") == true) ? ShowPinned : true,
          child: Hero(
            tag: "main" + count.toString(),
            child: Card(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: InkWell(
                  // onLongPress: () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context){
                  //         return Dialog(
                  //           child: Text(tags.toString() + tags.contains("置頂").toString()),
                  //         );
                  //       }
                  //       );
                  // },
                  onTap: () {
                    content = getContentOfCC(url);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return ViewC(
                            title: title,
                            agency: agency,
                            date: date,
                            count: count,
                            url: url,
                            tags: tags,
                          );
                        })
                    );

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 20,bottom: 30,right: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20,bottom: 20,right: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child:Icon(Icons.apartment_outlined,color: Theme.of(context).colorScheme.onSecondaryContainer,size: 20,),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20,right: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(agency,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20,bottom: 20,right: 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child:Icon(Icons.calendar_month_outlined,color: Theme.of(context).colorScheme.onSecondaryContainer,size: 20,),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(date,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                            // if(tags.contains("置頂") == true)
                            //   Padding(
                            //     padding: EdgeInsets.only(left: 20,bottom: 20,right: 5),
                            //     child: Align(
                            //       alignment: Alignment.topLeft,
                            //       child:Icon(Icons.push_pin,color: Theme.of(context).colorScheme.onSecondaryContainer,size: 20,),
                            //     ),
                            //   ),

                        ],
                      ),
                      if (tags.length != 0)
                        Padding(
                            padding: EdgeInsets.only(left: 20,bottom: 20,right: 5),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.sell_outlined,
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  ),),
                                Row(
                                  children: List.generate(
                                      tags.length, (index) =>
                                      Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Text(
                                          "#"+tags[index],
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            )
                        )
                    ],
                  ),
                )
            ),

          )
      );
  }
}

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key, required this.errorCode,
  }) : super(key: key);
  final String errorCode;

  @override
  Widget build(BuildContext context) {
    return
      Card(
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          elevation: 0,
          color: Theme.of(context).colorScheme.errorContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10,bottom: 10,right: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child:
                          Icon(
                            Icons.signal_cellular_connected_no_internet_0_bar_sharp,
                            size: 30,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                        Text("連線錯誤",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 0,bottom: 10,right: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("點擊重新整理重試",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 0,bottom: 10,right: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(errorCode,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 12,
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