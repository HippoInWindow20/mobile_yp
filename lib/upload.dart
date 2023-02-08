import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

String?  newEventValiation = "";

Future<String> enterUploadMode () async {
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
        "but_add":"新增"
      }
  );
  var document = parse(response.body);
  newEventValiation = document.getElementById("__EVENTVALIDATION")?.attributes['value'];
  if (response.statusCode == 200){
    return "success";
  }else{
    return "failed";
  }
  //No problem here
}

Future<String> submitUpload (title,content,link) async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tua-1.aspx');
  var response = await http.post(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":ASPCookie!
      },
      body: {
        "__VIEWSTATE": viewStateUploadReal,
        "__VIEWSTATEGENERATOR": viewstateGeneratorUploadReal,
        "__EVENTVALIDATION":newEventValiation,
        "but_save":"儲存",
        "tbox_purport":title.toString(),
        "tbox_content":content.toString(),
        "tbox_link":link.toString()
      }
  );
  print(response.body);
  if (response.statusCode == 200){
    return "success";
  }else{
    return "failed";
  }
}


class UploadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return stateUploadPage();
  }
}


class stateUploadPage extends State {
  final TitleController = TextEditingController();
  final ContentController = TextEditingController();
  final LinkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("新增"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var result2 = await submitUpload(TitleController.text, ContentController.text, LinkController.text);
                print(result2);
                if (result2 == "success"){
                  Navigator.pop(context);
                }else{
                  Navigator.pop(context);
                  showDialog(context: context, builder: (context){
                    return Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("error"),
                      ),
                    );
                  });
                }
              },
              icon: Icon(Icons.save_outlined))
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        controller: TitleController,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground
                        ),
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground
                            ),
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground
                            ),
                            focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                            labelText: '標題',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.onBackground
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.onBackground
                                )
                            )
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left:20,bottom: 15,right: 20),
                        child: TextField(
                          controller: ContentController,
                          minLines: 15,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground
                          ),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                              focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              labelText: '內容',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onBackground
                                  )
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onBackground
                                  )
                              )
                          ),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(left:20,bottom: 15,right: 20),
                        child: TextField(
                          controller: LinkController,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground
                          ),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground
                              ),
                              focusColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              labelText: '連結',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onBackground
                                  )
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.onBackground
                                  )
                              )
                          ),
                        ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}