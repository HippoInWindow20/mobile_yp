
import 'dart:async';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_yp/public_cc.dart';
import 'package:mobile_yp/view_offline.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class SavedItem {
  final String title;
  final String agency;
  final String date;
  final String link;
  final int count;
  final List content;
  SavedItem({
    required this.title,
    required this.agency,
    required this.date,
    required this.link,
    required this.count,
    required this.content
  });
}


Future<List<SavedItem>> savedResult = Future.value([]);

class savedCC extends StatefulWidget {
  savedCC({
    required this.setStateCallBack,
  });

  final Function setStateCallBack;

  @override
  State<StatefulWidget> createState() {
    return _savedCCState(setStateCallBack: setStateCallBack);
  }
}


class _savedCCState extends State<savedCC> {
  @override
  _savedCCState({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  Widget build(BuildContext context) {

    Future<void> _refresh() async {
      _controller.sink.add(SwipeRefreshState.hidden);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   pinned: false,
          //   snap: true,
          //   floating: true,
          //   toolbarHeight: 85,
          //   title: Text(
          //     "收藏",
          //     style: TextStyle(
          //       fontSize: 30
          //     ),
          //   ),
          //   backgroundColor: Theme.of(context).colorScheme.background,
          // ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<SavedItem>>(
              future: savedResult,
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
                          OfflineCard(title: snapshot.data![index].title, agency: snapshot.data![index].agency, date: snapshot.data![index].date, count: snapshot.data![index].count,content: snapshot.data![index].content,link: snapshot.data![index].link,)
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
                  setState(() {

                  });
                },
                icon: Icon(Icons.refresh_outlined)
            ),
          ],
        ),
      ),
      );
  }

}

class OfflineCard extends StatelessWidget {
  const OfflineCard({
    Key? key,
    required this.title,
    required this.agency,
    required this.date,
    required this.count,
    required this.content,
    required this.link
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  final int count;
  final List content;
  final String link;

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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return OfflineView(title: title,agency: agency,date: date,count: count,content: content,link: link);}));

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
