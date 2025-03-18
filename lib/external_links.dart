import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mobile_yp/main.dart';

void _launchURL(BuildContext context, link) async {
  try {
    await launchUrl(
      link,
      customTabsOptions: CustomTabsOptions(
        colorSchemes:
            CustomTabsColorSchemes(colorScheme: CustomTabsColorScheme.system),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        animations: CustomTabsAnimations(
          startEnter: 'slide_in_right',
          startExit: 'slide_out_left',
          endEnter: 'slide_in_left',
          endExit: 'slide_out_right',
        ),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

class LinksOpen extends StatefulWidget {
  List links;
  List exts;

  LinksOpen({required this.links, required this.exts});

  @override
  State<LinksOpen> createState() => _LinksOpenState(links: links, exts: exts);
}

class _LinksOpenState extends State<LinksOpen> {
  @override
  List links;
  List exts;

  _LinksOpenState({required this.links, required this.exts});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // appBar: AppBar(
      //   title: Text("附件、連結"),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back,
      //         color: Theme.of(context).colorScheme.onBackground),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   actionsIconTheme:
      //       IconThemeData(color: Theme.of(context).colorScheme.onBackground),
      //   backgroundColor: Theme.of(context).colorScheme.background,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (links.length != 0)
                Text(
                  "附件",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 25),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    links.length,
                    (index) => Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      links[index][0].toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.file_download_outlined),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              links[index][1].toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      links[index][2].toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              _launchURL(
                                                  context, links[index][2]);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                    Icons.open_in_new_outlined),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    "開啟",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: links[index][2]));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content:
                                                          Text("已複製連結至剪貼簿")));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.copy_outlined),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    "複製連結",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
              if (exts.length != 0)
                Text(
                  "連結",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 25),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    exts.length,
                    (index) => Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exts[index][0].toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        exts[index][1].toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              _launchURL(
                                                  context, exts[index][1]);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                    Icons.open_in_new_outlined),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    "開啟",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: links[index][2]));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content:
                                                          Text("已複製連結至剪貼簿")));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.copy_outlined),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    "複製連結",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
