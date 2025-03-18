import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

double TextScaling = 24;

class TextSize extends StatefulWidget {
  Function setStateFunc;

  @override
  TextSize({required this.setStateFunc});

  State<StatefulWidget> createState() {
    return _StateTextSize(setStateFunc: setStateFunc);
  }
}

class _StateTextSize extends State {
  Function setStateFunc;

  _StateTextSize({required this.setStateFunc});

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text("字體大小"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onBackground),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onBackground),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      "說明",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "此設定影響閱讀內文的字體大小，對於其他物件大小不改變。欲改變整體版面大小，請更改系統設定。\n",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "請滑動下方滑桿調整大小。",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  if (TextScaling < 24)
                    Text(
                      "目前大小：" + TextScaling.round().toString() + " (小)",
                      style: TextStyle(fontSize: 20),
                    ),
                  if (TextScaling == 24)
                    Text(
                      "目前大小：" + TextScaling.round().toString() + " (預設，中)",
                      style: TextStyle(fontSize: 20),
                    ),
                  if (TextScaling > 24 && TextScaling <= 36)
                    Text(
                      "目前大小：" + TextScaling.round().toString() + " (中)",
                      style: TextStyle(fontSize: 20),
                    ),
                  if (TextScaling > 36 && TextScaling <= 54)
                    Text(
                      "目前大小：" + TextScaling.round().toString() + " (大)",
                      style: TextStyle(fontSize: 20),
                    ),
                  if (TextScaling > 54)
                    Text(
                      "目前大小：" + TextScaling.round().toString() + " (超大，你老花膩？)",
                      style: TextStyle(fontSize: 20),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: SliderTheme(
                      data: SliderThemeData(
                        year2023: false,
                        trackHeight: 15,
                        // valueIndicatorTextStyle: TextStyle(
                        //     fontSize: 20,
                        //     color: Theme.of(context).colorScheme.onPrimary,
                        //     fontWeight: FontWeight.w500
                        // )
                      ),
                      child: Slider(
                        value: TextScaling,
                        onChanged: (value) async {
                          TextScaling = value;
                          var prefs = await SharedPreferences.getInstance();
                          await prefs.setInt(
                              "savedTextSize", TextScaling.round());
                          setStateFunc();
                          setState(() {});
                        },
                        min: 12,
                        max: 72,
                        divisions: 10,
                        // label: TextScaling.round().toString(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      "預覽文字",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "資訊組真的很累，麻煩大家體諒一下。\n大家的資訊素質需要提升。",
                    style: TextStyle(fontSize: TextScaling),
                  )
                ],
              ),
            )));
  }
}
