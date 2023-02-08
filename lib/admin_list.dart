
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_yp/admin.dart';
import 'package:mobile_yp/main.dart';
import 'package:mobile_yp/settings.dart';
import 'package:mobile_yp/public_cc.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:mobile_yp/upload.dart';



Future<Widget> uploadResult = Future.value(Text(""));


Future<Widget> retrieveAdminList () async {
  var getPage = await http.get(Uri.https('lds.yphs.tp.edu.tw', 'tea/tua.aspx'));
  viewstateGeneratorUpload = parse(getPage.body).getElementById("__VIEWSTATEGENERATOR")?.attributes['value'];
  eventValidationUpload = parse(getPage.body).getElementById("__EVENTVALIDATION")?.attributes['value'];
  viewStateUpload = parse(getPage.body).getElementById("__VIEWSTATE")?.attributes['value'];

  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tua.aspx');
  var response = await http.post(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":ASPCookie!
      },
      body: {
        "__VIEWSTATE": viewStateUpload,
        "__VIEWSTATEGENERATOR": viewstateGeneratorUpload,
        "__EVENTVALIDATION":eventValidationUpload,
        "tbox_acc": defaultAccount,
        "tbox_pwd": defaultAdminPwd,
        "tbox_cls": defaultClass,
        "but_login":"登　　入"
      }
  );
  if (response.body.contains("Object moved")) {
    return returnUploadCC();
  }else {
    return Text(response.body);
  }
}

Future<Widget> returnUploadCC () async {

  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tua-1.aspx');
  var response = await http.get(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":ASPCookie!
      },
  );

  var document = parse(response.body);


  viewstateGeneratorUploadReal = document.getElementById("__VIEWSTATEGENERATOR")?.attributes['value'];
  eventValidationUploadReal = document.getElementById("__EVENTVALIDATION")?.attributes['value'];
  viewStateUploadReal = document.getElementById("__VIEWSTATE")?.attributes['value'];

  List titles = [];
  List dates = [];
  var TDs = document.getElementsByTagName("td");

  for (var j in TDs) {
    if (j.outerHtml.toString().contains('width="390"')){
      var tmp = j.innerHtml;
      var str = tmp.substring(22,(tmp.length - 7));
      titles.add(str);
    }
  }

  for (var k in TDs) {
    if (k.outerHtml.toString().contains('width="180"')){
      var tmp = k.innerHtml;
      var str = tmp.substring(22,(tmp.length - 7));
      dates.add(str);
    }
  }

  var result = [];

  for (var m = 0;m < dates.length;m++){
    result.add([titles[m],dates[m],m]);
  }


  return Column(
    children: List.generate(
        result.length, (index) =>
        ListCardUpload(
            title: result[index][0],
            date: result[index][1],
            count: result[index][2]
        )
    ),
  );
}




class UploadCC extends StatefulWidget {
  UploadCC({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;

  @override
  State<StatefulWidget> createState() {
    return _UploadCCState(setStateCallBack: setStateCallBack);
  }

}


class _UploadCCState extends State<UploadCC> {
  _UploadCCState({
    required this.setStateCallBack,
  });
  final Function setStateCallBack;
  @override

  Widget build(BuildContext context) {
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
              "上傳",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 40
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
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
                      uploadResult = Future.value(Text(""));
                      setState(() {

                      });
                      uploadResult = retrieveAdminList();
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
            child: FutureBuilder<Widget>(
              future: uploadResult,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  return ErrorCard(errorCode: snapshot.error.toString());
                }

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
          enterUploadMode();
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) {
                    return gotoSettings(
                        UploadPage()
                    );
                  }
              )
          );
        },
        child: Icon(
          Icons.add_outlined
        ),

      ),
    );
  }

}

class ListCardUpload extends StatelessWidget {
  const ListCardUpload({
    Key? key, required this.title, required this.date, required this.count,
  }) : super(key: key);
  final String title;
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
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20,bottom: 20,right: 20),
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
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit_outlined,size: 30,)
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10,right: 10),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete_outlined,size: 30,)
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
        ),

      );
  }
}

