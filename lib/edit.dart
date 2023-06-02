import 'package:flutter/material.dart';
import 'package:mobile_yp/main.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_yp/upload.dart';

import 'admin_list.dart';


Future<String> submitEdit (title,content,link) async {
  var url = Uri.https('lds.yphs.tp.edu.tw', 'tea/tua-1.aspx');
  var response = await http.post(
      url,
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
        "cookie":ASPCookie!
      },
      body: {
        "__VIEWSTATE": newViewState,
        "__VIEWSTATEGENERATOR": viewstateGeneratorUploadReal,
        "__EVENTVALIDATION":newEventValiation,
        "but_save":"儲存",
        "tbox_purport":title.toString(),
        "tbox_content":content.toString(),
        "tbox_link":link.toString()
      }
  );
  if (response.statusCode == 200){
    return "success";
  }else{
    return "failed";
  }
}

var editTitleController = TextEditingController();
var editContentController = TextEditingController();
var editLinkController = TextEditingController();

class EditPage extends StatefulWidget {
  @override

  State<StatefulWidget> createState() {
    return stateEditPage();
  }
}


class stateEditPage extends State {
  void setStateFunc () {
    setState(() {

    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("編輯"),
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
                var result2 = await submitEdit(editTitleController.text, editContentController.text, editLinkController.text);
                if (result2 == "success"){

                  uploadResult = Future.value(Text(""));
                  setState(() {

                  });
                  uploadResult = retrieveAdminList(setStateFunc);
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
                        controller: editTitleController,
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
                          controller: editContentController,
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
                          controller: editLinkController,
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