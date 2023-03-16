
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

import 'edit.dart';



Future<Widget> uploadResult = Future.value(Text(""));


Future<Widget> retrieveAdminList (Function setState) async {
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
    return returnUploadCC(setState);
  }else {
    return Text(response.body);
  }
}

Future<Widget> returnUploadCC (Function setState) async {

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
            count: result[index][2],
          setState: setState,
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
                      uploadResult = retrieveAdminList(setStateCallBack);
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
    Key? key,
    required this.title,
    required this.date,
    required this.count,
    required this.setState,
  }) : super(key: key);
  final String title;
  final String date;
  final int count;
  final Function setState;

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
                            onPressed: () async {
                              var res = await getCCEdit(count);
                              editTitleController.text = res[0].toString();
                              editContentController.text = res[1].toString().substring(1,res[1].toString().length);
                              editLinkController.text = res[2].toString();
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return gotoSettings(
                                            EditPage()
                                        );
                                      }
                                  )
                              );
                            },
                            icon: Icon(Icons.edit_outlined,size: 35)
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10,right: 10),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return Dialog(
                                      child: Padding(
                                          padding: EdgeInsets.all(30),
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 20),
                                                  child: Icon(Icons.warning_amber_outlined,size: 40,),
                                                ),
                                                Text("確定要刪除嗎？",
                                                style: TextStyle(
                                                    fontSize: 30
                                                  ),
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      var res = await deleteCC(count);
                                                      Navigator.pop(context);
                                                      if (res == "failed"){
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Dialog(
                                                                child: Text("failed"),
                                                              );
                                                            }
                                                        );
                                                      }
                                                      uploadResult = retrieveAdminList(setState);
                                                      MobileYP.of(context).setStateFunc();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 100,vertical: 20),
                                                      child: Text("是",
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  style: ButtonStyle(
                                                    maximumSize: MaterialStatePropertyAll(Size(MediaQuery.of(context).size.width,100))
                                                  ),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  style: ButtonStyle(
                                                      maximumSize: MaterialStatePropertyAll(Size(MediaQuery.of(context).size.width,100))
                                                  ),
                                                    child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 100,vertical: 20),
                                                      child: Text("否",
                                                        style: TextStyle(
                                                            fontSize: 30
                                                        ),
                                                      ),
                                                    ),

                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );
                            },
                            icon: Icon(Icons.delete_outlined,size: 35)
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

Future<List> getCCEdit (int count) async {
  var realCount = count + 2;
  String formattedCount = "";
  if (realCount < 10){
    formattedCount = "0" + realCount.toString();
  }else{
    formattedCount = realCount.toString();
  }
  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tua-1.aspx');
  var response = await http.post(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":ASPCookie!
      },
      body: {
        "__EVENTTARGET":"",
        "__EVENTARGUMENT":"",
        "__VIEWSTATE": viewStateUploadReal,
        "__VIEWSTATEGENERATOR": viewstateGeneratorUploadReal,
        "__EVENTVALIDATION":eventValidationUploadReal,
        "GridViewS\$ctl"+formattedCount+"\$but_vf1":"修改"
      }
  );
  var document = parse(response.body);
  var title = document.getElementById("tbox_purport")?.attributes['value'];
  var content = document.getElementById("tbox_content")?.innerHtml;
  var link = document.getElementById("tbox_link")?.attributes['value'];
  newEventValiation = document.getElementById("__EVENTVALIDATION")?.attributes['value'];
  newViewState = document.getElementById("__VIEWSTATE")?.attributes['value'];
  if (link == null){
    return [title,content,""];
  }else{
    return [title,content,link];
  }
}

Future<String> deleteCC (int count) async {
  var realCount = count + 2;
  String formattedCount = "";
  if (realCount < 10){
    formattedCount = "0" + realCount.toString();
  }else{
    formattedCount = realCount.toString();
  }
  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tua-1.aspx');
  var response = await http.post(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":ASPCookie!
      },
      body: {
        "__EVENTTARGET":"",
        "__EVENTARGUMENT":"",
        "__VIEWSTATE": viewStateUploadReal,
        "__VIEWSTATEGENERATOR": viewstateGeneratorUploadReal,
        "__EVENTVALIDATION":eventValidationUploadReal,
        "GridViewS\$ctl"+formattedCount+"\$Button1":"修改"
      }
  );
  if (response.statusCode == 200){
    return "success";
  }else{
    return "failed";
  }
}
