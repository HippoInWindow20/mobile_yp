
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import "package:mobile_yp/color_schemes.g.dart";
import "package:mobile_yp/custom_color.g.dart";



class publicCC extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.background,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "公告欄",
        style: TextStyle(
          fontSize: 40
        ),),
        backgroundColor: lightColorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListCard(
              title: "Title 1",
              agency: "My agency",
              date: "2022/11/17",
            ),
            ListCard(
              title: "Title 1",
              agency: "My agency",
              date: "2022/11/17",
            ),
            ListCard(
              title: "Title 1",
              agency: "My agency",
              date: "2022/11/17",
            ),
          ]
        ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key, required this.title, required this.agency, required this.date,
  }) : super(key: key);
  final String title;
  final String agency;
  final String date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('Tapped!');
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        elevation: 0,
        color: lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 0,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(agency,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 0,bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(date,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}