
import 'dart:async';
import 'dart:math';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_yp/main.dart';
import 'package:mobile_yp/settings.dart';
import 'package:mobile_yp/view.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:animations/animations.dart';
import 'package:swipe_refresh/swipe_refresh.dart';


Future<List> result = Future.value([]);

String cookieGenerator (int length){
  var ListChar = "abcdefghijklmnopqrstuvwxyz012345";
  var res = "";
  for (var x = 0;x < length;x++){
    var intValue = Random().nextInt(ListChar.length);
    res += ListChar[intValue].toString();
  }
  return res;
}


Future<List> getCC () async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/bu2.aspx');
  var response = await http.post(url,body: {});
  var document = parse(response.body);
  var TDs = document.getElementsByTagName("td");
  viewstateGenerator = document.getElementById("__VIEWSTATEGENERATOR")?.attributes['value'];
  eventValidation = document.getElementById("__EVENTVALIDATION")?.attributes['value'];
  viewState = document.getElementById("__VIEWSTATE")?.attributes['value'];

  http.post(
    url,
    headers: {
      "Content-Type":"application/x-www-form-urlencoded",
      "cookie":ASPCookie!
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
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            toolbarHeight: 100,
            title: Text(
              "公告欄",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 40
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
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
              AppPopupMenu<int>(
                padding: EdgeInsets.all(20),
                menuItems:  [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                        '重新整理',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 20
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                        '設定',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 20
                        )
                    ),
                  ),
                ],
                onSelected: (int value) {
                  switch (value){
                    case 1:
                      result = Future.value([]);
                      setState(() {

                      });
                      result = getCC();
                      break;
                    case 2:
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return gotoSettings(
                                    Settings(setStateCallBack: setStateCallBack,)
                                );
                              }
                          )
                      );
                      break;
                  }
                },
                onCanceled: () {
                },
                tooltip: "更多選項",
                elevation: 30,
                icon: Icon(Icons.more_vert,size: 30,color: Theme.of(context).colorScheme.onBackground,),
                offset: const Offset(0, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant,
              )
            ],
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List>(
              future: result,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
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
                          ListCard(title: snapshot.data![index][0], agency: snapshot.data![index][1], date: snapshot.data![index][2], count: snapshot.data![index][3])
                      )
                    // ],
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
    Key? key, required this.title, required this.agency, required this.date, required this.count,
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  final int count;

  @override
  Widget build(BuildContext context) {
    return
      Hero(
        tag: "main" + count.toString(),
        child: Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: InkWell(
              onTap: () {
                content = getContentOfCC(count);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return ViewC(title: title,agency: agency,date: date,count: count,);}));

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
                      )
                    ],
                  ),
                ],
              ),
            )
        ),

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