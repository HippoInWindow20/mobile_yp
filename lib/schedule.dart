
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


Future<List> calResult = Future.value([]);



Future<List> getCal () async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/gr2.aspx');
  var response = await http.post(url,body: {});
  var document = parse(response.body);
  var TDs = document.getElementsByTagName("td");
  viewstateGeneratorCal = document.getElementById("__VIEWSTATEGENERATOR")?.attributes['value'];
  eventValidationCal = document.getElementById("__EVENTVALIDATION")?.attributes['value'];
  viewStateCal = document.getElementById("__VIEWSTATE")?.attributes['value'];

  http.post(
    url,
    headers: {
      "Content-Type":"application/x-www-form-urlencoded",
      "cookie":ASPCookie!
    },
    body: {
      "__EVENTTARGET": "DLY",
      "__EVENTARGUMENT":"",
      "__LASTFOCUS":"",
      "__VIEWSTATE":viewStateCal,
      "__VIEWSTATEGENERATOR":viewstateGeneratorCal,
      "__EVENTVALIDATION":eventValidationCal,
      "DLY":"112",
      "DLM":"3",
      "DLD":"16",
      "DLG":"全校",
      "DLW":"近日行事"
    },
  );
  return [response.body];
}

class Schedule extends StatefulWidget {
  Schedule({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;

  @override
  State<StatefulWidget> createState() {
    return ScheduleState(setStateCallBack: setStateCallBack);
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


class ScheduleState extends State {
  @override
  ScheduleState({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  Widget build(BuildContext context) {

    Future<void> _refresh() async {
      calResult = getCal();
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
              "行事曆",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 40
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              IconButton(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                  iconColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground,)
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: FilterOptionsSc(),
                      );
                    },
                  );
                },
                icon: Icon(Icons.tune_outlined),
              ),
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
                      calResult = Future.value([]);
                      setState(() {

                      });
                      calResult = getCal();
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
              future: calResult,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children:
                      [
                        Text(snapshot.data?[0])
                    // SwipeRefresh.material(
                      //   shrinkWrap: true,
                      //   stateStream: _stream,
                      //   onRefresh: _refresh,
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   children: List.generate(snapshot.data!.length, (index) =>
                      //       ListCard(title: snapshot.data![index][0], agency: snapshot.data![index][1], date: snapshot.data![index][2], count: snapshot.data![index][3])
                      //   ),
                      // ),
                      // List.generate(snapshot.data!.length, (index) =>
                      //     ListCard(title: snapshot.data![index][0], agency: snapshot.data![index][1], date: snapshot.data![index][2], count: snapshot.data![index][3])
                      // )
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context, builder: (context) {
                return Dialog(
                  child: FutureBuilder<List>(
                    future: calResult,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Padding(
                              padding: EdgeInsets.all(25),
                            child: Text(
                                snapshot.data?[0]
                            ),
                          ),
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
                );
          }
          );
        },
        child: Icon(Icons.tips_and_updates_outlined),
      ),
      );
  }

}

class FilterOptionsSc extends StatelessWidget {

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