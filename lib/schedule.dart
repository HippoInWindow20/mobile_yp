
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

var selSeg = "main";

String trimStr (String ori, int Start, int End){
  var oriLength = ori.length;
  return ori.substring(Start,oriLength - End);
}

Future<List<ScheduleItem>> calResult = Future.value([ScheduleItem(year: "0",month: "0",day: "0",dayOfWeek: "0",details: [],examDetails: [])]);

class ScheduleItem {
  final String year;
  final String month;
  final String day;
  final String dayOfWeek;
  final List details;
  final List examDetails;

  ScheduleItem({
    required this.year,
    required this.month,
    required this.day,
    required this.dayOfWeek,
    required this.details,
    required this.examDetails
  });
}
Future<List<ScheduleItem>> getCal () async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'yphs/gr2.aspx');
  var response = await http.post(url,body: {});
  var document = parse(response.body);
  var TDs = document.getElementsByTagName("td");
  // for (var x = 0;x < TDs.length; x++){
  //   print(TDs[x].innerHtml);
  // }
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

  List<ScheduleItem> newObj = [];
  for (var h = 12;h < TDs.length; h = h + 12){
      //decide day of week
      var newDayOfWeek = "";
      if (trimStr(TDs[h + 3].innerHtml,44,7).contains("FF0001") || trimStr(TDs[h + 3].innerHtml,44,7).contains("0001FF")){
        newDayOfWeek = trimStr(TDs[h + 3].innerHtml,66,14);
      }else{
        newDayOfWeek = trimStr(TDs[h + 3].innerHtml,44,7);
      }
      List<String> detailArr = [];
      List<String> examArr = [];
      detailArr = trimStr(TDs[h + 4].innerHtml,44,7).split("。");
      examArr = [trimStr(TDs[h + 10].innerHtml,44,7)];
      //A really repetitive way to remove nbsp
      List<String> newDetail = [];
      List<String> newExam = [];
      for (var y = 0;y < detailArr.length;y++){
        if (detailArr[y].contains("nbsp")){
          newDetail.add("");
        }else{
          newDetail.add(detailArr[y]);
        }
      }
      for (var z = 0;z < examArr.length;z++){
        if (examArr[z].contains("nbsp")){
        }else{
          newExam.add(examArr[z]);
        }
      }
      newDetail.removeLast();
      newObj.add(
          ScheduleItem(
              year: trimStr(TDs[h].innerHtml,44,7),
              month: trimStr(TDs[h + 1].innerHtml,44,7),
              day: trimStr(TDs[h + 2].innerHtml,44,7),
              dayOfWeek: newDayOfWeek,
              details: newDetail,
              examDetails: newExam
          )
      );
  }
  return newObj;
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
              //             child: FilterOptionsSc(),
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
                      calResult = Future.value([ScheduleItem(year: "0",month: "0",day: "0",dayOfWeek: "0",details: [],examDetails: [])]);
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
            child: Padding(
                padding: EdgeInsets.all(10),
              child: SegmentedButton(
                segments: [
                  ButtonSegment(
                      icon: Icon(Icons.schedule_outlined),
                      label: Text("主要行事"),
                      value: "main"
                  ),
                  ButtonSegment(
                      icon: Icon(Icons.quiz_outlined),
                      label: Text("考試"),
                      value: "test"
                  ),
                ],
                selected: {selSeg},
                onSelectionChanged: (value) {
                  setState(() {
                    selSeg = value.first.toString();
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<ScheduleItem>>(
              future: calResult,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children:

                      List.generate(snapshot.data!.length, (index) =>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                  child: Card(
                                    elevation: 0,
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data![index].month+ "/" + snapshot.data![index].day,
                                            style: TextStyle(
                                                fontSize: 20,
                                              color: Theme.of(context).colorScheme.onSecondaryContainer
                                            ),
                                          ),
                                          Text(
                                            snapshot.data![index].dayOfWeek,
                                            style: TextStyle(
                                                fontSize: 12,
                                              color: Theme.of(context).colorScheme.onSecondaryContainer
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              Padding(
                                  padding: EdgeInsets.only(bottom: 50),
                                child: Container(
                                  width: (MediaQuery.of(context).size.width / 4) * 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: selSeg == "main" ? List.generate(snapshot.data![index].details.length, (index2) =>
                                        Card(
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                          elevation: 0,
                                          clipBehavior: Clip.hardEdge,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              width: (MediaQuery.of(context).size.width / 4) * 3 - 20,
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  snapshot.data![index].details[index2],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Theme.of(context).colorScheme.onPrimaryContainer
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ) :
                                    List.generate(snapshot.data![index].examDetails.length, (index3) =>
                                        Card(
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                          elevation: 0,
                                          clipBehavior: Clip.hardEdge,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              width: (MediaQuery.of(context).size.width / 4) * 3 - 20,
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                    "第" + trimStr(snapshot.data![index].examDetails[index3], 0, snapshot.data![index].examDetails[index3].toString().length - 1)+"節："+trimStr(snapshot.data![index].examDetails[index3], 1, 0),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Theme.of(context).colorScheme.onPrimaryContainer
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                      )
                    ,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //         context: context, builder: (context) {
      //           return Dialog(
      //             child: FutureBuilder<List<ScheduleItem>>(
      //               future: calResult,
      //               builder: (context, snapshot) {
      //                 if (snapshot.hasData) {
      //                   return SingleChildScrollView(
      //                     child: Padding(
      //                         padding: EdgeInsets.all(25),
      //                       child: Text(
      //                           snapshot.data![0].toString()
      //                       ),
      //                     ),
      //                   );
      //                 } else if (snapshot.hasError) {
      //                   return ErrorCard(errorCode: snapshot.error.toString());
      //                 }
      //
      //                 // By default, show a loading spinner.
      //                 return const Center(
      //                     child: Padding(
      //                       padding: EdgeInsets.symmetric(vertical: 10),
      //                       child: CircularProgressIndicator(),
      //                     )
      //                 );
      //               },
      //             ),
      //           );
      //     }
      //     );
      //   },
      //   child: Icon(Icons.tips_and_updates_outlined),
      // ),
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