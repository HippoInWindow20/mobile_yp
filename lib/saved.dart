
import 'dart:async';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_yp/main.dart';
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

int selectedSaved = 0;

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

List<List<SavedItem>> formatSaved () {
  List<SavedItem> formattedSaved = [];
  List<SavedItem> formattedCC = [];
  for (var i = 0;i < savedContent.length;i++){
    formattedSaved.add(SavedItem(title: savedContent[i][0], agency: savedContent[i][1], date: savedContent[i][2], link: savedContent[i][4], count: i, content: savedContent[i][3]));
  }
  for (var j = 0;j < savedCCContent.length;j++){
    formattedCC.add(SavedItem(title: savedCCContent[j][0], agency: savedCCContent[j][1], date: savedCCContent[j][2], link: savedCCContent[j][4], count: j, content: [savedCCContent[j][3]]));
  }
  print([formattedSaved,formattedCC]);
  return [formattedSaved,formattedCC];
}

List<List<SavedItem>> savedResult = formatSaved();

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
          SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(10),
              child: SegmentedButton(
                segments: [
                  ButtonSegment(value: 0,label: Text("公告欄"),icon: Icon(Icons.info_outline)),
                  ButtonSegment(value: 1,label: Text("網路聯絡簿"),icon: Icon(Icons.announcement_outlined))
                ],
                selected: {selectedSaved},
                onSelectionChanged: (value) {
                  selectedSaved = int.parse(value.first.toString());
                  setState(() {

                  });
                },
              ),
            )
          ),
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              children: List.generate(savedResult[selectedSaved].length, (index) =>
                  OfflineCard(
                      title: savedResult[selectedSaved][index].title,
                      agency: savedResult[selectedSaved][index].agency,
                      date: savedResult[selectedSaved][index].date,
                      count: savedResult[selectedSaved][index].count,
                      content: savedResult[selectedSaved][index].content,
                      link: savedResult[selectedSaved][index].link,
                    type: selectedSaved,
                  )
              ),
            )
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
                  savedResult = formatSaved();
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
    required this.link,
    required this.type
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;
  final int count;
  final List content;
  final String link;
  final int type;

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
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) {
                          return OfflineView(
                            title: title,
                            agency: agency,
                            date: date,
                            count: count,
                            content: content,
                            link: link,
                            type: selectedSaved,
                        );
                      }
                    )
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
